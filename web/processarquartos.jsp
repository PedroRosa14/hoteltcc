<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Processamento da Seleção</title>
    <style>
        /* Estilos gerais para a página */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            padding: 20px;
            margin: 0;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        h3 {
            color: #555;
            margin-bottom: 20px;
        }

        .room-card {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
            margin: 0 auto;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        .room-card h4 {
            font-size: 18px;
            color: #333;
            margin-bottom: 10px;
        }

        .room-card p {
            font-size: 14px;
            margin: 8px 0;
            color: #666;
        }

        .room-card .price {
            font-size: 20px;
            font-weight: bold;
            color: #e67e22; /* Cor para destacar o preço */
            margin-top: 15px;
        }

        button {
            padding: 12px 25px;
            background-color: #f3d177;
            color: #333;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
            transition: background-color 0.3s ease;
        }

        button a {
            color: #333;
            text-decoration: none;
        }

        button:hover {
            background-color: #e0be5d;
        }
    </style>
</head>
<body>

    <h1>Detalhes do Quarto Selecionado</h1>
    <%
        // Conexão com o banco de dados
        String url = "jdbc:mysql://localhost:3306/hotel"; // URL do banco
        String usuario = "root";  // Usuário do banco
        String senha = "";        // Senha do banco

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        // Recebe o quarto selecionado (valor do botão de rádio)
        String quartoSelecionado = request.getParameter("quarto");

        if (quartoSelecionado != null && !quartoSelecionado.isEmpty()) {
            try {
                // Estabelecer a conexão com o banco de dados
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, usuario, senha);

                // Consultar os detalhes do quarto selecionado
                String query = "SELECT quarto_id, numero, tipo, preco_diaria FROM quartos WHERE quarto_id = ?";
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, Integer.parseInt(quartoSelecionado));
                rs = stmt.executeQuery();

                if (rs.next()) {
                    int id = rs.getInt("quarto_id");
                    String numero = rs.getString("numero");
                    String tipo = rs.getString("tipo");
                    double preco = rs.getDouble("preco_diaria");

                    // Exibe os detalhes do quarto selecionado em um card
                    out.println("<div class='room-card'>");
                    out.println("<h4>Quarto " + numero + "</h4>");
                    out.println("<p><strong>Tipo:</strong> " + tipo + "</p>");
                    out.println("<p><strong>Preço:</strong> R$ " + String.format("%.2f", preco) + "</p>");
                    out.print("<button><a href='check.html'>Check-in</a></button>");
                    out.println("</div>");
                } else {
                    out.println("<p>O quarto selecionado não foi encontrado.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Ocorreu um erro ao processar sua seleção.</p>");
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } else {
            out.println("<p>Nenhum quarto foi selecionado.</p>");
        }
    %>

</body>
</html>
