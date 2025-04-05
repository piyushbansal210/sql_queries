# sql_queries

# 🚗 ST Car Dealership Database Project

A fully normalized relational database for managing a car dealership’s operations, built using MySQL. This project covers the creation of tables, realistic data insertion, and a variety of SQL queries that demonstrate strong data handling and analysis capabilities.

---

## 📆 Project Overview

This project simulates the back-end database of a modern car dealership. It handles customers, vehicle inventories, test drives, sales transactions, payment tracking, finance options, trade-ins, and aftermarket add-ons.

The database is designed using **normalized principles** with referential integrity, constraints, and real-world data patterns.

---

## 📁 Features

- 🔧 Normalized schema with 15+ interconnected tables  
- 👥 Tracks customers, addresses, salespeople, and test drives  
- 🚙 Vehicle inventory including both new and pre-owned vehicles  
- 💰 Sales, payment (cash and banking), and trade-in tracking  
- 💪 Add-on options for aftermarket upgrades (e.g., tinting, dash cams)  
- 🔢 Sample business intelligence queries using `JOIN`, `GROUP BY`, `VIEW`, `SUBQUERY`, etc.  

---

## 📑 Database Schema

The schema includes:
- **Customer & Address** tables for contact info
- **Vehicle, PreOwnedVehicle & VehicleImage** for vehicle details
- **TestDrive** for customer test drives
- **Sales & Salesperson** for transaction details
- **Payment, CashPayment, BankingFinance** for payments & loans
- **TradeIn** for old vehicle exchanges
- **AftermarketOption & SalesOption** for extra vehicle features

All tables enforce **data integrity** with constraints like `CHECK`, `UNIQUE`, `FOREIGN KEY`, and `ENUM` types.

---

## 🔬 Sample SQL Queries

The project includes practical SQL queries such as:

- `JOIN` multiple tables to show complete sales history
- `SUBQUERY` to find unsold vehicles
- `VIEW` to encapsulate recent sales

> All queries are documented in the `Store.sql` file.

---

## 📚 How to Use

1. **Clone the Repository**
```bash
git clone https://github.com/piyushbansal210/sql_queries.git
```

2. **Import the SQL File**
```bash
mysql -u your_user -p < store.sql
```

3. **Start Querying!**
```sql
USE ST;
SELECT * FROM Sales;
```

---

## 🎓 Learning Outcomes

- Understand and apply **relational database design**
- Use SQL features like **constraints, joins, views, aggregates**
- Design **realistic business logic and data**
- Write clean, documented SQL scripts

---

## 🌐 Author

**Piyush Bansal**  
Master’s in Computer Science Engineering, The University of Sydney 
[Email](mailto:piyushbansal210@gmail.com)



