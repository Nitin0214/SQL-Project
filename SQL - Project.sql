-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
Use OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID Int PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
BULK INSERT [dbo].[Books]
FROM 'C:\Users\nitin\Downloads\Books.csv'
WITH (FIRSTROW=2
      , FIELDTERMINATOR = ','
      , ROWTERMINATOR = '0x0a')

-- Import Data into Customers Table
BULK INSERT [dbo].[Customers]
FROM 'C:\Users\nitin\Downloads\Customers.csv'
WITH (FIRSTROW=2
      , FIELDTERMINATOR = ','
      , ROWTERMINATOR = '0x0a')

-- Import Data into Orders Table
BULK INSERT [dbo].[Orders]
FROM 'C:\Users\nitin\Desktop\Excel Assignments\Orders.csv'
WITH (FIRSTROW=2
      , FIELDTERMINATOR = ','
      , ROWTERMINATOR = '0x0a')

------------------------------------------------Question and Answers------------------------------------------------

--1) Retrieve all books in the "Fiction" genre
Select * from Books where Genre = 'fiction'

--2) Find books published after the year 1950
Select * from Books  where Published_Year > 1950

--3) List all customers from the Canada
Select * from Customers where Country = 'Canada'

--4) Show orders placed in November 2023

Select * from Orders where Year(Order_Date) = 2023 order by Order_Date

--5) Retrieve the total stock of books available
Select sum(quantity) total_stocks from orders

--6) Find the details of the most expensive book

Select top 1 * from Books order by Price desc

--7) Show all customers who ordered more than 1 quantity of a book
Select * from Orders where Quantity > 1

--8) Retrieve all orders where the total amount exceeds $20
Select * from Orders where Total_Amount  >20

--9) List all genres available in the Books table
Select distinct Genre from Books

--10) Find the book with the lowest stock
Select top 1 * from Orders order by Quantity asc

--11) Calculate the total revenue generated from all orders
Select SUM(total_amount) Revenue
	from orders

--12) Retrieve the total number of books sold for each genre
Select b.genre, sum(Quantity) book_sold 
	from Orders o inner join Books b on o.Book_ID = b.Book_ID 
group by b.Genre

--13) Find the average price of books in the "Fantasy" genre
Select AVG(price) average_price from Books where Genre = 'Fantasy'

--14) List customers who have placed at least 2 orders
Select Customer_ID, COUNT(Order_id) Orders_count
	from orders 
group by Customer_ID 
having COUNT(Order_id) >=2

--15) Find the most frequently ordered book
Select Book_ID, count(order_id) order_count 
	from Orders 
group by Book_ID 
order by order_count desc

--16) Show the top 3 most expensive books of 'Fantasy' Genre
select top 3 * from Books where Genre = 'fantasy' order by Price desc

--17) Retrieve the total quantity of books sold by each author
Select b.Author, SUM(quantity) Total_book_sold
	from Books b inner join Orders o on b.Book_ID = o.Book_ID
group by b.Author 
order by Total_book_sold desc

--18) List the cities where customers who spent over $30 are located
Select distinct City, total_amount
	from Customers C join Orders O on C.Customer_ID = O.Customer_ID
	where Total_Amount > 30 

--19) Find the customer who spent the most on orders
Select c.Customer_ID, Name, SUM(total_amount) Total_spent
from Customers c join Orders o on c.Customer_ID = o.Customer_ID
group by c.Customer_ID, Name order by Total_spent desc

--20) Calculate the stock remaining after fulfilling all orders
Select b.Book_ID, Title, Stock, Coalesce(sum(Quantity),0) Order_quantity,
stock - Coalesce(sum(Quantity),0) Remaining_QTY 
	from Books b left join Orders o on b.Book_ID = o.Book_ID
	group by b.Book_ID, Title, Stock
