# E-Commerce-Sales-Delivery-Dashboard

An end-to-end ecommerce analytics project focused on understanding sales performance, customer behavior, delivery efficiency, payment methods, and customer satisfaction using SQL and Power BI.
## 🔗 View Dashboard & Analysis (PPT)
## https://app.presentations.ai/view/p8PVCYyPzC

## Business Objectives
The goal of this project is to analyze an ecommerce platform’s operations and answer key business questions such as:

- How is overall revenue and order volume performing over time?
- Which product categories and regions generate the highest revenue?
- How do customers behave across locations?
- How efficient is the delivery process? 
- How do payment methods and installments impact revenue?
- How does delivery performance affect customer reviews?

## Key KPIs
- Total Revenue
- Total Orders
- Average Order Value (AOV)
- Revenue Growth % vs Target
- Total Customers
- Delivery Rate and Late Delivery Rate
- Average Delivery Time
- Payment Method Distribution
- Installment Orders %
- Average Customer Review Score
  
## Dashboard Pages
- <img width="1258" height="804" alt="Excecutive_Overview" src="https://github.com/user-attachments/assets/b652be63-bb58-4d41-8050-5cb00cffaeb0" />
  <img width="1198" height="796" alt="Sales_Products" src="https://github.com/user-attachments/assets/3cb81b07-22fc-408f-8eb5-e5346fde2baf" />
  <img width="1444" height="809" alt="Customer_Geography" src="https://github.com/user-attachments/assets/f159d6fd-d330-4866-92bf-794d7805f21e" />
  <img width="1208" height="807" alt="Delivery_Payments" src="https://github.com/user-attachments/assets/6df51fe5-d2a5-4837-828a-ade2ec7aa5fd" />
  <img width="1042" height="804" alt="Payment_Analysis" src="https://github.com/user-attachments/assets/082f15a8-8cb4-4ba7-b587-1006467370be" />
  <img width="1149" height="805" alt="Customer_Review_Analysis" src="https://github.com/user-attachments/assets/786ef930-a316-4c6d-846d-166f1913c1d8" />
  
## Dashboard Detailed Insights

### 1. Executive Overview
- **Purpose:** Provides a high-level snapshot of business performance.
- **Key Metrics:**
  - Total Revenue: 2,000,000+ 
  - Total Orders: 120,000
  - Average Order Value (AOV): 159.33
  - Total Customers: 99,000
  - Delivery Rate: 97%
- **Insights:**
  - Revenue and order volume are steadily increasing month-over-month.
  - Average revenue per customer is consistent with AOV, indicating most customers place only 1–2 items per order.
  - Delivered orders are high, suggesting strong fulfillment efficiency.
- **Visuals Used:** KPI cards, trend lines for revenue & orders.


### 2. Sales & Product Performance
- **Purpose:** Understand which products and categories drive revenue.
- **Key Metrics:**
  - Top 5 product categories by revenue: (e.g., Electronics, Home Appliances, Beauty, etc.)
  - Average products per order: 1.13
- **Insights:**
  - Majority of revenue comes from top 3 product categories.
  - Orders mostly contain 1 item, indicating low cross-selling.
  - Top products by revenue identify potential focus areas for marketing and inventory.
- **Visuals Used:** Bar charts, scatter charts, KPI cards.


### 3. Customer & Geographic Analysis
- **Purpose:** Analyze customer distribution and revenue contribution by location.
- **Key Metrics:**
  - Customers by State: Highest in São Paulo, Minas Gerais
  - Revenue by State: Highest revenue from São Paulo
  - Unique vs Total Customers: 99k unique customers out of 120k total orders
- **Insights:**
  - São Paulo contributes both highest number of customers and revenue, highlighting strategic market.
  - States with lower revenue may be opportunities for targeted promotions.


### 4. Delivery Performance Analysis
- **Purpose:** Evaluate delivery efficiency and its impact on customer satisfaction.
- **Key Metrics:**
  - On-Time vs Late Deliveries: 97% on-time
  - Average Delivery Time: (e.g., 5 days)
  - Delivery Status by Category: Electronics orders slightly more delayed
- **Insights:**
  - High delivery rate indicates strong logistics.
  - Late deliveries are concentrated in certain categories/regions, which can be optimized.
  - Delivery delays correlate with lower review scores in the Reviews page.
- **Visuals Used:** Donut charts, column charts, KPI cards.


### 5. Payment Analysis
- **Purpose:** Track revenue trends by payment method and installment usage.
- **Key Metrics:**
  - Payment Methods: Credit Card (60%), Boleto (30%), Others (10%)
  - Installment Orders %: 15%
  - Revenue by Payment Method: Credit Card highest, Boleto mid-range
- **Insights:**
  - Credit card is the most popular payment method and drives most revenue.
  - Installment usage is significant but does not heavily impact revenue distribution.
  - Promotions could be designed for under-utilized payment options.
- **Visuals Used:** Pie charts, bar charts.


### 6. Customer Reviews & Satisfaction
- **Purpose:** Understand customer satisfaction and impact of delivery.
- **Key Metrics:**
  - Review Score Distribution: Majority 4–5 stars
  - Correlation: Late deliveries → lower review scores
- **Insights:**
  - High overall satisfaction, but delivery delays slightly reduce reviews.
  - Categories with more delayed shipments should be monitored for customer experience improvements.

## Tools & Technologies Used
- SQL (data exploration and analysis)
- Power BI (data modeling, DAX measures, and dashboard visualization)
- Excel / CSV (raw data format)

## Dataset Information
- Dataset: Olist Brazilian E-commerce Dataset
- Source: Kaggle
- Note: Raw dataset files are not uploaded due to GitHub file size limitations.

## Project Notes
- Revenue growth comparison was performed using available complete data from 2017 and partial data from 2018.
- Some product categories do not have English translations; original product categories were used to avoid data loss.
- Dashboard screenshots are provided for visualization reference.
## Power BI Dashboard File
The Power BI dashboard file (.pbix) is available for download using the link below:

[Download Power BI Dashboard (.pbix)](https://drive.google.com/file/d/1iKrq3ontrNdHFh0CHLwwRPCEu1wKqS9e/view?usp=sharing)

