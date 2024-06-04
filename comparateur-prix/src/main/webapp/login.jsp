<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Connecter</title>
<link rel="stylesheet" type="text/css" href="style/login.css">
</head>
<body>
<%
Boolean post = ("POST".equalsIgnoreCase(request.getMethod()));
if((String)session.getAttribute("username") == null && post){
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	
	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
		PreparedStatement ps;
		
		ps = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?");
		ps.setString(1, username);
		ps.setString(2, password);
		
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			session.setAttribute("username", username);
			session.setAttribute("role", rs.getString("role"));
			session.setAttribute("id", rs.getInt("id"));
			response.sendRedirect("index.jsp");
		}else{
			out.print("<h3>Utilisateur non trouver</h3>");
		}
	}catch(Exception e){
		out.print(e);
	}
}

else if((String)session.getAttribute("username") != null){
	response.sendRedirect("index.jsp");
}
	
    %>
    <div class="login-container">
    <h2>Connexion</h2>
    <form method="post" action="">
        <input type="text" placeholder="Nom d'utilisateur" name="username" required/>
        <input type="password" placeholder="Mot de passe" name="password" required/>
        <button><i class="fas fa-sign-in-alt"></i>Connexion</button>
    </form>
</div>
</body>
</html>