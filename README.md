# Insights-to-Management-in-Consumer-Goods-Domain

## Overview

Atliq Hardware, a leading computer hardware producer in India with a global presence, aims to enhance its data-driven decision-making capabilities. To address this need, the company is expanding its data analytics team by hiring skilled junior data analysts. To identify the right talent, Tony Sharma, the Data Analytics Director, has initiated a SQL challenge..

## Project Description

As a Data Analyst, I have contributed to Atliq Hardware by providing insights through various ad-hoc requests. This project demonstrates my ability to handle these requests using advanced SQL techniques.

## Key Learning Objectives

- **SQL Syntax Mastery**: Practicing SQL to improve proficiency.
- **Common Table Expressions (CTEs)**: Utilizing CTEs for complex query structuring.
- **Window Functions**: Applying window functions for advanced data analysis.
- **Analytical Techniques**: Employing various analytical methods to validate query results.

## Challenge Background

Atliq Hardware's management observed a lack of actionable insights for quick and informed decision-making. To address this, they decided to bolster their data analytics team. The SQL challenge designed by Tony Sharma aims to evaluate candidates' technical and soft skills, ensuring they are well-equipped for the role.

## Data Schema

### Tables and Columns

**dim_customer**
- **customer_code** (int, UN)
- **customer** (varchar(150))
- **platform** (varchar(45))
- **channel** (varchar(45))
- **market** (varchar(45))
- **sub_zone** (varchar(45))
- **region** (varchar(45))

**dim_product**
- **product_code** (varchar(45))
- **division** (varchar(45))
- **segment** (varchar(45))
- **category** (varchar(45))
- **product** (varchar(200))
- **variant** (varchar(45))

**fact_gross_price**
- **product_code** (varchar(45))
- **fiscal_year** (year)
- **gross_price** (decimal(15,4), UN)

**fact_manufacturing_cost**
- **product_code** (varchar(45))
- **cost_year** (year)
- **manufacturing_cost** (decimal(15,4), UN)

**fact_pre_invoice_deductions**
- **customer_code** (int, UN)
- **fiscal_year** (year)
- **pre_invoice_discount_pct** (decimal(5,4))

**fact_sales_monthly**
- **date** (date)
- **product_code** (varchar(45))
- **customer_code** (int, UN)
- **sold_quantity** (int, UN)
- **fiscal_year** (year)
