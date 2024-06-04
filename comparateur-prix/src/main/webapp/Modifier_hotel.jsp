<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier l'élément</title>
    <link rel="stylesheet" type="text/css" href="style/modifier.css">
</head>
<body>
    <h1>Modifier l'élément</h1>
    <%
    // Récupérer l'identifiant de la chambre à modifier à partir de la requête HTTP
    int id = Integer.parseInt(request.getParameter("id")) ;
    
    
    try {
        // Connexion à la base de données
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel", "root", "");
        
        // Récupérer les informations de la chambre depuis la base de données
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM hotel WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        
        // Afficher le formulaire de modification avec les données pré-remplies
        if (rs.next()) {
    %>
  	  
            <form method="post" action="Enregistrer_modification_H.jsp">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <label for="nom">hotel :</label>
                <input type="text" id="nom" name="nom" value="<%= rs.getString("nom") %>" required />
                <label for="adresse">adresse :</label>
                <input type="text" id="adresse" name="adresse" value="<%= rs.getString("adresse") %>" required />
                <label for="ville">ville :</label>
                <input type="text" id="ville" name="ville" value="<%= rs.getString("ville") %>" required />
                <label for="description">description :</label>
                <input type="text" id="description" name="description" value="<%= rs.getString("description") %>" required />
                <label for="evaluation">evaluation :</label>
                <input type="number" id="evaluation" name="evaluation" value="<%= rs.getInt("evaluation") %>" required />
                <label for="img">img :</label>
                <input type="text" id="img" name="img" value="<%= rs.getString("img") %>" required />
                
                <input type="submit" value="Modifier">
                <a href="list-hotels.jsp"><button>Retour</button></a>
                
            </form>
           
           <!--  <a href="index.jsp"><button>Retour</button></a> -->
    <%
        }
        
        // Fermer les ressources
        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    %>
</body>
</html>
