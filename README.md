# AI-Driven Data Pipeline for Threat Detection

An end-to-end cybersecurity data engineering and machine learning project that converts raw IDS network traffic logs into structured security intelligence using **Databricks, PySpark, SQL, Delta Lake, and Machine Learning**.

The project follows a **Bronze-Silver-Gold data pipeline architecture** and applies machine learning models to detect malicious network activity such as Bot, DoS, Infiltration, and other attack traffic.

---

## Project Overview

Cybersecurity teams generate large volumes of network traffic logs, but raw logs are difficult to analyze directly. This project demonstrates how raw IDS data can be processed, cleaned, validated, transformed, analyzed, and used for AI-based threat detection.

The pipeline performs the following steps:

1. Ingest raw IDS network traffic data into Databricks.
2. Store raw records in a Bronze layer.
3. Clean and standardize data in a Silver layer.
4. Create Gold analytics tables for security insights.
5. Perform data quality checks.
6. Train machine learning models for attack detection.
7. Compare model performance.
8. Identify important network features contributing to threat detection.

---

## Business / Security Problem

Security logs are often large, noisy, and difficult to analyze manually. Analysts need structured data and automated detection methods to identify suspicious traffic patterns faster.

This project solves that problem by building a data pipeline that:

- Converts raw IDS logs into analytics-ready tables
- Identifies attack distribution across network traffic
- Analyzes protocol and destination port behavior
- Detects malicious traffic using machine learning
- Highlights important network features for explainability
- Supports security monitoring and threat intelligence use cases

---

## Tech Stack

- Databricks
- PySpark
- Spark SQL
- Delta Lake
- Python
- Pandas
- NumPy
- Scikit-learn
- Matplotlib
- Seaborn
- Jupyter / Databricks Notebooks
- SQL

---

## Dataset

The project uses IDS network traffic CSV files containing packet-level and flow-level features.

Example raw files used in the project:

```text
Botnet-Friday-02-03-2018.csv
DoS2-Friday-16-02-2018.csv
Infil1-Wednesday-28-02-2018.csv
```

The dataset contains features such as:

- Destination port
- Protocol
- Timestamp
- Flow duration
- Forward packets
- Backward packets
- Packet length statistics
- Flow bytes per second
- Flow packets per second
- TCP flag counts
- Active and idle time statistics
- Attack label

---

## Architecture

```text
Raw IDS CSV Files
        |
        v
Bronze Layer
Raw ingested data with source file and ingestion timestamp
        |
        v
Silver Layer
Cleaned, standardized, deduplicated, ML-ready data
        |
        v
Gold Layer
Security analytics tables for label, protocol, and attack-port insights
        |
        v
Machine Learning Layer
Threat detection using Logistic Regression, Random Forest, and Isolation Forest
        |
        v
Model Evaluation and Feature Importance
```

---

## Project Workflow

### 1. Bronze Layer - Raw Data Ingestion

Notebook:

```text
notebooks/01_bronze_ingestion.ipynb
```

The Bronze layer reads raw IDS CSV files from Databricks storage and stores them in a structured Delta table.

Main tasks:

- Loaded raw IDS CSV files
- Preserved original network traffic records
- Added metadata columns such as:
  - `source_file`
  - `ingestion_time`
- Stored data in a Bronze Delta table

Example Bronze table:

```text
workspace.security_pipeline.bronze_ids
```

---

### 2. Silver Layer - Data Cleaning and Standardization

Notebook:

```text
notebooks/02_silver_cleaning.ipynb
```

The Silver layer prepares the data for analytics and machine learning.

Main tasks:

- Cleaned column names
- Converted timestamps
- Removed duplicate records
- Handled missing/null values
- Standardized label values
- Created encoded target column for ML:
  - `0` = Benign
  - `1` = Attack
- Created cleaned Silver Delta table

Example Silver table:

```text
workspace.security_pipeline.silver_ids
```

---

### 3. Gold Layer - Security Analytics

Notebook:

```text
notebooks/03_gold_analytics.ipynb
```

The Gold layer creates analytics-ready tables for security investigation and dashboarding.

Gold tables created:

```text
gold_label_distribution
gold_protocol_distribution
gold_attack_protocol
gold_attack_ports
```

These tables help answer questions such as:

- How much traffic is benign vs malicious?
- Which attack types appear most frequently?
- Which protocols are most used?
- Which destination ports are commonly associated with attacks?
- What traffic patterns are visible across attack categories?

---

## Gold Layer Insights

### Attack Label Distribution

The project analyzes different traffic labels such as:

```text
Benign
Bot
DoS attacks-Hulk
DoS attacks-SlowHTTPTest
Infilteration
```

Example insight:

```text
Benign traffic forms the majority of the dataset, while attack traffic includes Bot, DoS, and Infilteration categories.
```

---

### Protocol Distribution

The project analyzes protocol usage across the dataset.

Example protocol values:

```text
6  = TCP
17 = UDP
0  = HOPOPT / other protocol category
```

This helps identify which protocols are more commonly involved in normal and malicious traffic.

---

### Attack-Port Analysis

The project identifies destination ports frequently associated with attack traffic.

Example attack-port observations:

```text
DoS attacks-Hulk -> Port 80
Bot -> Port 8080
Infilteration -> Ports 53, 443, 3389, 445, 80
DoS attacks-SlowHTTPTest -> Port 21
```

This helps connect network behavior with possible threat patterns.

---

## 4. Data Quality Checks

Notebook:

```text
notebooks/04_data_quality_checks.ipynb
```

Data quality checks were performed on the Silver layer before using it for analytics and machine learning.

Checks performed:

- Total row count validation
- Column count validation
- Duplicate record check
- Important column null check
- Label distribution check
- Encoded label validation

Important columns checked for null values:

```text
label
protocol
dst_port
timestamp
```

Quality result:

```text
Duplicate rows: 0
Null values in important columns: 0
```

---

## 5. Machine Learning for Threat Detection

Notebook:

```text
notebooks/05_ml_detection.ipynb
```

The machine learning layer uses cleaned Silver data to classify traffic as benign or malicious.

Target column:

```text
label_encoded
```

Target mapping:

```text
0 = Benign
1 = Attack
```

Models implemented:

- Logistic Regression
- Random Forest
- Isolation Forest

---

## Model Performance

| Model | Accuracy | Attack Precision | Attack Recall | Attack F1-score |
|---|---:|---:|---:|---:|
| Logistic Regression | 93.10% | 86.97% | 91.91% | 89.37% |
| Random Forest | 96.26% | 96.73% | 91.21% | 93.89% |
| Isolation Forest | 44.13% | 9.63% | 9.21% | 9.42% |

---

## Best Model

The **Random Forest** model performed best overall.

Random Forest results:

```text
Accuracy: 96.26%
Attack Precision: 96.73%
Attack Recall: 91.21%
Attack F1-score: 93.89%
```

Random Forest was selected as the best-performing model because it achieved the strongest balance between accuracy, attack precision, attack recall, and F1-score.

---

## Feature Importance

Random Forest feature importance was used to understand which network features contributed most to threat detection.

Top important features included:

```text
fwd_pkts_s
bwd_seg_size_avg
fwd_iat_max
fwd_iat_tot
flow_pkts_s
fwd_header_len
dst_port
fwd_iat_mean
bwd_pkt_len_mean
flow_iat_max
```

These features show that packet rate, flow timing, packet segment size, header length, and destination port were important indicators for identifying malicious traffic.

---

## SQL Analysis

The repository also includes:

```text
SQL.sql
```

This file contains SQL queries for:

- Creating the security pipeline database
- Counting total records
- Analyzing label distribution
- Calculating traffic percentage by label
- Analyzing protocol distribution
- Identifying top destination ports for attack traffic

Example analysis:

```sql
SELECT label, COUNT(*) AS total_records
FROM infil2_cleaned
GROUP BY label;
```

```sql
SELECT dst_port, COUNT(*) AS total_records
FROM infil2_cleaned
WHERE label = 'Infilteration'
GROUP BY dst_port
ORDER BY total_records DESC
LIMIT 10;
```

---

## Repository Structure

```text
AI-Driven-Data-Pipeline-for-Threat-Detection/
│
├── README.md
├── SQL.sql
│
├── notebooks/
│   ├── 01_bronze_ingestion.ipynb
│   ├── 02_silver_cleaning.ipynb
│   ├── 03_gold_analytics.ipynb
│   ├── 04_data_quality_checks.ipynb
│   └── 05_ml_detection.ipynb
│
└── ml_results/
    ├── model_comparison.csv
    ├── model_features.csv
    └── rf_feature_importance.csv
```

---

## How to Run the Project

### Prerequisites

You need:

- Databricks workspace
- PySpark environment
- Delta Lake support
- IDS CSV files uploaded to Databricks storage
- Python ML libraries:
  - pandas
  - numpy
  - scikit-learn
  - matplotlib
  - seaborn

---

### Step 1: Upload Raw Data

Upload IDS CSV files to a Databricks volume or DBFS path.

Example path:

```text
/Volumes/workspace/security_pipeline/ids_raw/
```

---

### Step 2: Run Bronze Ingestion Notebook

Run:

```text
01_bronze_ingestion.ipynb
```

This creates the raw Bronze Delta table.

---

### Step 3: Run Silver Cleaning Notebook

Run:

```text
02_silver_cleaning.ipynb
```

This creates the cleaned Silver table.

---

### Step 4: Run Gold Analytics Notebook

Run:

```text
03_gold_analytics.ipynb
```

This creates Gold analytics tables for security insights.

---

### Step 5: Run Data Quality Checks

Run:

```text
04_data_quality_checks.ipynb
```

This validates row count, duplicates, nulls, and label consistency.

---

### Step 6: Run ML Detection Notebook

Run:

```text
05_ml_detection.ipynb
```

This trains and evaluates machine learning models for threat detection.

---

## Key Results

- Built an end-to-end Bronze-Silver-Gold data pipeline for IDS network traffic.
- Processed more than 2.5 million cleaned network traffic records.
- Created Gold analytics tables for label, protocol, and attack-port analysis.
- Performed data quality checks and removed duplicate records.
- Trained and compared Logistic Regression, Random Forest, and Isolation Forest models.
- Achieved best performance with Random Forest:
  - 96.26% accuracy
  - 96.73% attack precision
  - 91.21% attack recall
  - 93.89% attack F1-score
- Identified important attack indicators using feature importance analysis.

---

## Security Relevance

This project demonstrates how data engineering and machine learning can support cybersecurity operations by:

- Transforming raw network traffic into structured intelligence
- Detecting malicious activity automatically
- Supporting SOC-style investigation
- Identifying high-risk protocols and ports
- Providing explainable feature-level insights
- Helping analysts prioritize suspicious traffic patterns


## Future Enhancements

Possible improvements:

- Add MITRE ATT&CK mapping for detected attack categories
- Build a Streamlit or Power BI dashboard for SOC-style monitoring
- Add model explainability using SHAP
- Add automated pipeline scheduling
- Add anomaly scoring for unseen traffic
- Add alert severity levels such as Low, Medium, and High
- Add cloud deployment using Azure Databricks
- Add CI/CD workflow for notebook and pipeline version control
- Add real-time log ingestion using Kafka or Auto Loader


