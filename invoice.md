# AWS Infrastructure Monthly Invoice & Cost Analysis

## Invoice Summary
**Total Monthly Cost: $656.50**

---

## Service Breakdown

### 🗄️ Database Services - $158.00 (24.1% of total)

#### Keycloak RDS Database - $121.00
- **Database Instance (Multi-AZ, db.t4g.medium)**: $94.00
  - 730 hours of on-demand Multi-AZ deployment
  - Medium instance size for high availability
- **Additional Backup Storage**: $23.00 (238 GB)
- **GP2 SSD Storage**: $5.00 (20 GB)

#### Main RDS Database - $37.00
- **Database Instance (Single-AZ, db.t4g.micro)**: $12.00
  - 730 hours of basic single-zone deployment
  - Micro instance for lightweight workloads
- **Additional Backup Storage**: $23.00 (238 GB)
- **GP2 SSD Storage**: $2.00 (20 GB)

### 🐳 Container Services (ECS) - $117.00 (17.8% of total)

#### Keycloak ECS Service - $72.00
- **vCPU Usage**: $59.00 (2 CPU cores)
- **Memory Usage**: $13.00 (4 GB RAM)

#### Application Services (5 services × $9.00 each) - $45.00
Each service includes:
- **agenticx**: $9.00 (0.25 vCPU, 0.5 GB)
- **backoffice**: $9.00 (0.25 vCPU, 0.5 GB)
- **consul**: $9.00 (0.25 vCPU, 0.5 GB)
- **nextjs**: $9.00 (0.25 vCPU, 0.5 GB)
- **spring-gateway**: $9.00 (0.25 vCPU, 0.5 GB)

### 🌐 Load Balancing - $36.00 (5.5% of total)

#### Application Load Balancers (2 × $18.00 each)
- **Main ALB**: $18.00 (730 hours + 0.34 LCU)
- **Keycloak ALB**: $18.00 (730 hours + 0.34 LCU)

### 🔄 Networking - $38.00 (5.8% of total)

#### NAT Gateway
- **Gateway Hours**: $33.00 (730 hours)
- **Data Processing**: $5.00 (111 GB)

### 💾 Storage & Backup - $25.00 (3.8% of total)

#### S3 RDS Backup Bucket - $25.00
- **Standard Storage**: $5.00 (225 GB)
- **Data Retrieval (SELECT)**: $5.00 (7,250 GB)
- **API Requests (GET/SELECT)**: $5.00 (12.5M requests)
- **API Requests (PUT/POST)**: $5.00 (1M requests)
- **Data Scanning**: $5.00 (2,500 GB)

### 📊 Logging (CloudWatch) - $120.00 (18.3% of total)

#### Log Groups (8 × $15.00 each)
- **ECS Service Logs**: $90.00 (6 services)
  - agenticx, backoffice, consul, nextjs, spring-gateway, xray-daemon
- **Keycloak Logs**: $15.00
- **RDS Logs**: $15.00

Each log group includes:
- Data Ingestion: $5.00 (10 GB)
- Insights Queries: $5.00 (1,000 GB scanned)
- Archival Storage: $5.00 (166 GB)

### 🛡️ Security & WAF - $14.00 (2.1% of total)

#### AWS WAF Web ACL
- **Monthly Usage**: $5.00
- **Request Processing**: $5.00 (8.33M requests)
- **Rules**: $3.00 (3 rules)
- **Managed Rule Groups**: $1.00 (1 group)

### 🔐 Secrets Management - $10.00 (1.5% of total)

#### AWS Secrets Manager (2 × $5.00 each)
- **DocDB Password**: $5.00 (100k API requests + storage)
- **RDS Password**: $5.00 (100k API requests + storage)

### 🏗️ Container Registry (ECR) - $25.00 (3.8% of total)

#### ECR Repositories (5 × $5.00 each)
- Storage for container images: 50 GB each
- Services: agenticx, backoffice, consul, nextjs, spring-gateway

### 🌍 DNS Management - $0.50 (0.1% of total)

#### Route53 Hosted Zone
- **Monthly hosting**: $0.50

---

## 💰 Cost Optimization Recommendations

### High Priority Savings (Potential: $180-220/month)

1. **CloudWatch Logging Optimization** (~$90-105/month savings)
   - **Current Cost**: $120/month for 8 log groups
   - **Recommendation**: Reduce log retention periods from archival to standard
   - **Action**: Set log retention to 30 days instead of permanent archival
   - **Savings**: 70-90% reduction in logging costs

2. **Database Right-sizing** (~$30-50/month savings)
   - **Keycloak RDS**: Consider downgrading from db.t4g.medium to db.t4g.small
   - **Multi-AZ**: Evaluate if high availability is needed for development/staging
   - **Storage**: Review backup retention policies (238 GB seems excessive)

3. **Container Resource Optimization** (~$20-30/month savings)
   - **Review vCPU/Memory allocation**: Some services may be over-provisioned
   - **Consider Fargate Spot**: For non-critical workloads

### Medium Priority Savings (Potential: $40-60/month)

4. **Load Balancer Consolidation** (~$18/month savings)
   - **Current**: 2 separate ALBs
   - **Recommendation**: Use path-based routing on single ALB
   - **Consideration**: May impact service isolation

5. **ECR Storage Management** (~$15-20/month savings)
   - **Current**: 50 GB per repository
   - **Recommendation**: Implement lifecycle policies to clean up old images
   - **Set retention**: Keep only last 10 images per repository

### Low Priority Savings (Potential: $10-20/month)

6. **NAT Gateway Optimization** (~$5-10/month savings)
   - **Review necessity**: Check if all services need NAT gateway access
   - **Consider NAT instances**: For lower traffic scenarios

7. **S3 Intelligent Tiering** (~$5-10/month savings)
   - **Enable automatic tiering**: For backup data that's rarely accessed

---

## 📈 Total Potential Monthly Savings: $250-350

**Optimized Monthly Cost Range: $300-400** (45-55% reduction)

### Implementation Priority:
1. ✅ **Start with logging optimization** (quickest wins)
2. ✅ **Review database sizing** (significant impact)
3. ✅ **Consolidate load balancers** (architectural decision needed)
4. ✅ **Optimize container resources** (requires performance testing)