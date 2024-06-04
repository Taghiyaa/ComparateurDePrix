<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Supprimer Chambre ou Hotel</title>
</head>
<body>

<%
// Récupérer l'identifiant à partir des paramètres de la requête
int id = Integer.parseInt(request.getParameter("id"));
String type = request.getParameter("type"); // "chambre" ou "hotel"

try {
    // Établir la connexion à la base de données
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel", "root", "");

    // Préparer et exécuter la requête de suppression en fonction du type (chambre ou hotel)
    PreparedStatement ps = conn.prepareStatement("DELETE FROM chambre WHERE id = ?");
    ps.setInt(1, id);
    int rowsAffected = ps.executeUpdate();

    // Rediriger l'utilisateur vers la page index.jsp après la suppression
    response.sendRedirect("index.jsp");

    // Fermer les ressources
    ps.close();
    conn.close();
} catch (Exception e) {
    // Gérer les exceptions
    out.println("Erreur : " + e.getMessage());
}
%>

</body>
</html>