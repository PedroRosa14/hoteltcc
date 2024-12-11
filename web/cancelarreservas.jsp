<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Cancelamento de Reserva</title>
    <link rel="stylesheet" href="reservas.css">
    <style>
  
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

        /* Container do cancelamento */
        .cancelamento-container {
            text-align: center;
            margin-top: 50px;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 500px;
            margin: 50px auto;
        }

        .cancelamento-container h2 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        .cancelamento-container p {
            font-size: 18px;
            margin-bottom: 20px;
        }

        .cancelamento-btn {
            background-color: #ff4c4c; /* Vermelho para Cancelar */
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease-in-out;
        }
        .cancelamento-btn:hover {
            background-color: #e63946; /* Cor mais escura para hover */
            transform: scale(1.05);
        }

        .confirmacao-btn {
            margin: 15px;
            padding: 12px 25px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
        }

        .confirmacao-btn-sim {
            background-color: #4CAF50; /* Verde para Sim */
            color: white;
        }
        .confirmacao-btn-sim:hover {
            background-color: #45a049;
            transform: scale(1.05);
        }

        .confirmacao-btn-nao {
            background-color: #f44336; /* Vermelho para Não */
            color: white;
        }
        .confirmacao-btn-nao:hover {
            background-color: #e53935;
            transform: scale(1.05);
        }

      /* Rodapé */
footer {
    background-color: #d3b170;
    color: black;
    padding: 1rem;
    text-align: center;
    margin-top: auto;
}

.footer-content p {
    margin: 0.5rem 0;
}

/* Responsividade para dispositivos de 760px (como tablets em modo retrato) */
@media (max-width: 760px) {
    nav ul {
        flex-direction: row;
        justify-content: space-around;
    }

    nav ul li {
        margin: 0.5rem; /* Ajustando o espaçamento */
    }

    nav ul li a {
        font-size: 0.9rem; /* Reduzindo o tamanho da fonte para telas menores */
        padding: 0.4rem 0.8rem; /* Ajustando o padding */
    }


/* Responsividade para dispositivos de 480px (como celulares em modo retrato) */
@media (max-width: 480px) {
    nav ul {
        flex-direction: row; /* Mudando para uma lista vertical */
        align-items: center; /* Centralizando os links */
    }

    nav ul li {
        margin: 0.3rem 0; /* Diminui o espaçamento entre os links */
    }

    nav ul li a {
        font-size: 0.8rem; /* Tamanho de fonte menor para telas muito pequenas */
        padding: 0.6rem 1.2rem; /* Ajuste de padding */
    }
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
        padding: 0.6rem 1rem; /* Ajuste final no padding */
    }
}

    </style>
</head>
<body>

    <!-- Cabeçalho -->
    <header>
        <h1>Cancelamento de Reserva</h1>
    </header>

    <!-- Navegação -->
    <nav>
        <ul>
            <li><a href="relatorio.html">Relatório</a></li>
            <li><a href="reservas.html">Reservas</a></li>
            <li><a href="data.html">Data</a></li>
        </ul>
    </nav>

    <!-- Formulário de cancelamento -->
    <main>
        <div class="cancelamento-container">

            <%
                // Obtenha o ID da reserva da requisição (após o usuário clicar no botão de cancelar)
                String idReserva = request.getParameter("id_reserva");
                String cancelar = request.getParameter("cancelar");

                if (idReserva != null && !idReserva.isEmpty()) {

                    if ("sim".equals(cancelar)) {
                        // Conectar ao banco de dados para realizar o cancelamento
                        String url = "jdbc:mysql://localhost:3306/hotel";  // Substitua pelo URL correto do seu banco
                        String user = "root";  // Substitua pelo seu usuário do banco
                        String password = "";  // Substitua pela sua senha do banco

                        try {
                            // Estabelecendo a conexão com o banco de dados
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection(url, user, password);

                            // Consulta SQL para deletar a reserva
                            String sql = "DELETE FROM reservas WHERE reserva_id = ?";
                            PreparedStatement ps = conn.prepareStatement(sql);
                            ps.setInt(1, Integer.parseInt(idReserva));

                            // Executando a exclusão
                            int rowsAffected = ps.executeUpdate();

                            // Fechar a conexão
                            ps.close();
                            conn.close();

                            if (rowsAffected > 0) {
            %>
                                <p><strong>Reserva cancelada com sucesso!</strong></p>
                                <button class="cancelamento-btn" onclick="window.location.href='reservas.jsp'">Voltar para Reservas</button>
            <%
                            } else {
            %>
                                <p><strong>Erro ao cancelar a reserva. Por favor, tente novamente.</strong></p>
                                <button class="cancelamento-btn" onclick="window.location.href='reservas.jsp'">Voltar para Reservas</button>
            <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    } else if ("nao".equals(cancelar)) {
                        // Se o usuário escolher "Não", redireciona para a página de reservas
                        response.sendRedirect("reservas.jsp");
                    } else {
            %>
                        <p>Tem certeza de que deseja cancelar a reserva?</p>
                        <form method="get" action="cancelarreservas.jsp">
                            <input type="hidden" name="id_reserva" value="<%= idReserva %>" />
                            <button class="confirmacao-btn confirmacao-btn-sim" type="submit" name="cancelar" value="sim">Sim</button>
                            <button class="confirmacao-btn confirmacao-btn-nao" type="submit" name="cancelar" value="nao">Não</button>
                        </form>
            <%
                    }
                } else {
            %>
                    <p><strong>ID da reserva não encontrado.</strong></p>
                    <button class="cancelamento-btn" onclick="window.location.href='reservas.jsp'">Voltar para Reservas</button>
            <% } %>

        </div>
    </main>

    <!-- Rodapé -->
    <footer>
        <div class="footer-content">
          <p><strong>SPACEROOM HOTEL</strong></p>
            <p>Endereço: R. Bento Branco de Andrade Filho, 379 - Santo Amaro, São Paulo - SP, 04757-000</p>
            <p>Contato: +11 937 717 710 | spaceroomhotel@gmail.com</p>
        </div>
    </footer>

</body>
</html>
