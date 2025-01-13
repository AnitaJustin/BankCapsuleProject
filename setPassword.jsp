<%@ page import="java.io.*, java.util.*, java.sql.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bank Analyst</title>
<link rel="stylesheet" href="styling.css">
</head>
<body>

	<div class="container">
		<div class="header">
			<h1>Bank Analyst</h1>
			<img src="Bank.png" alt="Bank Logo">
		</div>
		<div class="form-container">
			<h2>Change Password</h2>
			<form id="changepassword" method="POST">
				<div class="form-box">

					<label for="systempassword">System Generated Password </label> 
                    <input type="password" id="spassword" name="spassword" placeholder="Enter system generated password" required> 

					<label for="newpassword">New Password</label> 
                    <input type="password" id="npassword" name="npassword" placeholder="Enter new password" required>

					<label for="confirmpassword">Confirm Password</label> 
                    <input type="password" id="cpassword" name="cpassword" placeholder="Confirm password" required>

				</div>
				<button type="submit">Submit</button>
			</form>

		</div>
	</div>

<%
    String result = ""; // Declare result to hold messages
    String recoveryToken = request.getParameter("token");
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    ResultSet rs2 = null;

    try {
        if (recoveryToken != null && !recoveryToken.isEmpty()) {
            // Database connection setup
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BankAnalyst", "root", "Anita123@");

            // Step 1: Check if recovery token exists
            String query1 = "SELECT UserID FROM PasswordRecovery WHERE RecoveryToken = ?";
            pst = conn.prepareStatement(query1);
            pst.setString(1, recoveryToken);
            rs = pst.executeQuery();

            if (rs.next()) {
                String userID = rs.getString("UserID");

                // Step 2: Fetch system-generated password (or the current password)
                String query2 = "SELECT Password FROM Users WHERE UserID = ?";
                pst = conn.prepareStatement(query2);
                pst.setString(1, userID);
                rs2 = pst.executeQuery();

                if (rs2.next()) {
                    String systemGeneratedPassword = rs2.getString("Password");

                    // Step 3: Handle form submission (POST method)
                    if (request.getMethod().equals("POST")) {
                        String enteredSystemPassword = request.getParameter("spassword");
                        String newPassword = request.getParameter("npassword");
                        String confirmPassword = request.getParameter("cpassword");

                        // Check system-generated password
                        if (!enteredSystemPassword.equals(systemGeneratedPassword)) {
                            result = "The system-generated password does not match. Please check your email.";
                        } 
                        // Ensure new password length is adequate
                        else if (newPassword.length() < 8) {
                            result = "Password must be at least 8 characters long.";
                        } 
                        // Check if passwords match
                        else if (newPassword.equals(confirmPassword)) {
                            // Update the password in the database
                            String updateQuery = "UPDATE Users SET Password = ? WHERE UserID = ?";
                            pst = conn.prepareStatement(updateQuery);
                            pst.setString(1, newPassword);
                            pst.setString(2, userID);
                            pst.executeUpdate();

                            result = "Password changed successfully!";
                            response.sendRedirect("login.jsp");
                        } else {
                            result = "Passwords do not match. Please try again.";
                        }
                    }
                } else {
                    result = "User not found.";
                }
            } else {
                result = "Invalid or expired recovery token.";
            }
        } else {
            result = "Recovery token is missing.";
        }
    } catch (Exception e) {
        e.printStackTrace();
        result = "Error processing your request.";
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (rs2 != null) rs2.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pst != null) pst.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        
    }
    if (!result.isEmpty()) {
      
        out.println("<script>alert('" + result + "');</script>");
    }
%>


</body>
</html>
