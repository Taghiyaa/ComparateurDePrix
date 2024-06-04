<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<%@ page import="java.time.Period" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="style/modifier.css">
<script src="javascript/accordion.js"></script>
</head>
<body>
<h1>Reserve Maintenant !</h1>
<%

	
    // Récupérer l'identifiant de la chambre à modifier à partir de la requête HTTP
    int id = Integer.parseInt(request.getParameter("id")) ;

	
	if(("POST".equalsIgnoreCase(request.getMethod()))){
    	
		String nomClient = request.getParameter("nomClient");
		String numTel = request.getParameter("numTel");
		String numPassport = request.getParameter("numPassport");
		String periode1 = request.getParameter("periode1");
		String periode2 = request.getParameter("periode2");
		String prix = request.getParameter("montant");
		String periode = null;
		double montant=0;
		Boolean reserved=false;
		
		try{
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			
			LocalDate date1 = LocalDate.parse(periode1, formatter);
            LocalDate date2 = LocalDate.parse(periode2, formatter);
            
            Period period = Period.between(date1, date2);
            montant=period.getDays()*Integer.parseInt(prix);

            Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
            // Compare the dates
            if (date1.isBefore(date2)) {
            	periode=periode1+" - "+periode2;
            	PreparedStatement perio = conn.prepareStatement("SELECT * FROM `reservation` WHERE codeChambre="+id+" AND date_reservation BETWEEN '"+periode1+"' AND '"+periode2+"';");
            	ResultSet rs = perio.executeQuery();
            	 if (rs.next()) {
            		 reserved=true;
            		 %>
            		 <P>il y a une autre reservation dans ce date</P>
            		 <%
            	 }
            } else if (date1.isAfter(date2)) {
                periode=periode2+" - "+periode1;
            	PreparedStatement perio = conn.prepareStatement("SELECT * FROM `reservation` WHERE codeChambre="+id+" AND date_reservation BETWEEN '"+periode2+"' AND '"+periode1+"';");
            	ResultSet rs = perio.executeQuery();
           	 if (rs.next()) {
           		 reserved=true;
           		 %>
           		 <P>il y a une autre reservation dans ce date</P>
           		 <%
           	 }
            } else {
                periode=periode1;
            	PreparedStatement perio = conn.prepareStatement("SELECT * FROM `reservation` WHERE codeChambre="+id+" AND date_reservation ='"+periode1+"';");
            	ResultSet rs = perio.executeQuery();
           	 if (rs.next()) {
           		 reserved=true;
           		 %>
           		 <P>il y a une autre reservation dans ce date</P>
           		 <%
           	 }
            }
			
			
			if (reserved==false){PreparedStatement ps = conn.prepareStatement("INSERT INTO reservation(nomClient, numTel, numPassport, periode, montant, codeChambre) VALUES(?,?,?,?,?,?)");
			ps.setString(1, nomClient);
			ps.setInt(2, Integer.parseInt(numTel));
			ps.setString(3, numPassport);
			ps.setString(4, periode);
			ps.setDouble(5, montant);
			ps.setInt(6, id);
			
			
			int x = ps.executeUpdate();
			
			if(x > 0){
				response.sendRedirect("index.jsp");
			}
			}
		}catch(Exception e){
			out.print(e);
		}
    		
	}
    
    
    try {
        // Connexion à la base de données
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel", "root", "");
        
        // Récupérer les informations de la chambre depuis la base de données
        PreparedStatement ps = conn.prepareStatement("SELECT prix_nuit,code FROM `chambre` WHERE chambre.id=?");
        PreparedStatement reservation = conn.prepareStatement("SELECT * FROM `reservation` WHERE codeChambre=? AND statut=?");
        ps.setInt(1, id);
        reservation.setInt(1, id);
        reservation.setBoolean(2, true);
        ResultSet rs = ps.executeQuery();
        ResultSet res = reservation.executeQuery();
        
        // Afficher le formulaire de modification avec les données pré-remplies
        if (rs.next()) {
    %>
	<form method="post" action="">
				<label for="nomClient"> Nom complet:</label>
                <input type="text" id="nomClient" name="nomClient" value="" required />
                
                <label for="numTel"> Numero de telephone:</label>
                <input type="text" id="numTel" name="numTel" value="" required />
                
                <label for="numPassrort"> NNI ou Numero de passport:</label>
                <input type="text" id="nomClient" name="numPassport" value="" required />
                
                <label for="periode1"> commance a partir de :</label>
                <input type="date" id="periode1" name="periode1" value="" required />
                
                <label for="periode2"> Termine le:</label>
                <input type="date" id="periode2" name="periode2" value="" required />
                
                <label for="prix_nuit">Prix par nuit :</label>
                <input type="number" id="prix_nuit" name="prix_nuit" value="<%= rs.getInt("prix_nuit") %>" readonly />
                
                <label for="code">chambre numero:</label>
                <input type="text" id="code" name="code" value="<%= rs.getString("code") %>" readonly />
                
                <input type="hidden" id="montant" name="montant" value="<%= rs.getInt("prix_nuit") %>" readonly />
                
                
				<div class="panel">
  				<%
  				if (res.next()) {
  					%>
  					<span style="color:red; font-size:14px; margin:5px;">cette chambre n est pas disponible pendant ce periode :</span>
  					<% 
  				    while (res.next()) {
  				    	%>
  				    	<p> <%= res.getString("periode") %> </p>
  				    	
  				    	<%
  				    	
  				    	}
  				    }
  				res.close();
  				reservation.close();
  				    	%>
  				
				</div>
                
                <input type="submit" value="Reserver">
                <a href="index.jsp"><button type="button">Retour</button></a>
	</form>
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