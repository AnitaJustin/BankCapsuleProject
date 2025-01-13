<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Calculator</title>
    <link rel="stylesheet" href="loan.css">
</head>
<body>
    <header>
        <div class="logo">
            <img src="banklogo.png" alt="Bank Analyst Logo">
            <h2>Bank Analyst</h2>
        </div>
        <nav>
            <a href="home.jsp">Home</a>
            <a href="loan.jsp">Loan</a>
            <a href="viewBalance.jsp">View Balance</a>
            <a href="aboutus.html">About Us</a>
            <div class="search-bar">
                <input type="text" placeholder="Find">
                <span class="search-icon">🔍</span>
            </div>
        </nav>
    </header>
    <div class="loan-container">
        <h1>Maximum Loan Calculator</h1>
        <form id="loanForm">
            <label for="loanType">Select Loan Type:</label>
            <select id="loanType" name="loanType" required>
                <option value="home">Home Loan</option>
                <option value="personal">Personal Loan</option>
            </select>

            <label for="salary">Monthly Salary (in ₹):</label>
            <input type="number" id="salary" name="salary" required>

            <button type="button" onclick="calculateLoan()">Calculate</button>
        </form>

        <div id="result"></div>
    </div>

    <script src="loan.js">
    </script>
</body>
</html>