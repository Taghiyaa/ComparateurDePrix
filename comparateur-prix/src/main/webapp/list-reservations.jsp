<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
table {
  border-collapse: collapse;
  border-spacing: 0;
  width: 100%;
  border: 1px solid #ddd;
}

th, td {
  text-align: left;
  padding: 16px;
  font-size: 12px;
}

tr:nth-child(even) {
  background-color: #f2f2f2;
}
</style>
</head>
<body>
	<h1>Liste des reservations</h1>
	
	<%
    
	if(("POST".equalsIgnoreCase(request.getMethod()))){
		Boolean statut = "true".equalsIgnoreCase(request.getParameter("statut")) ? true : false;
		int id =Integer.parseInt(request.getParameter("id"));
		
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
			PreparedStatement ps = conn.prepareStatement("UPDATE reservation SET statut=?  WHERE id=?");
			ps.setBoolean(1, statut);
			ps.setInt(2, id);
			
			
			
			int x = ps.executeUpdate();
			
			 if(x > 0){
				response.sendRedirect("list-reservations.jsp");
			} 
			
		}catch(Exception e){
			out.print(e);
		}
	}
    
    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
        PreparedStatement ps;
        
            ps = conn.prepareStatement("SELECT reservation.id,nomClient,numTel,numPassport, date_reservation, periode, code,prix_nuit,montant,statut FROM `reservation` INNER JOIN chambre ON reservation.codeChambre=chambre.id INNER JOIN hotel ON chambre.hotel_id=hotel.id ;");
        
        ResultSet rs = ps.executeQuery();
    %> 
    
    
	<table>
  <tr>
    <th>NomClient</th>
    <th>NumTel</th>
    <th>NumPasseport</th>
    <th>Date de réservation</th>
    <th>Période</th>
    <th>CodeChambre</th>
    <th>Prix par nuit</th>
    <th>Montant</th>
    <th>Action</th>
  </tr>
  
  <%
    while (rs.next()) {
    	%>
  <tr>
    <td><%= rs.getString("nomClient") %></td>
    <td><%= rs.getString("numTel") %></td>
    <td><%= rs.getString("numPassport") %></td>
    <td><%= rs.getString("date_reservation") %></td>
    <td><%= rs.getString("periode") %></td>
    <td><%= rs.getString("code") %></td>
    <td><%= rs.getInt("prix_nuit") %></td>
    <td><%= rs.getDouble("montant") %></td>
    <td><%= rs.getBoolean("statut")==true ?  "<span>confirmé</span>" : "<form method='post' action=''> <input type='hidden'  name='statut' value='true' /> <input type='hidden'  name='id' value='"+rs.getInt("id")+"' /> <button>confirmer</button></form>" %></td>
  </tr>
  <% } %>
</table>
 <%
    rs.close();
    ps.close();
    conn.close();
    
    }catch(Exception e){
    out.print(e);
    }
    %>
	
</body>
</html>