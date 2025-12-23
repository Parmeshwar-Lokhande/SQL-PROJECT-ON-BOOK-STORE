-- Create Database
CREATE DATABASE onlinebookstore;

-- Switch to the database 
\c onlinebookstore;

-- Create Tables 
DROP TABLE IF EXISTS Books;

CREATE TABLE Books(
 book_id SERIAL PRIMARY KEY,
 Title VARCHAR (100),
 Author VARCHAR (100), 
 Genre VARCHAR (50),
 Published_year INT,
 Price NUMERIC (10,2),
 Stock INT 
); 

DROP TABLE IF EXISTS customers ;

CREATE TABLE Customers (
		Customer_ID SERIAL PRIMARY KEY ,
		NAME VARCHAR (100), 
		Email VARCHAR (100), 
		Phone VARCHAR (15),
		City VARCHAR (50), 
		Country VARCHAR (150) 
);

DROP TABLE IF EXISTS orders;

CREATE TABLE Orders (
		order_id SERIAL PRIMARY KEY,
		customer_id INT REFERENCES Customers(CUSTOMER_ID),
		Book_id INT REFERENCES Books (Book_id),
		order_date DATE,
		quantity INT ,
		Total_amount NUMERIC (10,2)
);

SELECT * FROM BOOKS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;

-- IMPORT DATA INTO BOOKS TABLE 

COPY BOOKS (BOOK_ID, TITLE, AUTHOR, GENRE, PUBLISHED_YEAR , PRICE, STOCK)
FROM '‪C:\Users\anike\Downloads\Books.csv'
DELIMITER ','
CSV HEADER;

--IMPORT DATA INTO CUSTOMER TABLE 

COPY Customers (customer_id, name, email, phone, city, country)
FROM '‪C:\Users\anike\OneDrive\Documents\Customers.csv'
CSV HEADER;

--IMPORT DATA INTO ORDERS TABLE
COPY Orders (order_id, customer_id, book_id, order_date, quantity, total_amount)
FROM '‪‪C:/Users/anike/OneDrive/Documents/Orders.csv.csv'
CSV HEADER;


--1) Retrives all books in the 'Fiction' genre:

SELECT * FROM books
WHERE Genre = 'Fiction';

--2) Find books published after the year 1950:
SELECT * FROM Books
WHERE published_year>1950;

--3) List all customers from the canada: 
SELECT * FROM  Customers
WHERE country = 'Canada';

--4) Show order placed in november 2023:

SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrives the total stocks of book avilable :

SELECT SUM(stock) AS Total_Stock
FROM books;

--6) Find the details of the most expensive book :

SELECT
		*
	FROM
		BOOKS
	ORDER BY
		PRICE DESC
	LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book :

SELECT * FROM orders
WHERE quantity > 1; 

--8) Retrive all orders where the total amount exceeds $20 : 

SELECT * FROM orders
WHERE total_amount > 20; 

--9) List all genres available in the books table: 

SELECT DISTINCT genre FROM Books;

--10) Find the book with the lowest stock :

SELECT * FROM Books ORDER BY stock limit 1;

--11) Calculate the total revenue generated from all orders :

SELECT SUM (total_amount) AS Revenue  FROM Orders; 

--** ADVANCED QUESTIONS :

--1) Retrive the total number of books sold for each genre:

SELECT b.Genre, SUM (o.Quantity)  AS Total_Books_sold
FROM Orders o 
JOIN Books b ON o. book_id = b.book_id 
GROUP BY b.Genre;

--2) Find the average price of book in the 'Fantasy' Genre :

SELECT AVG (price) AS Average_Price
FROM Books 
WHERE Genre = 'Fantasy';

--3) List customers who have placed at least 2 orders :

SELECT o.customer_id, c.name, COUNT(o.order_id)	 AS ORDER_COUNT
FROM orders o
JOIN Customers c ON o. customer_id = c. customer_id 
GROUP BY o.customer_id , c.name 
HAVING COUNT (ORDER_ID) >=2;

--4) Find the most frequently ordered book :

SELECT o.book_id, b.title , COUNT (o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id = b.book_id 
GROUP BY o.book_id ,b.title
ORDER BY ORDER_COUNT DESC LIMIT 1 ;

--5) Show the top 3 most expensive book of 'Fantasy' GENRE:

SELECT * FROM BOOKS
WHERE Genre = 'Fantasy'
ORDER BY PRICE DESC LIMIT 3;

--6) Retrive the total quantity of book sold by each author  :

SELECT b. author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id= b.book_id
GROUP BY b.author ;

--7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city ,total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30 ;


-- 8) Find the customers who spent the most on orders:

SELECT c.customer_id, c.name, SUM (o. total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id , c.name
ORDER BY Total_Spent DESC LIMIT 1 ;


--9) Calculate the stock remaining after fulfiling all orders :

SELECT b.book_id, b.title , b.stock , COALESCE (SUM(o.quantity),0) AS order_quantity,
	 b.stock - COALESCE (SUM(o.quantity),0) AS Remaining_Quantity
FROM books b 
LEFT JOIN orders o ON o.book_id = b.book_id
GROUP BY b. book_id ORDER BY b. book_id;



























