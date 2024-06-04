<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ajouter</title>
    <link rel="stylesheet" type="text/css" href="style/add.css">
</head>
<body>
<%
String username = (String)session.getAttribute("username"); 
if(username != null){

%>
<nav class="navbar">
        <div class="logo-container">
            <span class="logo-text">Ajouter un nouveau hotel ou chambre</span>
        </div>
        
    </nav>
<a href="index.jsp"><button>Retour</button></a>
	<div class="container">
		<div>
			<h2>Un hotel</h2>
			<form action="add-hotel.jsp" method="post">
				<label for="nom">Nom d'hotel</label>
				<input type="text" id="nom" name="nom" required placeholder="Nom d'hotel" />
				<label for="adresse">Adresse d'hotel</label>
				<input type="text" id="adresse" name="adresse" placeholder="Adresse d'hotel" required />
				<label for="ville">Ville d'hotel</label>
				<input type="text" id="ville" name="ville" placeholder="Ville d'hotel" required />
				<label for="description">Description d'hotel</label>
				<input type="text" id="description" name="description" placeholder="Description d'hotel" required />
				<label for="evaluation">Evaluation d'hotel</label>
				<input type="number" id="evaluation" name="evaluation" placeholder="Evaluation d'hotel" required />
				<label for="img" >image</label>
				<input type="text" id="img" name="img" required placeholder="image"/>
				
				<button>Ajouter</button>	
			</form>
		</div>
		<div>
			<h2>Une chambre</h2>
			<form action="add-chamber.jsp" method="post">
				<label for="hotel">Hotel</label>
				<select id="hotel" name="hotel_id" required>
					<option value=""></option>
					<%
				try{
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
					PreparedStatement ps = conn.prepareStatement("SELECT * FROM hotel");
					
					ResultSet rs = ps.executeQuery();
				     
					while (rs.next()) {
				        out.println("<option value='" + rs.getInt("id") +"'>" + rs.getString("nom") + "</option>");
				    }
				
				    // Close the resources
				    rs.close();
				    ps.close();
				    conn.close();
					
				}catch(Exception e){
					out.print(e);
				}
				%>
				</select>
				<label for="type">type</label>
				<select id="type" name="type" required>
					<option>Chambre</option>
					<option>Suite</option>
					<option>Suite VIP</option>
				</select>
				<label for="prix_nuit">Prix par nuit</label>
				<input type="number" id="prix_nuit" name="prix_nuit" placeholder="Prix par nuit" required />
				<button>Ajouter</button>
			</form>
		</div>
	</div>
	
	<%}else{
		out.print("<h1>Utilisateur non connecter</h1>");
		response.sendRedirect("index.jsp");
	} %>
	
</body>
</html>