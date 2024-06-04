<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="index.css">
</head>
<body>
<header>
    <nav class="navbar">
        <div class="logo-container">
            <span class="logo-text">HOTELS</span>
        </div>
        
    </nav>
</header>

<main>
    <%
    

    
    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
        PreparedStatement ps;
        
            ps = conn.prepareStatement("SELECT * FROM hotel");
        
        ResultSet rs = ps.executeQuery();
    %>
    <h2>Liste des hotels</h2>
    <a href="index.jsp"><button>Retour</button></a>
    
    <div class="card-container">
   
    <%
    while (rs.next()) {
    	%>
        <div class="img-container">
	        <div>
	        	<img src=<%= "img/" + rs.getString("img") %> />
	        </div>
	        <div>
	        	<h2><%= rs.getString("nom") %></h2>
	        
	        	<%-- <span>Type: <%= rs.getInt("id") %></span> --%>
	        
	        	<span>Adresse: </span>
	        	<span><%= rs.getString("adresse") %></span>
	        	<span>ville: </span>
	        	<span><%= rs.getString("ville") %></span>
	       		<span>description: <%= rs.getString("description") %></span>
	        	<span>evaluation: <%= rs.getString("evaluation") %></span>
	        </div>
	         <div>
                    <a href="Modifier_hotel.jsp?id=<%= rs.getInt("id") %>"><button>Modifier</button></a>
                    <a href="supprimer_hotel.jsp?id=<%= rs.getInt("id") %>"><button>Supprimer</button></a>
                    </div>
        </div>
    <% } %>
    </div>
    <%
    rs.close();
    ps.close();
    conn.close();
    
    }catch(Exception e){
    out.print(e);
    }
    %>
</main>
<footer>
    
</footer>

</body>
</html>