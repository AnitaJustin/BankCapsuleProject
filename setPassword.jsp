<%@ page import="java.io.*, java.util.*, java.sql.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bank Analyst</title>
<link rel="stylesheet" href="stylings.css">
</head>
<body>

	<div class="container">
		<div class="header">
			<h1>Bank Analyst</h1>
			<img src="Bank.png" alt="Bank Logo">
		</div>
		<div class="form-container">
			<h2>Change Password</h2>
			<form id="changepassword" onsubmit="handleFormSubmit(event)">
				<div class="form-box">

					<label for="systempassword">System Generated Password </label> <input
						type="password" id="spassword"
						placeholder="Enter system generated password" required> <label
						for="newpassword">New Password</label> <input type="password"
						id="npassword" placeholder="Enter new password" required>

					<label for="confirmpassword">Confirm Password</label> <input
						type="password" id="cpassword" placeholder="Confirm password"
						required>

				</div>
				<button type="submit">Submit</button>
			</form>

		</div>
	</div>
</body>
</html>
<%
String recoveryToken = request.getParameter("token");
               Connection conn = null;
               PreparedStatement pst = null;
               ResultSet rs = null;
               String result;
               try {
            	     
                   Class.forName("com.mysql.cj.jdbc.Driver");
                   conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BankAnalyst", "root", "Anita123@");
					String query1="select UserID from PasswordRecovery where RecoveryToken=?";
					pst = conn.prepareStatement(query1);
			        pst.setString(1, recoveryToken);
			        rs = pst.executeQuery();
			        if(rs.next()){
			        	String userID=rs.getString("UserID");
			        	String query2="Select Password from Users where UserID=?";
			        	PreparedStatement pst2= conn.prepareStatement(query2);
			        	pst2.setString(1,userID);
			        	ResultSet rs2=pst2.executeQuery();
			        	String systemGeneratedPassword = rs2.getString("Password");
			        	
			        	if (request.getMethod().equals("POST")) {
			                String enteredSystemPassword = request.getParameter("spassword");
			                String newPassword = request.getParameter("npassword");
			                String confirmPassword = request.getParameter("cpassword");

			                if (!enteredSystemPassword.equals(systemGeneratedPassword)) {
			                    result = "The system-generated password does not match. Please check your email.";
			                } else if (newPassword.length() < 8) {
			                    result = "Password must be at least 8 characters long.";
			                } else if (newPassword.equals(confirmPassword)) {
			   
			                    String updateQuery = "UPDATE Users SET Password = ? WHERE UserID = ?";
			                    pst = conn.prepareStatement(updateQuery);
			                    pst.setString(1, newPassword);
			                    pst.setString(2, userID);
			                    pst.executeUpdate();

			                    result = "Password changed successfully!";

			                } else {
			                    result = "Passwords do not match. Please try again.";
			                }
			            }
			        }
               }
			        catch (Exception e) {
			            e.printStackTrace();
			            result = "Error processing your request.";
			        } finally {
			            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
			            try { if (pst != null) pst.close(); } catch (SQLException e) { e.printStackTrace(); }
			            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
			        }
		%>	    
