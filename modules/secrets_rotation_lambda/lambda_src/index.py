import boto3
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_secret(secret_arn):
    """Retrieves the secret from AWS Secrets Manager."""
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_arn)
    return json.loads(response['SecretString'])

def update_secret(secret_arn, new_secret_string):
    """Updates the secret in AWS Secrets Manager."""
    client = boto3.client('secretsmanager')
    client.put_secret_value(SecretId=secret_arn, SecretString=json.dumps(new_secret_string))
    logger.info(f"Secret {secret_arn} updated in Secrets Manager.")

def get_db_connection(host, port, username, password, dbname):
    """Establishes a database connection (placeholder)."""
    # In a real scenario, you would use a database connector like psycopg2
    # For this example, we'll just log the connection details.
    logger.info(f"Attempting to connect to DB: {username}@{host}:{port}/{dbname}")
    # Simulate a successful connection
    return True

def rotate_rds_secret(secret_arn, client):
    """
    Rotates the RDS database secret.
    This is a simplified example. A full implementation would involve:
    1. Getting the current secret.
    2. Generating a new password.
    3. Updating the database with the new password.
    4. Updating the secret in Secrets Manager with the new password.
    """
    logger.info(f"Starting rotation for secret: {secret_arn}")

    # 1. Get the current secret
    current_secret = get_secret(secret_arn)
    db_username = current_secret['username']
    db_password = current_secret['password']
    db_host = current_secret['host']
    db_port = current_secret['port']
    db_name = current_secret.get('dbname', 'postgres') # Default to 'postgres' if not specified

    # 2. Generate a new password (simplified for this example)
    # In a real scenario, use a strong password generation library
    new_password = db_password + "_new" # Placeholder for new password

    # 3. Update the database with the new password
    # This part would involve connecting to the RDS instance and executing ALTER USER
    # For demonstration, we'll just log it.
    logger.info(f"Updating password for user {db_username} in database {db_name} on {db_host}")
    # Simulate DB update
    db_updated = get_db_connection(db_host, db_port, db_username, new_password, db_name)

    if not db_updated:
        logger.error("Failed to update database password.")
        raise Exception("Database password update failed.")

    # 4. Update the secret in Secrets Manager with the new password
    new_secret = current_secret.copy()
    new_secret['password'] = new_password
    update_secret(secret_arn, new_secret)

    logger.info(f"Successfully rotated secret: {secret_arn}")

def lambda_handler(event, context):
    """
    Handles the Lambda invocation for secret rotation.
    """
    logger.info("Lambda received event: " + json.dumps(event))
    client = boto3.client('secretsmanager')

    secret_arn = event['SecretId']
    token = event['ClientRequestToken']
    step = event['Step']

    # Make sure the secret exists
    describe_secret_response = client.describe_secret(SecretId=secret_arn)

    if not describe_secret_response['RotationEnabled']:
        raise ValueError(f"Secret {secret_arn} is not enabled for rotation.")

    # Check if the secret has a version with the specified token
    versions = describe_secret_response['VersionIdsToStages']
    if token not in versions:
        raise ValueError(f"Secret version with token {token} not found.")

    if step == 'createSecret':
        # This step is typically used to create a new version of the secret
        # with a new password, but not yet apply it to the database.
        # For RDS, the rotation function handles this internally.
        logger.info("CreateSecret step - not applicable for RDS rotation in this simplified example.")
        pass

    elif step == 'setSecret':
        # This step is used to set the new password in the database.
        rotate_rds_secret(secret_arn, client)

    elif step == 'testSecret':
        # This step is used to test the new password.
        logger.info(f"Testing secret for {secret_arn} with token {token}")
        # In a real scenario, connect to the DB with the new credentials
        # and perform a simple query to verify.
        current_secret = get_secret(secret_arn)
        db_username = current_secret['username']
        db_password = current_secret['password']
        db_host = current_secret['host']
        db_port = current_secret['port']
        db_name = current_secret.get('dbname', 'postgres')
        
        if not get_db_connection(db_host, db_port, db_username, db_password, db_name):
            raise Exception("Failed to connect to DB with new secret.")
        logger.info("Secret test successful.")

    elif step == 'finishSecret':
        # This step is used to mark the new version as current.
        client.update_secret_version_stage(
            SecretId=secret_arn,
            VersionStage="AWSCURRENT",
            MoveToVersionId=versions[token][0],
            RemoveFromVersionId=versions['AWSPENDING'][0] if 'AWSPENDING' in versions else None
        )
        logger.info(f"Finished rotation for secret: {secret_arn}")

    else:
        raise ValueError(f"Invalid step parameter: {step}")

    return { 'statusCode': 200 }