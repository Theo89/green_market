<%-- 
    Document   : profilej
    Created on : Aug 22, 2015, 5:55:37 PM
    Author     : TEOM
--%>
<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="Projectva.ns" language="java" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<%@ page errorPage="error.jsp" %> 
<% Class.forName("sun.jdbc.odbc.JdbcOdbcDriver"); %>
<%
    int id=0;
   
    
    
   if(request.getParameter("client")==null){
     id=(Integer)request.getAttribute("message");
         System.out.println("pies ta :"+id);
         request.setAttribute("message", id);
     
          RequestDispatcher reqDispatcher = request.getRequestDispatcher("profilej.jsp");} 
    
    
    
 %>   



<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" type="text/css" href="style.css">
    </head>
    <body background="livadi2.jpg">
        <script language="JavaScript" type="text/javascript">
window.history.forward(1);
</script>
        
            <div id="header"><h1>WELLCOME</h1></div>
        
        
        
        
     <div id="page">   
         
       <div id="firstp">  
       <form action="profilej.jsp" method="POST">
               <div id="sr"> Search for products to buy: </div>  <input type="text" name="buy">
                <input type="submit" name="v1" value="SEARCH" /></br>
                <input type="hidden" id="thisField" name="client" value="<%= id %>" >

                <input type="submit" name="b1" value="SHOW MY OFFERS" />
        </form>
        </div>        








             <div id="secondp">
            <form action="profilej.jsp" method="POST" >
    
                <input type="hidden" id="thisField" name="client" value="<%= id %>" > 
                    <div id="no"> ENTER NEW OFFER</div></br>
                           <div id="no1">Enter product tha you would like to purchace :</div><input type="text" name="prname"  /> </br>
                             <div id="no2">Enter price you are willing to pay (euros per kilo) :</div><input type="text" name="price"  /></br>
                             <input type="submit" name="b3" value="PUBLISH" />
            </form>
            </div>
                    
                    <form action="logout" method="POST" >
                              <input type="hidden" id="thisField" name="client" value="<%= id %>" >
                           <input type="submit" name="logo" value="LOG OUT" id="sk"  /> 
                            </form>
</div>

<%-- Kwdikas gia logout --%>   
<%if(request.getParameter("logo")!=null){
    session.invalidate();

}
    %>
    
    
    
    
    
    
    
 <%-- Kwdikas upeuthinos gia anzitisi kai emfanisi --%>   
<% if(request.getParameter("v1")!=null && request.getParameter("buy")!="") { %>

<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://localhost:3306/reg"
     user="root"  password="%so11333"/>
  <sql:query dataSource="${snapshot}" var="result">
SELECT * from product WHERE name="<%= request.getParameter("buy") %>" ;
</sql:query>
<table  class="t1">
    <tr class="t2">
   <th>Name of product</th>
   <th>Location</th>
   <th>Price (euros per kilo)</th>
   <th>id</th>
   
</tr>
<c:forEach var="row" items="${result.rows}">
    <tr class="t3">
   <td><c:out value="${row.name}"/></td>
   <td><c:out value="${row.location}"/></td>
   <td><c:out value="${row.price}"/></td>
   <td><c:out value="${row.item_id}"/></td>
</tr>
</c:forEach>
</table>


<form action="profilej.jsp" method="POST">
<input type="hidden" id="thisField" name="client" value="<%= id %>" >
<div id="mail">Enter id of product you are interested id to see owner's email:</div><input type="text" name="email"  />
<input type="submit" name="mail" value="SEE EMAIL" />
</form>








<%}%>




<%if(request.getParameter("email")!="" && request.getParameter("mail")!=null){
    
    PreparedStatement statement = null;
    ResultSet resultSet = null;
    try{
Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/reg", "root", "%so11333");


                 statement = conn.prepareStatement("SELECT owner FROM product WHERE item_id=?");
                 
                 
                statement.setInt(1, Integer.parseInt(request.getParameter("email")));
                resultSet = statement.executeQuery();
                resultSet.next();
                
                System.out.println("GODZILLAAA"+resultSet.getInt("owner"));
    }catch(NumberFormatException e){}    

    
  %>
  
  
  <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://localhost:3306/reg"
     user="root"  password="%so11333"/>
  <sql:query dataSource="${snapshot}" var="result">
SELECT * from entries WHERE client_id="<%= resultSet.getInt("owner") %>" ;
</sql:query>
<table class="t1">
    <tr class="t2">
   <th>EMAIL</th> 
</tr>  
  <c:forEach var="row" items="${result.rows}">
      <tr class="t3">
   <td><c:out value="${row.email}"/></td>
   
</tr>
</c:forEach>
</table>
  
<%}%>





<%-- Kwdikas upeuthinos gia eisagwgi neas prosforas --%>
<%
     if(request.getParameter("prname")!=null && request.getParameter("price")!=null && request.getParameter("b3")!=null){
     
Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/reg", "root", "%so11333");

                 
            try{
                
                
                
            String sqlin="Insert into offer values(?,?,?,?)";
            PreparedStatement pst=conn.prepareStatement(sqlin);
            
            pst.setString(1,request.getParameter("prname") );
            pst.setDouble(2,Double.parseDouble(request.getParameter("price")) ); 
            pst.setString(3, null);
            pst.setInt(4,Integer.parseInt(request.getParameter("client")) );
            
            int i=pst.executeUpdate();}catch(Exception e){
                System.out.println("SOMETHING WENT WRONG"+e);
            }

            
                       
                       conn.close();



         


}%>










<%-- Kwdikas upeuthinos gia emfanisi prosforwn kai twn id tous --%>
<%
  if(request.getParameter("b1")!=null){%>
  
  <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://localhost:3306/reg"
     user="root"  password="%so11333"/>
  <sql:query dataSource="${snapshot}" var="result">
SELECT * from offer WHERE owner_id=<%= id %> ;
</sql:query>
<table  class="t1">
    <tr class="t2">
   <th>Name of product</th>
   <th>Price (euros per kilo)</th>
   <th>id</th>
   
</tr>
<c:forEach var="row" items="${result.rows}">
    <tr class="t3">
   <td><c:out value="${row.name}"/></td>
   <td><c:out value="${row.offeri}"/></td>
   <td><c:out value="${row.offer_id}"/></td>
</tr>
</c:forEach>
</table>





<form action="profilej.jsp" method="POST">
<input type="hidden" id="thisField" name="client" value="<%= id %>" >
<div id="del">Enter id of offer you would like to withdraw:</div><input type="text" name="with"  />
<input type="submit" name="b4" value="WITHDRAW" />
</form>

<%  }%>












<%-- Kwdikas upeuthinos gia diagrafi prosforas --%>
<%

if(request.getParameter("with")!="" && request.getParameter("b4")!=null){
    
int offerd=Integer.parseInt(request.getParameter("with"));
System.out.println("opa laou la :"+offerd);
%>



<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://localhost:3306/reg"
     user="root"  password="%so11333"/>
 

 
<sql:update dataSource="${snapshot}" var="count">
  DELETE FROM offer WHERE offer_id = <%= offerd%>;

</sql:update>
  <%}%>


    </body>
</html>

 


