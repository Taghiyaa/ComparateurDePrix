<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ajoter chamber</title>
</head>
<body>
<%
String username = (String)session.getAttribute("username"); 
if(username != null){

	String hotelId = request.getParameter("hotel_id");
	String type = request.getParameter("type");
	String prix_nuit = request.getParameter("prix_nuit");
	
	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
		PreparedStatement ps = conn.prepareStatement("INSERT INTO chambre(hotel_id, type, prix_nuit) VALUES(?,?,?)");
		ps.setInt(1, Integer.parseInt(hotelId));
		ps.setString(2, type);
		ps.setInt(3, Integer.parseInt(prix_nuit));
		
		
		int x = ps.executeUpdate();
		
		if(x > 0){
			response.sendRedirect("index.jsp");
		}
		
	}catch(Exception e){
		out.print(e);
	}
}else{
	out.print("<h1>Utilisateur non connecter</h1>");
	response.sendRedirect("index.jsp");
}
%>
<a href="add.jsp">Annuler au accueil</a>
</body>
</html>