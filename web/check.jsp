<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Confirmação de Reserva</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        h1 { text-align: center; color: #333; }
        .container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); margin: 20px auto; max-width: 600px; }
        .result { margin-bottom: 15px; font-size: 18px; color: #333; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .btn-back { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; display: inline-block; text-align: center; }
        .btn-back:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<div class="container">
    <%
        // Recebendo os parâmetros do formulário
        String quartoId = request.getParameter("quarto_id");
        String checkin = request.getParameter("checkin");
        String checkout = request.getParameter("checkout");
        String idCliente = request.getParameter("id_cliente"); // Recupera o id_cliente do formulário

        boolean reservaConcluida = false; // Variável para controlar se a reserva foi concluída

        // Validando se o id_cliente é numérico
        if (idCliente == null || !idCliente.matches("\\d+")) {
            out.println("<p class='error'>Erro: O ID do cliente deve ser um número válido.</p>");
        } else {
            // Verificando se as datas estão presentes
            if (checkin == null || checkout == null || checkin.isEmpty() || checkout.isEmpty()) {
                out.println("<p class='error'>Erro: As datas de check-in e check-out são obrigatórias.</p>");
            } else {
                try {
                    // Formato de data esperado
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

                    // Parse das datas de check-in e check-out
                    LocalDate checkinDate = LocalDate.parse(checkin, formatter);
                    LocalDate checkoutDate = LocalDate.parse(checkout, formatter);
                    LocalDate currentDate = LocalDate.now(); // Data atual

                    // Validações de datas
                    if (checkoutDate.isBefore(checkinDate)) {
                        out.println("<p class='error'>Erro: A data de check-out não pode ser anterior à data de check-in.</p>");
                    } else if (checkinDate.isBefore(currentDate)) {
                        out.println("<p class='error'>Erro: A data de check-in não pode ser anterior ao dia atual.</p>");
                    } else {
                        // Calculando a diferença de dias
                        long diffInDays = ChronoUnit.DAYS.between(checkinDate, checkoutDate);

                        if (diffInDays < 2) {
                            out.println("<p class='error'>Erro: A estadia mínima entre check-in e check-out é de 2 dias.</p>");
                        } else {
                            // Conexão com o banco de dados
                            Connection conn = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;

                            try {
                                // Conexão com o banco de dados
                                String url = "jdbc:mysql://localhost:3306/hotel";
                                String usuario = "root";
                                String senha = "";
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(url, usuario, senha);

                                // Verificando a disponibilidade do quarto
                                String verificaReservaQuery = "SELECT * FROM reservas WHERE quarto_id = ? AND ((? BETWEEN checkin AND checkout) OR (? BETWEEN checkin AND checkout))";
                                stmt = conn.prepareStatement(verificaReservaQuery);
                                stmt.setInt(1, Integer.parseInt(quartoId));
                                stmt.setDate(2, java.sql.Date.valueOf(checkinDate));
                                stmt.setDate(3, java.sql.Date.valueOf(checkoutDate));

                                rs = stmt.executeQuery();

                                if (rs.next()) {
                                    out.println("<p class='error'>Erro: O quarto já está reservado para essas datas.</p>");
                                } else {
                                    // Realizando a reserva
                                    String query = "INSERT INTO reservas (quarto_id, checkin, checkout, id_cliente) VALUES (?, ?, ?, ?)";
                                    stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
                                    stmt.setInt(1, Integer.parseInt(quartoId));
                                    stmt.setDate(2, java.sql.Date.valueOf(checkinDate));
                                    stmt.setDate(3, java.sql.Date.valueOf(checkoutDate));
                                    stmt.setInt(4, Integer.parseInt(idCliente)); // Atribuindo id_cliente à reserva

                                    int result = stmt.executeUpdate();

                                    if (result > 0) {
                                        // Recuperando o id da reserva gerada
                                        rs = stmt.getGeneratedKeys();
                                        if (rs.next()) {
                                            int reservaId = rs.getInt(1);

                                            // Exibindo informações de reserva
                                            out.println("<h1>Reserva Confirmada</h1>");
                                            out.println("<div class='result'><strong>ID da Reserva:</strong> " + reservaId + "</div>");
                                            out.println("<div class='result'><strong>Check-in:</strong> " + checkinDate.format(formatter) + "</div>");
                                            out.println("<div class='result'><strong>Check-out:</strong> " + checkoutDate.format(formatter) + "</div>");
                                            out.println("<p class='success'>Reserva realizada com sucesso!</p>");

                                            reservaConcluida = true; // Marca que a reserva foi concluída
                                        }
                                    } else {
                                        out.println("<p class='error'>Erro ao realizar a reserva.</p>");
                                    }
                                }
                            } catch (Exception e) {
                                out.println("<p class='error'>Erro ao processar a reserva: " + e.getMessage() + "</p>");
                            } finally {
                                try {
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                    if (rs != null) rs.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Erro ao processar as datas: " + e.getMessage() + "</p>");
                }
            }
        }
    %>

    <a id="btnRedirect" class="btn-back" href="#">Voltar para Página</a>
</div>

<script>
    // Verificando o status da reserva e alterando o link
    var reservaConcluida = <%= reservaConcluida ? "true" : "false" %>;

    if (reservaConcluida) {
        // Se a reserva foi concluída, redireciona para a home
        document.getElementById('btnRedirect').href = 'index.html';
    } else {
        // Se a reserva não foi concluída, redireciona para o formulário
        document.getElementById('btnRedirect').href = 'check.html';
    }
</script>
</body>
</html>
