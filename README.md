# 🛍️ E_COMMERCE_ANALYSIS_SQL
## Overview 📑

This project provides SQL queries and stored procedures to address different business requirements for an e-commerce system. 
It covers various reports such as top-selling products, revenue analysis, customer lifetime value, Inventory Stock Alerts,Shipping Delays..ETC.

---

## 🗂️ **Project Structure**  

### 1️⃣ **Database Setup**  
-  Created the `AMAZON_db` database.  
-  Designed and structured the necessary tables to reflect business operations.  

### 2️⃣ **Data Import**  
-  Inserted comprehensive sample data into the tables for realistic analysis.  

### 3️⃣ **Data Cleaning**  
-  Addressed **null values** and ensured the data's **integrity and reliability** for accurate analysis.  

### 4️⃣ **Business Problems Solved**  
-  Solved **15 real-world business challenges** using advanced SQL queries.  

---

## 🖼️ **Entity Relationship Diagram (ERD)**  

The ERD visually represents the relationships between tables in the database.  

 [Click here to view the ERD](https://github.com/Ritam333/E_COMMERCE_ANALYSIS_SQL/blob/main/ERD.png)  

---

## 🚀 Project Highlights

- **Top Selling Products**: Identify the top-selling products by total sales value.
- **Revenue by Category**: Calculate the revenue for each product category and its contribution to total sales.
- **Average Order Value**: Compute the average order value for customers who placed more than 5 orders.
- **Monthly Sales Trend**: Track the sales trend month by month for the past year.
- **Customers with No Purchases**: Find customers who have registered but never placed an order.
- **Least Selling Category by State**: Identify the least selling product category in each state.
- **Customer Lifetime Value**: Rank customers based on their lifetime value to the business.
- **Inventory Stock Alerts**: Get products with stock levels below a certain threshold.
- **Shipping Delays**: Identify orders where the shipping date was more than 3 days after the order date.
- **Payment Success Rates**: Calculate the percentage of successful payments across all orders.
- **Top Performing Sellers**: Identify the top-performing sellers based on sales value.
- **Product Profit Margin**: Calculate and rank products by their profit margin.
- **Most Returned Products**: Identify products with the highest return rate.
- **Inactive Sellers**: Identify sellers who haven't made any sales in the last 6 months.
- **Store Procedure for Sale**: A stored procedure that updates inventory stock after a sale.




---

## 📚 Learning Outcomes  

- Mastered **SQL essentials**: joins, aggregations, and subqueries.  
- Gained insights into  **sales trends**.  
- Enhanced **inventory and revenue management** through dynamic queries.  
- Strengthened skills in **data-driven decision-making** for business optimization.  














## 🔥 **Let’s Dive In**  

Want to explore the full project?  
📂 [Check out the repository](https://github.com/Ritam333/ZOMATO_DATA_ANALYSIS_SQL) and start the action!  

---  

**Before performing analysis, I ensured that the data was clean and free from null values where necessary. For instance:**

## Database Tables

### 1. Category Table  
This table stores information about product categories.

| **Column Name**   | **Data Type** | **Description**                              |
|--------------------|---------------|----------------------------------------------|
| `category_id`      | `INT` (Primary Key) | Unique identifier for the product category.   |
| `category_name`    | `VARCHAR(20)` | Name of the product category.                 |

---

### 2. Customers Table  
This table stores information about customers.

| **Column Name**   | **Data Type** | **Description**                          |
|--------------------|---------------|------------------------------------------|
| `customer_id`      | `INT` (Primary Key) | Unique identifier for the customer.      |
| `first_name`       | `VARCHAR(20)` | Customer's first name.                   |
| `last_name`        | `VARCHAR(20)` | Customer's last name.                    |
| `state`            | `VARCHAR(20)` | State where the customer resides.         |

---

### 3. Sellers Table  
This table contains information about sellers.

| **Column Name**   | **Data Type** | **Description**                          |
|--------------------|---------------|------------------------------------------|
| `seller_id`        | `INT` (Primary Key) | Unique identifier for the seller.       |
| `seller_name`      | `VARCHAR(25)` | Name of the seller.                      |
| `origin`           | `VARCHAR(10)` | Seller's origin location.                |

---

### 4. Products Table  
This table stores details about the products available for sale.

| **Column Name**   | **Data Type** | **Description**                                  |
|--------------------|---------------|--------------------------------------------------|
| `product_id`       | `INT` (Primary Key) | Unique identifier for the product.               |
| `product_name`     | `VARCHAR(50)` | Name of the product.                              |
| `price`            | `FLOAT`       | Selling price of the product.                    |
| `cogs`             | `FLOAT`       | Cost of goods sold for the product.              |
| `category_id`      | `INT` (Foreign Key: `category.category_id`) | Reference to the product's category. |

---

### 5. Orders Table  
This table stores information about orders placed by customers.

| **Column Name**   | **Data Type** | **Description**                                      |
|--------------------|---------------|------------------------------------------------------|
| `order_id`         | `INT` (Primary Key) | Unique identifier for the order.                     |
| `order_date`       | `DATE`        | Date the order was placed.                           |
| `customer_id`      | `INT` (Foreign Key: `customers.customer_id`) | Reference to the customer placing the order.         |
| `seller_id`        | `INT` (Foreign Key: `sellers.seller_id`) | Reference to the seller fulfilling the order.         |
| `order_status`     | `VARCHAR(15)` | Current status of the order (e.g., pending, completed). |

---

### 6. Order Items Table  
This table represents the individual items in an order.

| **Column Name**   | **Data Type** | **Description**                                   |
|--------------------|---------------|---------------------------------------------------|
| `order_item_id`    | `INT` (Primary Key) | Unique identifier for the order item.             |
| `order_id`         | `INT` (Foreign Key: `orders.order_id`) | Reference to the associated order.                |
| `product_id`       | `INT` (Foreign Key: `products.product_id`) | Reference to the product in the order.           |
| `quantity`         | `INT`        | Quantity of the product in the order.             |
| `price_per_unit`   | `FLOAT`      | Price per unit of the product.                    |

---

### 7. Payments Table  
This table tracks payment details for orders.

| **Column Name**   | **Data Type** | **Description**                                   |
|--------------------|---------------|---------------------------------------------------|
| `payment_id`       | `INT` (Primary Key) | Unique identifier for the payment.               |
| `order_id`         | `INT` (Foreign Key: `orders.order_id`) | Reference to the associated order.                |
| `payment_date`     | `DATE`        | Date the payment was made.                        |
| `payment_status`   | `VARCHAR(20)` | Status of the payment (e.g., completed, pending). |

---

### 8. Shippings Table  
This table captures information about the shipping of orders.

| **Column Name**   | **Data Type** | **Description**                                   |
|--------------------|---------------|---------------------------------------------------|
| `shipping_id`      | `INT` (Primary Key) | Unique identifier for the shipping.               |
| `order_id`         | `INT` (Foreign Key: `orders.order_id`) | Reference to the associated order.                |
| `shipping_date`    | `DATE`        | Date the order was shipped.                       |
| `return_date`      | `DATE`        | Date the order was returned, if applicable.       |
| `shipping_providers` | `VARCHAR(15)` | Name of the shipping provider.                   |
| `delivery_status`  | `VARCHAR(15)` | Current delivery status of the order.             |

---

### 9. Inventory Table  
This table tracks product inventory.

| **Column Name**   | **Data Type** | **Description**                                   |
|--------------------|---------------|---------------------------------------------------|
| `inventory_id`     | `INT` (Primary Key) | Unique identifier for the inventory record.       |
| `product_id`       | `INT` (Foreign Key: `products.product_id`) | Reference to the associated product.             |
| `stock`            | `INT`        | Number of units in stock.                         |
| `warehouse_id`     | `INT`        | Identifier for the warehouse storing the product. |
| `last_stock_date`  | `DATE`       | Date the stock was last updated.                  |

---

## Relationships

### Category Table:
- `category_id` is a primary key.

### Products Table:
- `category_id` is a foreign key referencing the **Category Table** (`category_id`).

### Customers Table:
- `customer_id` is a primary key.

### Orders Table:
- `customer_id` is a foreign key referencing the **Customers Table** (`customer_id`).
- `seller_id` is a foreign key referencing the **Sellers Table** (`seller_id`).

### Sellers Table:
- `seller_id` is a primary key.

### Order Items Table:
- `order_id` is a foreign key referencing the **Orders Table** (`order_id`).
- `product_id` is a foreign key referencing the **Products Table** (`product_id`).

### Payments Table:
- `order_id` is a foreign key referencing the **Orders Table** (`order_id`).

### Shippings Table:
- `order_id` is a foreign key referencing the **Orders Table** (`order_id`).

### Inventory Table:
- `product_id` is a foreign key referencing the **Products Table** (`product_id`).

---

### End of Documentation

