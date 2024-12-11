<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.LocalDate, java.time.format.DateTimeFormatter, java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Consulta de Reservas</title>
    <link rel="stylesheet" href="reservas.css"> <!-- Link para o seu arquivo de estilo -->
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

/* Cabeçalho - Header */
header {
    background-color: rgba(211, 177, 112, 0.9); /* Título com fundo claro e um pouco transparente */
    color: white;
    text-align: center;
    padding: 0.5rem; /* Reduzido para que o header ocupe menos espaço */
    position: relative; /* Para garantir que o título fique no topo */
    z-index: 2; /* Fica acima de outros elementos */
    width: 100%; /* Garantir que o header ocupe toda a largura */
    margin-top: 0; /* Garantir que não há margem superior */
}
/* Navegação - Nav */
nav {
    background-color: rgba(211, 177, 112, 0.5); /* Barra de navegação semitransparente */
    padding: 1rem;
    position: fixed; /* Torna a barra de navegação fixa */
    top: 50px; /* Coloca a navegação abaixo do header (ajuste conforme necessário) */
    left: 0;
    width: 100%; /* Garante que a navegação ocupe toda a largura da tela */
    z-index: 1000; /* Fica acima do conteúdo */
 
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
    font-size: 1rem; /* Tamanho de fonte padrão */
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

/* Estilo dos resultados da consulta */
.resultado {
    margin-top: 30px;
    padding: 25px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.resultado h3 {
    text-align: center;
    color: #333;
    margin-bottom: 20px;
    font-size: 1.8rem; /* Aumenta o tamanho da fonte do título do resultado */
}

.resultado p {
    font-size: 1.2rem; /* Aumenta o tamanho da fonte dos parágrafos */
    line-height: 1.8;
}

.resultado p strong {
    color: #555;
    font-size: 1.3rem; /* Aumenta o tamanho da fonte do texto forte */
}

footer {
    background-color: #d3b170;
    text-align: center;
    color: black;
    padding: 20px;
    margin-top: auto;
}

/* Estilo para a mensagem de erro ou informação */
.error {
    color: red;
    text-align: center;
    margin-top: 20px;
}


/* Container para o botão no canto inferior direito */
.cancelar-container {
    position: relative;
    margin-top: 10px; /* Espaço superior para o botão */
}

/* Posiciona o botão no canto inferior direito */
.cancelar-btn-container {
    position: absolute;
    bottom: 15px; /* Distância do fundo da tela */
    left: 80px;  /* Distância da borda esquerda */
}


/* Responsividade para dispositivos de 768px (como tablets em modo retrato) */
@media (max-width: 768px) {
    nav ul {
        flex-direction: row;
        justify-content: space-around;
    }

    nav ul li {
        margin: 0.1rem; /* Ajustando o espaçamento */
    }

    nav ul li a {
        font-size: 0.9rem; /* Reduzindo o tamanho da fonte para telas menores */
        padding: 0.4rem 0.8rem; /* Ajustando o padding */
    }
    
    /* Estilo dos resultados da consulta */
.resultado {
    margin-top: 30px;
    padding: 25px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.resultado h3 {
    text-align: center;
    color: #333;
    margin-bottom: 20px;
    font-size: 1rem; /* Aumenta o tamanho da fonte do título do resultado */
}

.resultado p {
    font-size: 1rem; /* Aumenta o tamanho da fonte dos parágrafos */
    line-height: 1.8;
}

.resultado p strong {
    color: #555;
    font-size: 1rem; /* Aumenta o tamanho da fonte do texto forte */
}
    
/* Container para o botão no canto inferior direito */
.cancelar-container {
    position: relative;
    margin-top: 10px; /* Espaço superior para o botão */
}

/* Posiciona o botão no canto inferior direito */
.cancelar-btn-container {
    position: absolute;
    bottom: 15px; /* Distância do fundo da tela */
    left: 60px;  /* Distância da borda esquerda */
}



/* Responsividade para dispositivos de 480px (como celulares em modo retrato) */
@media (max-width: 480px) {
    nav ul {
        flex-direction: row; /* Mudando para uma lista vertical */
        align-items: center; /* Centralizando os links */
    }

    nav ul li {
        margin: 0.1rem 0; /* Diminui o espaçamento entre os links */
    }

    nav ul li a {
        font-size: 0.8rem; /* Tamanho de fonte menor para telas muito pequenas */
        padding: 0.6rem 1rem; /* Ajuste de padding */
    }
   /* Estilo dos resultados da consulta */
.resultado {
    margin-top: 30px;
    padding: 25px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.resultado h3 {
    text-align: center;
    color: #333;
    margin-bottom: 20px;
    font-size: 1rem; /* Aumenta o tamanho da fonte do título do resultado */
}

.resultado p {
    font-size: 1rem; /* Aumenta o tamanho da fonte dos parágrafos */
    line-height: 1.8;
}

.resultado p strong {
    color: #555;
    font-size: 1rem; /* Aumenta o tamanho da fonte do texto forte */
}
    
/* Container para o botão no canto inferior direito */
.cancelar-container {
    position: relative;
    margin-top: 10px; /* Espaço superior para o botão */
}

/* Posiciona o botão no canto inferior direito */
.cancelar-btn-container {
    position: absolute;
    bottom: 10px; /* Distância do fundo da tela */
    left: 50px;  /* Distância da borda esquerda */
}


/* Responsividade para dispositivos de 320px (como celulares mais antigos) */
@media (max-width: 320px) {
    nav ul {
        flex-direction: row; /* Lista vertical para telas muito pequenas */
        align-items: center;
    }

    nav ul li {
        margin: 0.2rem 0; /* Ajuste ainda mais o espaçamento */
    }

    nav ul li a {
        font-size: 0.7rem; /* Tamanho de fonte ainda menor para telas muito pequenas */
        padding: 0.4rem 0.8rem; /* Ajuste final no padding */
    }

      /* Estilo dos resultados da consulta */
.resultado {
    margin-top: 30px;
    padding: 40px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.resultado h3 {
    text-align: center;
    color: #333;
    margin-bottom: 20px;
    font-size: 1rem; /* Aumenta o tamanho da fonte do título do resultado */
}

.resultado p {
    font-size: 1rem; /* Aumenta o tamanho da fonte dos parágrafos */
    line-height: 1.8;
}

.resultado p strong {
    color: #555;
    font-size: 1rem; /* Aumenta o tamanho da fonte do texto forte */
}
    
/* Container para o botão no canto inferior direito */
.cancelar-container {
    position: relative;
    margin-top: 10px; /* Espaço superior para o botão */
}

/* Posiciona o botão no canto inferior direito */
.cancelar-btn-container {
    position: absolute;
    bottom: 15px; /* Distância do fundo da tela */
    left: 25px;  /* Distância da borda esquerda */
}

    </style>
</head>
<body>

    <!-- Cabeçalho -->
    <header>
        <h1>Consulta de Reservas</h1>
    </header>

    <!-- Navegação -->
    <nav>
        <ul>
            <li><a href="index.html">Home</a></li>
            <li><a href="relatorio.html">Relatório</a></li>
            <li><a href="reservas.html">Reservas</a></li>
            <li><a href="data.html">Data</a></li>
        </ul>
    </nav>

    <!-- Formulário de busca -->
    <main>
        <div class="reservation-container">
            <h2>Consultar Reserva</h2>
            <form method="get" action="reservas.jsp">
                <label for="id_reserva">ID da Reserva:</label>
                <input type="text" id="id_reserva" name="id_reserva" placeholder="Digite o ID da reserva" required>
                <button type="submit">Buscar</button>
            </form>

            <%
                // Obtendo o ID da Reserva da requisição
                String idReserva = request.getParameter("id_reserva");
                if (idReserva != null && !idReserva.isEmpty()) {
                    // Conectar ao banco de dados
                    String url = "jdbc:mysql://localhost:3306/hotel";  // Substitua pelo URL correto do seu banco
                    String user = "root";  // Substitua pelo seu usuário do banco
                    String password = "";  // Substitua pela sua senha do banco

                    // Variáveis para armazenar os dados
                    String nomeCliente = "";
                    String emailCliente = "";
                    String numeroQuarto = "";
                    String tipoQuarto = "";
                    String checkin = "";
                    String checkout = "";
                    double precoDiaria = 0.0;  // Variável para armazenar o preço da diária
                    double precoTotal = 0.0;  // Variável para armazenar o preço total

                    try {
                        // Estabelecendo a conexão com o banco de dados
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(url, user, password);
                        
                        // Consulta para buscar as informações da reserva pelo ID da reserva
                        String sql = "SELECT c.nome AS cliente_nome, c.email AS cliente_email, q.numero AS quarto_numero, "
                                   + "q.tipo AS quarto_tipo, q.preco_diaria, r.checkin, r.checkout "
                                   + "FROM reservas r "
                                   + "JOIN clientes c ON r.id_cliente = c.id_cliente "
                                   + "JOIN quartos q ON r.quarto_id = q.quarto_id "
                                   + "WHERE r.reserva_id = ?";
                        
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(idReserva));
                        
                        ResultSet rs = ps.executeQuery();

                        // Verificando se encontrou o resultado
                        if (rs.next()) {
                            nomeCliente = rs.getString("cliente_nome");
                            emailCliente = rs.getString("cliente_email");
                            numeroQuarto = rs.getString("quarto_numero");
                            tipoQuarto = rs.getString("quarto_tipo");
                            precoDiaria = rs.getDouble("preco_diaria");  // Obtemos o preço da diária
                            checkin = rs.getString("checkin");
                            checkout = rs.getString("checkout");

                            // Definindo o formatador para o padrão "dd/MM/yyyy"
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

                            // Convertendo as datas para o formato "dd/MM/yyyy"
                            String checkinFormatado = LocalDate.parse(checkin).format(formatter);
                            String checkoutFormatado = LocalDate.parse(checkout).format(formatter);

                            // Convertendo para objetos LocalDate para calcular a diferença em dias
                            LocalDate checkinDate = LocalDate.parse(checkin);
                            LocalDate checkoutDate = LocalDate.parse(checkout);

                            // Calculando a diferença de dias entre o checkin e checkout
                            long diasReserva = ChronoUnit.DAYS.between(checkinDate, checkoutDate);

                            // Calculando o preço total
                            precoTotal = diasReserva * precoDiaria;

                            // Passando as datas formatadas para o JSP
                            request.setAttribute("checkinFormatado", checkinFormatado);
                            request.setAttribute("checkoutFormatado", checkoutFormatado);
                        }

                        // Fechando a conexão
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    // Exibindo os dados da reserva
                    if (!nomeCliente.isEmpty()) {
            %>

            <div class="resultado">
                <h3>Detalhes da Reserva</h3>
                <p><strong>ID da Reserva:</strong> <%= idReserva %></p>
                <p><strong>Nome do Cliente:</strong> <%= nomeCliente %></p>
                <p><strong>Email do Cliente:</strong> <%= emailCliente %></p>
                <p><strong>Número do Quarto:</strong> <%= numeroQuarto %></p>
                <p><strong>Tipo de Quarto:</strong> <%= tipoQuarto %></p>
                <p><strong>Check-in:</strong> <%= request.getAttribute("checkinFormatado") %></p>
                <p><strong>Check-out:</strong> <%= request.getAttribute("checkoutFormatado") %></p>
                <p><strong>Preço da Diária:</strong> R$ <%= String.format("%.2f", precoDiaria) %></p>
                <p><strong>Preço Total:</strong> R$ <%= String.format("%.2f", precoTotal) %></p>
            </div>

            <div class="cancelar-container">
                <div class="cancelar-btn-container">
                <button class="cancelar-btn" onclick="window.location.href='cancelarreservas.jsp?id_reserva=<%= idReserva %>'">Cancelar</button>
                </div>
            </div>

            <%
                    } else {
            %>
            <p class="error">Nenhuma reserva encontrada para o ID informado.</p>
            <%
                    }
                } else {
            %>
            <p class="error">Por favor, insira um ID de reserva válido.</p>
            <%
                }
            %>
        </div>
    </main>

    <!-- Rodapé -->
    <footer>
        <div class="footer-content">
             <p><strong>SPACEROOM HOTEL</strong></p>
            <p>Endereço: R. Bento Branco de Andrade Filho, 379 - Santo Amaro, São Paulo - SP, 04757-000</p>
            <p>Contato: +11 937 717 710 | spaceroomhotel@gmail.com</p>
    </footer>

</body>
</html>
