<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Analyst</title>
    <link rel="stylesheet" href="hstyle.css">
</head>
<body>
    <header>
        <div class="logo">
            <img src="banklogo.png" alt="Bank Analyst Logo">
            <h1>Bank Analyst</h1>
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

    <div id="welcomeAlert" class="alert">
        <span id="alertMessage"></span>
        <span class="close-btn" onclick="closeAlert()">×</span>
    </div>
    
    

    <main>
       
        <div class="text-content">
            <h2>Simplify Loans, Track Balances, and Generate Mini Statements in a Tap!</h2>
            <button>Click Now</button>
        </div>
        <div class="icon-circle"></div>
    
    </main>

    <script>
        
        const username = localStorage.getItem('username');
        if (username) {
            
            document.getElementById('alertMessage').textContent = Welcome, ${username}! You have successfully logged in to the Bank Analyst Portal.;
        }

        function closeAlert() {
            document.getElementById('welcomeAlert').style.display = 'none';
        }
        
   
    </script>
</body>
</html>