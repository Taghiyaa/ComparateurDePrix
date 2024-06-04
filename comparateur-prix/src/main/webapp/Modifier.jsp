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
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM chambre WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        
        // Afficher le formulaire de modification avec les données pré-remplies
        if (rs.next()) {
    %>
  	  
            <form method="post" action="Enregistrer_modification.jsp">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <label for="hotel">Hotel :</label>
                <select id="hotel" name="hotel_id" required>
                    <option value=""></option>
                    <%
                        // Code pour récupérer la liste des hôtels depuis la base de données
                        try {
                            PreparedStatement psHotel = conn.prepareStatement("SELECT * FROM hotel");
                            ResultSet rsHotel = psHotel.executeQuery();
                            while (rsHotel.next()) {
                                if (rs.getInt("hotel_id") == rsHotel.getInt("id")) {
                    %>
                                    <option value="<%= rsHotel.getInt("id") %>" selected><%= rsHotel.getString("nom") %></option>
                    <%
                                } else {
                    %>
                                    <option value="<%= rsHotel.getInt("id") %>"><%= rsHotel.getString("nom") %></option>
                    <%
                                }
                            }
                            rsHotel.close();
                            psHotel.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
                <label for="type">Type :</label>
                <input type="text" id="type" name="type" value="<%= rs.getString("type") %>" required />
                <label for="prix_nuit">Prix par nuit :</label>
                <input type="number" id="prix_nuit" name="prix_nuit" value="<%= rs.getInt("prix_nuit") %>" required />
                <input type="submit" value="Modifier">
                <a href="index.jsp"><button>Retour</button></a>
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
