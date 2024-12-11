<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Consulta de Reservas</title>
    <link rel="stylesheet" href="relatorio.css"/>
    <style>
        /* Centralizar o conteúdo */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 100vh;
            background-color: #f4f4f9;
        }

        header {
            background-color: rgba(211, 177, 112, 0.9); /* Título com fundo claro e um pouco transparente */
            color: white;
            text-align: center;
            padding: 1.5rem;
            position: relative; /* Permite que o título fique acima da navegação */
            z-index: 2; /* Coloca o título acima da barra de navegação */
        }

        nav {
            background-color: rgba(211, 177, 112, 0.5); /* Barra de navegação semitransparente */
            padding: 1rem;
            position: relative;
            z-index: 1;
        }

        nav ul {
            list-style-type: none;
            display: flex;
            justify-content: center;
            padding: 0;
            margin: 0;
        }

        nav ul li {
            margin: 0 1rem;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s;
        }

        nav ul li a:hover {
            color: #f4f4f9;
        }

        /* Centralizar o formulário */
        .form-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            padding: 2rem;
            margin-top: 20px;
        }

        form {
            background-color: #fff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        input[type="text"] {
            padding: 10px;
            width: 80%;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            background-color: #d3b170;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #2980b9;
        }

        footer {
            background-color: #d3b170;
            text-align: center;
            color: black;
            padding: 20px;
            margin-top: auto;
        }

        /* Estilo para a mensagem de erro ou informação */
        .message {
            color: red;
            text-align: center;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #d3b170;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        /* Responsividade para dispositivos móveis */
        @media (max-width: 600px) {
            header h1 {
                font-size: 20px;
            }

            nav ul {
                flex-direction: row; /* Fica na horizontal */
                justify-content: space-around; /* Espaça os itens igualmente */
            }

            nav ul li {
                margin: 0.5rem; /* Ajusta a margem */
            }

            .form-container {
                padding: 1rem;
            }

            form {
                width: 90%;
                padding: 1.5rem;
            }

            button {
                padding: 12px 18px;
                font-size: 14px;
            }

            .message {
                font-size: 14px;
            }

            table {
                font-size: 14px;
            }
        }

        /* Responsividade para tablets */
        @media (max-width: 768px) {
            form {
                width: 80%;
            }

            button {
                padding: 12px 24px;
                font-size: 16px;
            }

            table {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>

<header>
    <h1>Consulta de Reservas</h1>
</header>

<nav>
    <ul>
        <li><a href="index.html">Home</a></li>
        <li><a href="relatorio.jsp">Relatório</a></li>
        <li><a href="reservas.html">Reservas</a></li>
    </ul>
</nav>

<!-- Formulário de busca centralizado -->
<div class="form-container">
    <form method="get" action="relatorio.jsp">
        <!-- Título dentro do Formulário -->
        <h2>Consultar Relatório</h2>

        <label for="id_cliente">ID do Hóspede:</label>
        <input type="text" id="id_cliente" name="id_cliente" placeholder="Digite o ID do hóspede" required>
        <button type="submit">Buscar</button>
    </form>
</div>

<%
    String idCliente = request.getParameter("id_cliente"); // Obtendo o ID do hóspede enviado pelo formulário
    if (idCliente != null && !idCliente.trim().isEmpty()) {
        // Conexão com o banco de dados
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        // Formato para data no formato dd/MM/yyyy
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

        try {
            // Configuração de conexão com o banco de dados
            Class.forName("com.mysql.cj.jdbc.Driver"); // Carregando o driver JDBC
            String url = "jdbc:mysql://localhost:3306/hotel"; // URL do banco
            String user = "root"; // Usuário do banco
            String password = ""; // Senha do banco
            conn = DriverManager.getConnection(url, user, password);

            // Consulta para obter as reservas do cliente
            String sql = "SELECT r.reserva_id, c.nome, r.checkin, r.checkout " +
                         "FROM reservas r " +
                         "JOIN clientes c ON r.id_cliente = c.id_cliente " +
                         "WHERE r.id_cliente = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, Integer.parseInt(idCliente)); // Substitui o '?' pelo id_cliente

            rs = pst.executeQuery(); // Executa a consulta no banco

            // Verifica se encontrou resultados
            if (rs.next()) {
%>

            <table>
                <thead>
                    <tr>
                        <th>ID da Reserva</th>
                        <th>Nome do Hóspede</th>
                        <th>Data de Check-in</th>
                        <th>Data de Check-out</th>
                    </tr>
                </thead>
                <tbody>

                <%
                    do {
                        // Exibe os resultados na tabela
                        int reservaId = rs.getInt("reserva_id"); // Usando o nome correto da coluna
                        String nome = rs.getString("nome");
                        java.sql.Date checkin = rs.getDate("checkin");
                        java.sql.Date checkout = rs.getDate("checkout");

                        // Converte as datas para o formato desejado
                        String checkinFormatted = (checkin != null) ? dateFormat.format(checkin) : "";
                        String checkoutFormatted = (checkout != null) ? dateFormat.format(checkout) : "";
                %>

                <tr>
                    <td><%= reservaId %></td>
                    <td><%= nome %></td>
                    <td><%= checkinFormatted %></td>
                    <td><%= checkoutFormatted %></td>
                </tr>

                <%
                    } while (rs.next()); // Continua exibindo enquanto houver resultados
                %>

                </tbody>
            </table>

            <%
            } else {
                out.print("<div class='message'>Não foram encontradas reservas para o ID do cliente: " + idCliente + "</div>");
            }
        } catch (SQLException | ClassNotFoundException e) {
            out.print("<div class='message'>Erro ao consultar o banco de dados: " + e.getMessage() + "</div>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.print("<div class='message'>Erro ao fechar a conexão com o banco: " + e.getMessage() + "</div>");
            }
        }
    } else {
        out.print("<div class='message'>Por favor, informe o ID do hóspede para a busca.</div>");
    }
%>

<footer>
     <div class="footer-content">
            <p><strong>SPACEROOM HOTEL</strong></p>
            <p>Endereço: R. Bento Branco de Andrade Filho, 379 - Santo Amaro, São Paulo - SP, 04757-000</p>
             <p>Contato: +11 937 717 710 | spaceroomhotel@gmail.com</p>
        </div>
</footer>

</body>
</html>
