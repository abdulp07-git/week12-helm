<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">
    <title>Java Web Application</title>
    <style>
        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .button-link {
            text-decoration: none;
            color: white;
            background-color: #0056b3;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 24px;
            text-align: center;
            cursor: pointer;
            display: inline-block;
        }

        .button-link:hover {
            background-color: #003f7f;
        }

        h2 {
            color: #0056b3;
            border-bottom: 2px solid #0056b3;
            padding-bottom: 10px;
        }

        .container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border: 1px solid #ddd;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th, table td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }

        table th {
            background-color: #f8f8f8;
        }

        span {
            font-weight: normal;
            color: #555;
        }
    </style>
</head>
<body>

<%
    String hostName = InetAddress.getLocalHost().getHostName();
    String ipAddr = InetAddress.getLocalHost().getHostAddress();
    String serverName = System.getProperty("java.vm.name");
    Date Time = new Date();
    String Dtime = Time.toString();
%>

<div class="header">
    <a href="http://intodepth.in" class="button-link">JAVA</a>
    <a href="http://intodepth.in/nginx" class="button-link">NGINX</a>
</div>

<div class="container">
    <h2>Server Information</h2>
    <div>
        <p><strong>Host Name:</strong> <span><%= hostName %></span></p>
        <p><strong>IP Address:</strong> <span><%= ipAddr %></span></p>
        <p><strong>JVM Name:</strong> <span><%= serverName %></span></p>
        <p><strong>Date & Time:</strong> <span><%= Dtime %></span></p>
    </div>
</div>

<div class="container">
    <h2>HTTP Request Information</h2>
    <p><strong>Request URL:</strong> <span><%= request.getRequestURL() %></span></p>
    <p><strong>Request Method:</strong> <span><%= request.getMethod() %></span></p>

    <h3>Request Headers</h3>
    <table>
        <thead>
            <tr>
                <th>Header Name</th>
                <th>Header Value</th>
            </tr>
        </thead>
        <tbody>
            <%
                Enumeration enumeration = request.getHeaderNames();
                while (enumeration.hasMoreElements()) {
                    String name = (String) enumeration.nextElement();
                    String value = request.getHeader(name);
            %>
            <tr>
                <td><%= name %></td>
                <td><%= value %></td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <h3>Cookies Received</h3>
    <table>
        <thead>
            <tr>
                <th>Cookie Name</th>
                <th>Cookie Value</th>
            </tr>
        </thead>
        <tbody>
            <%
                Cookie[] cookies = request.getCookies();
                if (cookies != null && cookies.length > 0) {
                    for (Cookie cookie : cookies) {
            %>
            <tr>
                <td><%= cookie.getName() %></td>
                <td><%= cookie.getValue() %></td>
            </tr>
            <%      }
                }
            %>
        </tbody>
    </table>
</div>

</body>
</html>

