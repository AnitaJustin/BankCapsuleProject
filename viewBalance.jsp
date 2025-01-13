<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Balance</title>
    <link rel="stylesheet" href="balance.css">
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
            <a href="viewBalance.jsp" class="active">View Balance</a>
            <a href="aboutus.html">About Us</a>
        </nav>
    </header>
    <main>
        <div class="balance-section">
            <div class="balance-info">
                <h2>Account Balance</h2>
                <%
                    String userid = (String) session.getAttribute("userid");
                    Connection conn = null;
                    CallableStatement stmt = null;
                    ResultSet rsBalance = null;
                    ResultSet rsTransactions = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BankAnalyst", "root", "Anita123@");

                        PreparedStatement pst = conn.prepareStatement("SELECT AccountNumber FROM Users WHERE UserID = ?");
                        pst.setString(1, userid);
                        rs = pst.executeQuery();
                        String accountNumber = null;

                        if (rs.next()) {
                            accountNumber = rs.getString("AccountNumber");
                        } else {
                            out.println("<p>No account found for the given user ID.</p>");
                        }

                        stmt = conn.prepareCall("{CALL GetAccountDetails(?)}");
                        stmt.setString(1, accountNumber);

                        boolean hasResults = stmt.execute();

                        if (hasResults) {
                            rsBalance = stmt.getResultSet();
                            if (rsBalance.next()) {
                                out.println("<p class='amount'>₹" + rsBalance.getBigDecimal("BalanceAmount") + "</p>");
                            }
                            rsBalance.close();
                        }

                        if (stmt.getMoreResults()) {
                            rsTransactions = stmt.getResultSet();
                %>
                <section class="transactions">
                    <h2>Transaction History</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Debit (₹)</th>
                                <th>Credit (₹)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (rsTransactions.next()) {
                                    out.println("<tr>");
                                    out.println("<td>" + rsTransactions.getBigDecimal("Debit") + "</td>");
                                    out.println("<td>" + rsTransactions.getBigDecimal("Credit") + "</td>");
                                    out.println("</tr>");
                                }
                                rsTransactions.close();
                         
                                    }
                    
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }   %>
                        </tbody>
                    </table>
                </section>

                

            </div>
        </div>
    </main>
    <footer>
        <p>&copy; 2025 Bank Analyst. All rights reserved.</p>
    </footer>
</body>
</html>
