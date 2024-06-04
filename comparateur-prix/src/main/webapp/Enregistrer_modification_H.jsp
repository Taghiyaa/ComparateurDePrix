<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>update_hotel</title>
</head>
<body>
<%
String username = (String)session.getAttribute("username"); 
if(username != null){

	String id = request.getParameter("id");
	String nom = request.getParameter("nom");
	String adresse = request.getParameter("adresse");
	String ville = request.getParameter("ville");
	String description = request.getParameter("description");
	String evaluation = request.getParameter("evaluation");
	String img = request.getParameter("img");


	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
		PreparedStatement ps = conn.prepareStatement("UPDATE hotel SET nom=?, adresse=?, ville=?, description=?, evaluation=?, img=? WHERE id=?");
		ps.setString(1, nom);
		ps.setString(2, adresse);
		ps.setString(3, ville);
		ps.setString(4, description);
		ps.setInt(5, Integer.parseInt(evaluation));
		ps.setString(6, img);
		ps.setInt(7, Integer.parseInt(id));
		
		
		
		int x = ps.executeUpdate();
		
		if(x > 0){
			response.sendRedirect("list-hotels.jsp");
		}
		
	}catch(Exception e){
		out.print(e);
	}
}else{
	out.print("<h1>Utilisateur non connecter</h1>");
	response.sendRedirect("list-hotels.jsp");
}
%>

</body>
</html>