#1. Management wants a clean customer directory. Display customer name, city and customer type, arranged alphabetically by customer name.
SELECT CustomerName,City,CustomerType
FROM Customer
ORDER BY CustomerName ASC;

#2. Show all products with their category names and selling prices. Which products belong to the Electronics category?
SELECT
    p.ProductName,
    c.CategoryName,
    p.UnitPrice
FROM Products p
INNER JOIN Categories c
ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Electronics';

#3. Find products whose available stock is below 15 units. Add a column that labels them as 'Reorder Required' or 'Stock Available'.
SELECT
    ProductName,
    StockQty,
    CASE
        WHEN StockQty < 15 THEN 'Reorder Required'
        ELSE 'Stock Available'
    END AS StockStatus
FROM Products;

#4. Display each order with the customer name, order date and current order status.
SELECT
    o.OrderID,
    c.CustomerName,
    o.OrderDate,
    o.OrderStatus
FROM Orders o
INNER JOIN Customer c
ON o.CustomerID = c.CustomerID;

#5. Prepare an order-wise bill summary showing order ID, total quantity and order value. Use the quantity and selling price in OrderDetails.
SELECT
    OrderID,
    SUM(Quantity) AS TotalQuantity,
    SUM(Quantity * SellingPrice) AS OrderValue
FROM OrderDetails
GROUP BY OrderID
ORDER BY OrderID;

#6. Which 5 products have generated the highest sales value? Show product name, units sold and sales value.
SELECT
    p.ProductName,
    SUM(od.Quantity) AS UnitsSold,
    SUM(od.Quantity * od.SellingPrice) AS SalesValue
FROM OrderDetails od
INNER JOIN Products p
ON od.ProductID = p.ProductID
INNER JOIN Orders o
ON od.OrderID = o.OrderID
WHERE o.OrderStatus <> 'Cancelled'
GROUP BY p.ProductID, p.ProductName
ORDER BY SalesValue DESC
LIMIT 5;

#7. Find customers who have placed more than one order. Show their name and number of orders.
SELECT
    c.CustomerName,
    COUNT(o.OrderID) AS NumberOfOrders
FROM Customer c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1;

#8. Show total order value city-wise. Which customer city contributes the highest value?
SELECT
    c.City,
    SUM(od.Quantity * od.SellingPrice) AS TotalOrderValue
FROM Customer c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
ON o.OrderID = od.OrderID
WHERE o.OrderStatus <> 'Cancelled'
GROUP BY c.City
ORDER BY TotalOrderValue DESC;

#9. Compare the number of orders in May 2026 and June 2026. Display the month and order count.
SELECT
    DATE_FORMAT(OrderDate, '%M %Y') AS OrderMonth,
    COUNT(OrderID) AS TotalOrders
FROM Orders
WHERE OrderDate BETWEEN '2026-05-01' AND '2026-06-30'
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate),
    DATE_FORMAT(OrderDate, '%M %Y')
ORDER BY
    YEAR(OrderDate),
    MONTH(OrderDate);
    
#10. Management wants to know how customers pay. Show number of payments and total amount by payment mode.
SELECT
    PaymentMode,
    COUNT(PaymentID) AS NumberOfPayments,
    SUM(Amount) AS TotalAmount
FROM Payments
GROUP BY PaymentMode;

#11. Find orders where payment is still Pending. Display customer name, order ID, order value and payment status.
SELECT
    c.CustomerName,
    o.OrderID,
    SUM(od.Quantity * od.SellingPrice) AS OrderValue,
    p.PaymentStatus
FROM Customer c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
ON o.OrderID = od.OrderID
INNER JOIN Payments p
ON o.OrderID = p.OrderID
WHERE p.PaymentStatus = 'Pending'
GROUP BY c.CustomerName, o.OrderID, p.PaymentStatus;

#12. Identify cancelled orders and show the related customer name and payment status. Why should these orders be reviewed separately in a sales report?
SELECT
    c.CustomerName,
    o.OrderID,
    o.OrderStatus,
    p.PaymentStatus
FROM Orders o
INNER JOIN Customer c
ON o.CustomerID = c.CustomerID
LEFT JOIN Payments p
ON o.OrderID = p.OrderID
WHERE o.OrderStatus = 'Cancelled';

#13. Find customers who have registered but have not placed any order.
SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    c.CustomerType
FROM Customer c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

#14. List products that have never been ordered. Include their category and current stock.
SELECT
    p.ProductName,
    c.CategoryName,
    p.StockQty
FROM Products p
INNER JOIN Categories c
ON p.CategoryID = c.CategoryID
LEFT JOIN OrderDetails od
ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;

#15. Show delivery status count, including On Time, Delayed and In Transit.
SELECT
    DeliveryStatus,
    COUNT(DeliveryID) AS TotalDeliveries
FROM Deliveries
GROUP BY DeliveryStatus;

#16. Find deliveries where the actual delivery date was more than 2 days after dispatch. Display the number of days taken.
SELECT
    DeliveryID,
    OrderID,
    DispatchDate,
    DeliveryDate,
    DATEDIFF(DeliveryDate, DispatchDate) AS DaysTaken
FROM Deliveries
WHERE DeliveryDate IS NOT NULL
AND DATEDIFF(DeliveryDate, DispatchDate) > 2;

#17. Calculate average order value for each customer. Show only customers whose average order value is above n1,500.
SELECT
    CustomerName,
    AVG(OrderValue) AS AverageOrderValue
FROM (
    SELECT
        c.CustomerID,
        c.CustomerName,
        o.OrderID,
        SUM(od.Quantity * od.SellingPrice) AS OrderValue
    FROM Customer c
    INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od
    ON o.OrderID = od.OrderID
    WHERE o.OrderStatus <> 'Cancelled'
    GROUP BY c.CustomerID, c.CustomerName, o.OrderID
) AS CustomerOrders
GROUP BY CustomerID, CustomerName
HAVING AVG(OrderValue) > 1500;

#18. Show each category's total sales value and number of units sold. Sort from highest sales value to lowest.
SELECT
    c.CategoryName,
    SUM(od.Quantity * od.SellingPrice) AS TotalSalesValue,
    SUM(od.Quantity) AS TotalUnitsSold
FROM Categories c
INNER JOIN Products p
ON c.CategoryID = p.CategoryID
INNER JOIN OrderDetails od
ON p.ProductID = od.ProductID
INNER JOIN Orders o
ON od.OrderID = o.OrderID
WHERE o.OrderStatus <> 'Cancelled'
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalSalesValue DESC;

#19. Use a subquery to find products priced above the average price of all products.
SELECT
    ProductName,
    UnitPrice
FROM Products
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Products
);

#20. Create a view named vw_order_summary containing order ID, customer name, order date, status and total order value.
#view is creted name is order_summ


