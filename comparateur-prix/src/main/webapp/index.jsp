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
        <div class="navbar-links" style="display: flex; gap: 2px;">
            <%
            if((String)session.getAttribute("username") == null){
            %>
            <a href="login.jsp">
                <button>Connecter</button>
            </a>
            <%
            }else{ %>
            	<a href="list-hotels.jsp"><button class=B>liste hotels</button></a>
            <%
            	if ("admin_hotel".equals((String)session.getAttribute("role"))) {
            		%><a href="list-reservations.jsp">
                <button>Reservation</button>
            </a>
            		<%
            		
                
            }
            %>
            <form method="post" action="" >
                <input type="hidden" name="deconnecter" value="deconnecter" />
                <button>Deconnecter</button>
            </form>
            <%
            }
            %>
        </div>
    </nav>
</header>

<main>
    <%
    String value1 = request.getParameter("value1");
    String value2 = request.getParameter("value2");
    String ville = request.getParameter("ville");
    

    if(("POST".equalsIgnoreCase(request.getMethod()))){
        session.removeAttribute("username");
        response.sendRedirect("index.jsp");
    }

    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hotel","root","");
        PreparedStatement ps;
        PreparedStatement chercheVille;

        chercheVille = conn.prepareStatement("SELECT DISTINCT h.ville FROM hotel h INNER JOIN chambre ch ON h.id = ch.hotel_id");
        // all values null
        if((value1 == null && value2 == null && ville == null) || (value1 == "" && value2 == "" && ville == "")){
            ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id ORDER BY ch.prix_nuit ASC");
        }
        // no value null
        else if (value1 != null && value2 != null && ville != null && value1 != "" && value2 != "" && ville != "") {
            String first = Integer.parseInt(value1) > Integer.parseInt(value2) ? value2 : value1;
            String last = Integer.parseInt(value1) > Integer.parseInt(value2) ? value1 : value2;
            ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id WHERE ville = '" + ville + "' AND ch.prix_nuit BETWEEN " + first +" AND " + last +" ORDER BY ch.prix_nuit ASC");
            //ps.setInt(1, first);
            //ps.setInt(2, last);
        } 
        // only ville not null
        else if ((value1 == null && value2 == null && ville != null) || (value1 == "" && value2 == "" && ville != "")){
        	ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id WHERE ville = ? ORDER BY ch.prix_nuit ASC");
        	ps.setString(1, ville);
        }
        // only value2 not null
        else if ((value1 == null || value1 == "") && Integer.parseInt(value2) >= 0 && (ville == null || ville == "")) {
        	ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id WHERE ch.prix_nuit = "+ value2);
            
        }
        //value2 and ville not null
        else if ((value1 == null || value1 == "") && Integer.parseInt(value2) >= 0 && ville != null && ville != "") {
        	ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id WHERE ch.prix_nuit = ? AND ho.ville = ?");
        	ps.setString(1, value2);
        	ps.setString(2, ville);
        }
        // only value1 not null
        else if ((value2 == null || value2 == "") && Integer.parseInt(value1) >= 0 && (ville == null || ville == "")) {
        	ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id WHERE ch.prix_nuit = "+ value1);
            
        }
        //value1 and ville not null
        else if ((value2 == null || value2 == "") && Integer.parseInt(value1) >= 0 && ville != null && ville != "") {
        	ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id WHERE ch.prix_nuit = ? AND ho.ville = ?");
        	ps.setString(1, value1);
        	ps.setString(2, ville);
        }
        // only ville null
        else if ((ville == null || ville == "") && Integer.parseInt(value2) >= 0 && Integer.parseInt(value1) >= 0) {
            String first = Integer.parseInt(value1) > Integer.parseInt(value2) ? value2 : value1;
            String last = Integer.parseInt(value1) > Integer.parseInt(value2) ? value1 : value2;
            ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id WHERE ch.prix_nuit BETWEEN " + first +" AND " + last +" ORDER BY ch.prix_nuit ASC");
            //ps.setInt(1, Integer.parseInt(value2));
        } else {
            ps = conn.prepareStatement("SELECT * FROM chambre ch INNER JOIN hotel ho ON ch.hotel_id = ho.id");
        }
        if (value1 != null || value2 != null || ville != null) {
            %>
            <div class="button-container">
            <a href="./index.jsp"><button>Annuler</button></a>
            </div>
            <%
        }
    	ResultSet resultat = chercheVille.executeQuery();

        ResultSet rs = ps.executeQuery();
    %>
    <h2>Comparer</h2>
    <div class="button-container">
    
    <form method="get" action="" >
        <input type="text" name="value1" value="<%= value1 != null ? value1 : "" %>" placeholder="Prix minimum" />
        <input type="text" name="value2" value="<%= value2 != null ? value2 : "" %>" placeholder="Prix maximum" />
        <input type="text" id="cherche" placeholder="Chercher par ville"  style="display: none" />
        <div id="filtred" style="display: none"></div>
        <select id="ville" name="ville" value="<%= ville %>">
        	<option value=""> Ville</option>
        	<%
        	while (resultat.next()) {
            	%>
        	        <option <%= (resultat.getString("ville").equals(ville)) ? "selected" : "" %> value="<%= resultat.getString("ville") %>">
            <%= resultat.getString("ville") %>
        </option><% } %>
        </select>
        <button>Chercher</button>
        
        <!-- <select name="sort">
        	<option value="asc">Croissant</option>
        	<option value="desc">Décroissant</option>
   		</select>
    	<button type="submit">Filtrer</button>
    	 -->
    </form>
    
   
    </div>
    <%
    String username = (String)session.getAttribute("username");
    if(username != null) {
    %>
    <div class=C>
    <a href="add.jsp"><button class=A>Ajouter</button></a>
    
    </div>
    
    <% } %>
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
	        
	        	<span>Type: <%= rs.getString("type") %></span>
	        
	        	<span>Location:</span>
	        	<span><%= rs.getString("adresse") %></span>
	        	<span><%= rs.getString("ville") %></span>
	        
	        	<span>Prix par nuit: <%= rs.getString("prix_nuit") %>MRU</span>
	        </div>
	        <% if(username != null) { %>
                   <div>
                    <a href="Modifier.jsp?id=<%= rs.getInt("id") %>"><button>Modifier</button></a>
                    <a href="supprimer.jsp?id=<%= rs.getInt("id") %>"><button>Supprimer</button></a>
                    </div>
              <% } %>
              <% if(username == null) { %>
                   <div>
                    <a href="ajout-reservation.jsp?id=<%= rs.getInt("id") %>"><button>Reserver</button></a>
                    
                    </div>
              <% } %>
        </div>
    <% } %>
    </div>
    <%
    //chercheVille.close(); // Close here after using resultat
    //resultat.close(); 
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