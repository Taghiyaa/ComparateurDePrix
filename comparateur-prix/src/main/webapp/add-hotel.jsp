<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ajouter hotel</title>
</head>
<body>
<%
String username = (String)session.getAttribute("username"); 
if(username != null && ("POST".equalsIgnoreCase(request.getMethod()))){
	
	String nom = request.getParameter("nom");
	String adresse = request.getParameter("adresse");
	String ville = request.getParameter("ville");
	String description = request.getParameter("description");
	String evaluation = request.getParameter("evaluation");
	String img = request.getParameter("img");
	
	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
		PreparedStatement ps = conn.prepareStatement("INSERT INTO hotel(nom, adresse, ville, description, evaluation,img) VALUES(?,?,?,?,?,?)");
		ps.setString(1, nom);
		ps.setString(2, adresse);
		ps.setString(3, ville);
		ps.setString(4, description);
		ps.setInt(5, Integer.parseInt(evaluation));
		ps.setString(6, img);
		
		int x = ps.executeUpdate();
		
		if(x > 0){
			response.sendRedirect("index.jsp");
		}
		
	}catch(Exception e){
		out.print(e);
	}
}else if(username== null){
	out.print("<h1>Utilisateur non connecter</h1>");
	response.sendRedirect("index.jsp");
}else{
	out.print("<h1>M�thod est invalid</h1>");
}
%>
<a href="add.jsp">retourner</a>
</body>
</html>