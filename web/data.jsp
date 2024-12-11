<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter, java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Relatório de Reservas</title>  
    <style>
/* Reset básico */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

/* Estilo do corpo */
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    min-height: 100vh; /* Faz o corpo ocupar a altura total da tela */
}

/* Cabeçalho */
header {
    background-color: #d3b170;
    color: white;
    padding: 20px;
    text-align: center;
}

/* Navegação - Nav */
nav {
    background-color: rgba(211, 177, 112, 0.5); /* Barra semitransparente */
    padding: 1rem;
    position: fixed;
    top: 50px;
    left: 0;
    width: 100%;
    z-index: 1000;
}

/* Estilo básico para a lista de navegação */
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

/* Estilo para os links de navegação */
nav ul li a {
    color: white;
    text-decoration: none;
    font-weight: bold;
    font-size: 1rem;
    padding: 0.5rem 1rem;
    background-color: transparent;
    border-radius: 0;
    transition: color 0.3s, background-color 0.3s;
}

nav ul li a:hover {
    color: #f4f4f9;
    background-color: transparent;
    text-decoration: underline;
}
/* Estilo da tabela */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    overflow-x: auto;
    -webkit-overflow-scrolling: touch; /* Suporte a rolagem suave em dispositivos móveis */
}

th, td {
    padding: 12px;
    border: 1px solid #ccc;
    text-align: center;
}

th {
    background-color: #d3b170;
    color: white;
    font-weight: bold;
}

td {
    background-color: #fff;
}

/* Estilo do contêiner de conteúdo */
.container {
    padding: 20px;
    max-width: 1200px;
    margin: 0 auto;
    flex-grow: 1; /* Permite que o contêiner ocupe o espaço restante */
}

/* Rodapé */
footer {
    background-color: #d3b170; /* Cor de fundo do footer */
    color: black; /* Cor do texto */
    padding: 2rem 0; /* Aumentei o padding para tornar o footer mais alto */
    text-align: center; /* Centraliza o texto */
    width: 100%; /* Garante que o rodapé ocupe a largura total */
    position: relative; /* Garantir o posicionamento adequado */
    margin-top: auto; /* Faz com que o footer seja empurrado para o final da página */
}

footer p {
    font-size: 1rem; /* Ajustei o tamanho da fonte */
    margin: 0.5rem 0; /* Adiciona um pequeno espaçamento entre as linhas */
}

/* Media Queries para responsividade */
@media (max-width: 768px) {
    nav ul {
        flex-direction: row;
        gap: 1rem;
    }

    table {
        font-size: 14px;
    }

    th, td {
        padding: 8px;
    }

    header h1 {
        font-size: 24px;
    }

    footer p {
        font-size: 0.9rem;
    }
}

@media (max-width: 480px) {
    header h1 {
        font-size: 20px;
    }

    table {
        font-size: 12px;
    }

    th, td {
        padding: 6px;
    }

    nav ul {
        flex-direction: row;
        gap: 1rem;
    }

    footer p {
        font-size: 0.8rem;
    }

    .container {
        padding: 10px;
    }
}

/* Ajuste adicional para celulares menores */
@media (max-width: 360px) {
    nav ul li a {
        padding: 0.5rem 1rem;
        font-size: 0.9rem;
    }

    table {
        font-size: 10px;
    }

    th, td {
        padding: 4px;
    }

    header {
        padding: 10px;
    }

    footer p {
        font-size: 0.7rem;
    }
}
</style>
</head>
<body>

<header>
    <h1>Relatório de Reservas</h1>
</header>

<nav>
    <ul>
        <li><a href="index.html">Home</a></li>
        <li><a href="relatorio.html">Relatório</a></li>
        <li><a href="reservas.html">Reservas</a></li>
    </ul>
</nav>

<div class="container">
    <h2>Detalhes das Reservas</h2>
    <table>
        <thead>
            <tr>
                <th>Nome do Hóspede</th>
                <th>Número do Quarto</th>
                <th>Tipo de Quarto</th>
                <th>Check-in</th>
                <th>Check-out</th>
            </tr>
        </thead>
        <tbody>
        <%
            // Recebe as datas de check-in e check-out
            String checkinStr = request.getParameter("checkin");
            String checkoutStr = request.getParameter("checkout");

            // Formato para exibição das datas
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            if (checkinStr != null && checkoutStr != null) {
                try {
                    // Parse das datas no formato "yyyy-MM-dd"
                    LocalDate checkinDate = LocalDate.parse(checkinStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    LocalDate checkoutDate = LocalDate.parse(checkoutStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

                    // Conexão com o banco de dados
                    String url = "jdbc:mysql://localhost:3306/hotel";
                    String usuario = "root";
                    String senha = "";

                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Conectar ao banco de dados
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, usuario, senha);

                        // Consulta SQL para buscar as reservas
                        String query = "SELECT c.nome, q.numero, q.tipo, r.checkin, r.checkout "
                                       + "FROM reservas r "
                                       + "JOIN quartos q ON r.quarto_id = q.quarto_id "
                                       + "JOIN clientes c ON r.id_cliente = c.id_cliente "
                                       + "WHERE r.checkin >= ? AND r.checkout <= ? "
                                       + "ORDER BY r.checkin";

                        stmt = conn.prepareStatement(query);
                        stmt.setDate(1, java.sql.Date.valueOf(checkinDate));
                        stmt.setDate(2, java.sql.Date.valueOf(checkoutDate));
                        rs = stmt.executeQuery();

                        // Processando os resultados
                        while (rs.next()) {
                            String nomeHospede = rs.getString("nome");
                            String numeroQuarto = rs.getString("numero");
                            String tipoQuarto = rs.getString("tipo");
                            LocalDate dbCheckin = rs.getDate("checkin").toLocalDate();
                            LocalDate dbCheckout = rs.getDate("checkout").toLocalDate();

                            // Formatar as datas para o formato desejado
                            String formattedCheckin = dbCheckin.format(formatter);
                            String formattedCheckout = dbCheckout.format(formatter);

                            out.println("<tr>");
                            out.println("<td>" + nomeHospede + "</td>");
                            out.println("<td>" + numeroQuarto + "</td>");
                            out.println("<td>" + tipoQuarto + "</td>");
                            out.println("<td>" + formattedCheckin + "</td>");
                            out.println("<td>" + formattedCheckout + "</td>");
                            out.println("</tr>");
                        }

                    } catch (Exception e) {
                        out.println("<tr><td colspan='5' style='color:red;'>Erro ao buscar dados: " + e.getMessage() + "</td></tr>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' style='color:red;'>Erro ao processar as datas: " + e.getMessage() + "</td></tr>");
                }
            }
        %>
        </tbody>
    </table>
</div>

<footer>
    <div class="footer-content">
            <p><strong>SPACEROOM HOTEL</strong></p>
            <p>Endereço: R. Bento Branco de Andrade Filho, 379 - Santo Amaro, São Paulo - SP, 04757-000</p>
             <p>Contato: +11 937 717 710 | spaceroomhotel@gmail.com</p>
        </div>
</footer>

</body>
</html>
