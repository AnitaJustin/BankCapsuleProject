<%@ page import="java.io.*, java.util.*, javax.mail.*, javax.mail.internet.*, javax.activation.*, java.sql.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>

<%
String result = "";

if (request.getMethod().equals("POST")) {

    String username = request.getParameter("username");
    String email = request.getParameter("email");
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
     
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BankAnalyst", "root", "Anita123@");

        String query = "SELECT UserID, Name, MobileNo, IDNo, DOB FROM Users WHERE Email = ?";
        pst = conn.prepareStatement(query);
        pst.setString(1, email);
        rs = pst.executeQuery();
        

        if (rs.next()) {
            String userId = rs.getString("UserID");
            String userName = rs.getString("Name");
            String mobile = rs.getString("MobileNo");
            String idNo = rs.getString("IDNo");
            String dob = rs.getString("DOB");
			out.println(userId);
            String recoveryToken = UUID.randomUUID().toString();

            String insertQuery = "INSERT INTO PasswordRecovery (UserID, RecoveryToken) VALUES (?, ?)";
            pst = conn.prepareStatement(insertQuery);
            pst.setString(1, userId);
            pst.setString(2, recoveryToken);
            pst.executeUpdate();

            String defaultPassword = generateDefaultPassword(userName, mobile, idNo, dob);

            String to = email;
            String from = "mediconnect007@gmail.com";
            String host = "smtp.gmail.com";

            String senderMail = "mediconnect007@gmail.com";
            String password = "blum uhpj nbqk ksha";

            Properties properties = System.getProperties();
            properties.put("mail.smtp.host", host);
            properties.put("mail.smtp.port", "587");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");

            Session session1 = Session.getInstance(properties, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderMail, password);
                }
            });

            try {
                MimeMessage message = new MimeMessage(session1);
                message.setFrom(new InternetAddress(from));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

                message.setSubject("Password Recovery");

                String recoveryLink = "http://localhost:8899/DB/setPassword.jsp?token=" + recoveryToken;

                String mssg = "Hello " + userName + ",<br><br>"
                        + "Click the link below to reset your password:<br>"
                        + "<a href='" + recoveryLink + "'>Reset Password</a><br><br>"
                        + "Your default password is: <b>" + defaultPassword ;
                message.setContent(mssg, "text/html");

                Transport.send(message);
                result = "Password recovery email sent successfully. Please check your email.";
				String updatePass="update Users set Password=? where UserID=?";
				PreparedStatement pst2 = conn.prepareStatement(updatePass);
				pst2.setString(1,defaultPassword);
				pst2.setString(2,userId);
				pst2.executeUpdate();
                response.sendRedirect("login.jsp");

            } catch (MessagingException mex) {
                mex.printStackTrace();
                result = "Error: unable to send message....";
            }

        } else {
            result = "Email not found in the system.";
        }

    } catch (Exception e) {
        e.printStackTrace();
        result = "Error processing your request.";
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pst != null) pst.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        
    }
    if (!result.isEmpty()) {
        
        out.println("<script>alert('" + result + "');</script>");
    }
}
%>

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
        <img src="banklogo.png" alt="Bank Logo">
    </div>
    <div class="form-container">
        <h2>Password Recovery</h2>
        <form id="forgetpassword" method="POST">
            <div class="form-box">

                <label for="username">Username</label> <input type="text" id="username" name="username" placeholder="Enter your username" required>

                <label for="email">Email</label> <input type="email" id="email" name="email" placeholder="Enter your email address" required>

            </div>
            <button type="submit">Submit</button>
        </form>

       
    </div>
</div>

</body>
</html>

<%!

public String generateDefaultPassword(String userName, String mobile, String idNo, String dob) {
    StringBuilder p1 = new StringBuilder(userName.substring(userName.length() - 2)).reverse();
    StringBuilder p2 = new StringBuilder(userName.substring(0, 2)).reverse();
    String p3 = "" + mobile.charAt(1) + mobile.charAt(3) + mobile.charAt(4) + mobile.charAt(6) + mobile.charAt(8);
    String p4 = consonantEven(idNo);
    String p5 = sumDob(dob);

    return p1.toString() + p2.toString() + p3 + p4 + p5;
}

public String consonantEven(String s) {
    StringBuilder out = new StringBuilder();
    String vowels = "aeiou";
    for (char k : s.toCharArray()) {
        if (Character.isLetter(k) && !vowels.contains((String.valueOf(k)).toLowerCase())) {
            out.append(k);
        }
    }
    for (char k : s.toCharArray()) {
        if (Character.isDigit(k) && (k - '0') % 2 == 0) {
            out.append(k);
        }
    }
    return out.toString();
}

public String sumDob(String s) {
    String result = s;
    while (result.length() > 1) {
        int temp = 0;
        for (char k : result.toCharArray()) {
            temp = temp + (k - '0');
        }
        result = Integer.toString(temp);
    }
    return result;
}
%>
