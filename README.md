# Terraform Project Documentation

Ce document fournit des instructions sur la façon de configurer et de gérer ce projet Terraform.

## Prérequis

Avant de commencer, assurez-vous d'avoir les outils suivants installés :

*   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
*   [AWS CLI](https://aws.amazon.com/cli/)
*   [Infracost](https://www.infracost.io/docs/user_group/v0.10/installation/)

## Configuration Initiale

### 1. Configuration des Identifiants AWS

Pour que Terraform puisse interagir avec votre compte AWS, vous devez configurer vos identifiants. Le moyen le plus simple est de configurer votre `~/.aws/credentials` file:

```ini
[default]
aws_access_key_id = VOTRE_ACCESS_KEY
aws_secret_access_key = VOTRE_SECRET_KEY
```

### 2. Configuration du Backend Terraform

Le state de Terraform est stocké dans un bucket S3 pour la persistance et la collaboration. Vous devez configurer le fichier `live/my-project/backend.tf` avec le nom de votre bucket S3 et d'autres détails si nécessaire.

**Exemple de `live/my-project/backend.tf`:**

```terraform
terraform {
  backend "s3" {
    bucket         = "nom-de-votre-bucket-tfstate"
    key            = "my-project/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
```

Assurez-vous que le bucket S3 et la table DynamoDB (pour le verrouillage de l'état) existent avant d'exécuter Terraform.

## Structure du Projet

Le projet est structuré comme suit :

-   `live/`: Contient le code Terraform pour les différents environnements (ex: `my-project`).
    -   `my-project/`: Le code principal de l'infrastructure.
        -   `main.tf`: Le point d'entrée principal.
        -   `variables.tf`: Déclaration des variables.
        -   `outputs.tf`: Définition des sorties.
        -   `backend.tf`: Configuration du backend S3.
        -   `env/`: Contient les fichiers de variables (`.tfvars`) pour chaque environnement (ex: `develop.tfvars`, `production.tfvars`).
-   `modules/`: Contient les modules Terraform réutilisables (ex: `ecs_fargate`, `rds`, `vpc`). Chaque module a ses propres `main.tf`, `variables.tf`, et `outputs.tf`.

## Workspaces Terraform

Nous utilisons les workspaces Terraform pour gérer différents environnements (développement, production, etc.) avec la même base de code.

Pour lister les workspaces existants :
`terraform workspace list`

Pour créer un nouveau workspace :
`terraform workspace new <nom_du_workspace>`

Pour sélectionner un workspace :
`terraform workspace select <nom_du_workspace>`

Le workspace `develop` est utilisé pour l'environnement de développement.

## Commandes Courantes

Toutes les commandes doivent être exécutées depuis le répertoire `live/my-project`.

```shell
cd live/my-project
```

### Initialisation
Cette commande initialise le backend, télécharge les fournisseurs et les modules.
```shell
terraform init
```

### Formatage
Cette commande formate le code Terraform pour qu'il soit lisible et conforme aux conventions.
```shell
terraform fmt
```

### Planification
Cette commande crée un plan d'exécution. Pour l'environnement de développement, nous utilisons le fichier `develop.tfvars`.

```shell
terraform workspace select develop
terraform plan -var-file="env/develop.tfvars" 
or
terraform plan -var-file="env/develop.tfvars" -out="develop.tfplan"

```

## Estimation des Coûts avec Infracost

Infracost est utilisé pour estimer les coûts de l'infrastructure avant d'appliquer les changements.

### Configuration d'Infracost

1.  **Configurer l'API Key**:
    ```shell
    infracost auth login
    ```

2.  **Configuration du projet**:
    Infracost peut être configuré pour utiliser des détails spécifiques sur l'utilisation des ressources pour des estimations plus précises. Ceci est fait via le fichier `live/my-project/infracost-usage.yml`.

### Exécuter Infracost

Pour obtenir une estimation des coûts pour l'environnement de développement (this should be executed in the live/my-project) :

```shell
infracost breakdown --path develop.tfplan --usage-file infracost-usage.yml
```

Pour voir la différence de coût par rapport à l'état actuel :

```shell
infracost diff --path . --terraform-var-file env/develop.tfvars --usage-file infracost-usage.yml
```

### Application (Preferably to be done after cost estimation)
Pour appliquer les changements (après avoir vérifié le plan).
```shell
terraform apply -var-file="env/develop.tfvars"
```

## Automatisation du Déploiement avec GitHub Actions

L'intégration continue et le déploiement continu (CI/CD) sont gérés via GitHub Actions. Le workflow actuel, défini dans `.github/workflows/terraform.yml`, est configuré pour valider, planifier et estimer les coûts de l'infrastructure à chaque push sur la branche `master`.

### État Actuel du Workflow

Le pipeline exécute les étapes suivantes :
1.  **Checkout Code**: Récupère le code source.
2.  **Configure AWS Credentials**: Configure les identifiants AWS pour interagir avec votre compte.
3.  **Setup Terraform**: Installe la version spécifiée de Terraform.
4.  **Terraform Format Check**: Vérifie que le code est bien formaté.
5.  **Terraform Init**: Initialise le répertoire de travail.
6.  **Terraform Validate**: Valide la syntaxe du code Terraform.
7.  **Terraform Plan**: Crée un plan d'exécution pour l'environnement `develop`.
8.  **Infracost Cost Estimate**: Estime les coûts à l'aide d'Infracost.

Actuellement, le workflow ne déploie pas automatiquement les changements. L'étape `apply` doit être exécutée manuellement.

### Activer le Déploiement Automatique

Pour automatiser le déploiement, vous pouvez ajouter une étape `terraform apply` au fichier `.github/workflows/terraform.yml`. Cette étape appliquera le plan généré.

**Exemple d'étape `apply` à ajouter au workflow :**

```yaml
      - name: 🚀 Terraform Apply (develop only)
        if: github.ref == 'refs/heads/master' && github.event_name == 'push'
        run: terraform apply -auto-approve develop.tfplan
        working-directory: live/my-project
```

**Important:**
*   L'ajout d'un `apply` automatique doit être fait avec prudence. Il est recommandé de n'appliquer automatiquement que sur des environnements de non-production comme `develop`.
*   Pour les environnements de production (`preprod`, `prod`), il est préférable de déclencher le déploiement manuellement après une revue du plan, par exemple via une approbation manuelle sur une pull request ou un `workflow_dispatch`.
*   Assurez-vous de bien protéger vos branches (`master`, `main`) pour éviter les déploiements non désirés.

## Comment Ajouter un Nouveau Service dans le Cluster ECS

Pour ajouter un nouveau service au cluster ECS Fargate, vous devez :

1.  **Créer un nouveau module de service (si nécessaire)**: Si le service a une configuration très spécifique, vous pouvez créer un nouveau module. Sinon, vous pouvez réutiliser un module existant.

2.  **Ajouter une définition de tâche ECS**: Dans votre code Terraform (probablement dans `modules/ecs_fargate/main.tf` ou un fichier similaire), ajoutez une ressource `aws_ecs_task_definition`.

3.  **Ajouter un service ECS**: Ajoutez une ressource `aws_ecs_service` qui utilise la définition de tâche que vous venez de créer.

4.  **Configurer le routage (si nécessaire)**: Si le service doit être accessible via une URL, configurez l'ALB (Application Load Balancer) pour router le trafic vers le nouveau service. Cela implique de créer/modifier un `aws_lb_target_group` et une `aws_lb_listener_rule`.

5.  **Ajouter les variables nécessaires**: Ajoutez les nouvelles variables (comme l'image Docker, le port, etc.) dans `variables.tf` et définissez leurs valeurs dans les fichiers `.tfvars` de l'environnement.

**Exemple (simplifié) dans `live/my-project/main.tf`:**

```terraform
module "new_service" {
  source = "../modules/ecs_fargate"

  # Variables pour le nouveau service
  service_name      = "mon-nouveau-service"
  docker_image      = "mon-image:latest"
  cpu               = 512
  memory            = 1024
  container_port    = 8080
  # ... autres variables
}