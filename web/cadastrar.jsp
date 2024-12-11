<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Cadastro</title>
    <style>
        /* Reset de estilo */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Corpo */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        /* Formulário */
        form {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            margin: 0 auto;
        }

        label {
            font-weight: bold;
            margin-bottom: 8px;
            display: block;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .warning {
            color: red;
            font-size: 0.9em;
        }

        button {
            background-color: #d3b170;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }

        button:hover {
            background-color: #c1a15c;
        }

        .button-container {
            text-align: center;
            margin-top: 20px;
        }

        .button-container button {
            width: 50%; /* Reduz a largura do botão */
            padding: 10px; /* Ajusta o padding */
            font-size: 14px; /* Reduz o tamanho da fonte */
            background-color: #d3b170;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .button-container button:hover {
            background-color: #c1a15c;
        }

        .result-container {
            text-align: center;
            margin-top: 20px;
        }

        /* Media Queries para responsividade */
        @media (max-width: 768px) {
            form {
                padding: 15px;
            }

            input, button {
                padding: 8px;
            }

            h1 {
                font-size: 24px;
            }

            button {
                font-size: 16px;
            }

            .warning {
                font-size: 0.8em;
            }

            .button-container button {
                width: 60%; /* Ajusta largura para telas menores */
            }
        }

        @media (max-width: 480px) {
            form {
                padding: 10px;
            }

            h1 {
                font-size: 20px;
            }

            input, button {
                padding: 8px;
            }

            .warning {
                font-size: 0.75em;
            }

            .button-container button {
                width: 70%; /* Ajusta largura para telas muito pequenas */
            }
        }
    </style>
</head>
<body>

<%
    String nome = request.getParameter("nome");
    String e = request.getParameter("email");
    String s = request.getParameter("senha");
    String cpf = request.getParameter("cpf");
    String numeroStr = request.getParameter("numero");
    
    String cpfMensagem = "";
    String numeroMensagem = "";
    String mensagem = "";
    boolean valido = true;

    // Validação do nome
    if (nome == null || nome.trim().isEmpty()) {
        out.print("<div class='error'>Por favor, insira seu nome.</div>");
        valido = false;
    } else if (!nome.matches("^[A-Za-z]+$")) {
        out.print("<div class='error'>O nome deve conter apenas letras (A-Z) e sem acentos.</div>");
        valido = false;
    }

    // Validação do CPF
    if (cpf == null || cpf.replaceAll("[^0-9]", "").length() != 11) {
        cpfMensagem = "CPF deve ter exatamente 11 dígitos!";
        valido = false;
    } else {
        cpf = cpf.replaceAll("[^0-9]", ""); // Remove caracteres não numéricos
        if (cpf.matches("(\\d)\\1{10}")) {
            cpfMensagem = "CPF inválido!";
            valido = false;
        } else {
            int soma = 0, primeiroDigito, segundoDigito;
            for (int i = 0; i < 9; i++) {
                soma += Character.getNumericValue(cpf.charAt(i)) * (10 - i);
            }
            primeiroDigito = (soma * 10) % 11;
            if (primeiroDigito == 10) primeiroDigito = 0;

            if (Character.getNumericValue(cpf.charAt(9)) != primeiroDigito) {
                cpfMensagem = "CPF inválido!";
                valido = false;
            }

            soma = 0;
            for (int i = 0; i < 10; i++) {
                soma += Character.getNumericValue(cpf.charAt(i)) * (11 - i);
            }
            segundoDigito = (soma * 10) % 11;
            if (segundoDigito == 10) segundoDigito = 0;

            if (Character.getNumericValue(cpf.charAt(10)) != segundoDigito) {
                cpfMensagem = "CPF inválido!";
                valido = false;
            }
        }
    }

    // Validação do Número de Telefone
    if (numeroStr == null || numeroStr.replaceAll("[^0-9]", "").length() != 11) {
        numeroMensagem = "Número deve ter exatamente 11 dígitos, incluindo o DDD!";
        valido = false;
    } else {
        numeroStr = numeroStr.replaceAll("[^0-9]", ""); // Remove caracteres não numéricos
    }

    // Inserção no banco
    if (valido && cpfMensagem.isEmpty() && numeroMensagem.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/hotel";
            String user = "root";
            String password = "";
            Connection con = DriverManager.getConnection(url, user, password);
            String sql = "INSERT INTO clientes (nome ,email, senha, cpf, numero) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nome);
            ps.setString(2, e);
            ps.setString(3, s);
            ps.setString(4, cpf);
            ps.setString(5, numeroStr);
            
            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                mensagem = "Cadastro realizado com sucesso!";
            } else {
                mensagem = "Cadastro não realizado.";
            }
            ps.close();
            con.close();
        } catch (ClassNotFoundException ex) {
            mensagem = "Driver do banco de dados não encontrado: " + ex.getMessage();
        } catch (SQLException ex) {
            if (ex.getErrorCode() == 1062) {
                mensagem = "Erro: O e-mail já está em uso. Por favor, insira outro.";
            } else {
                mensagem = "Erro ao conectar ao banco de dados: " + ex.getMessage();
            }
        }
    }
%>

<div class="result-container">
    <h1>Resultado do Cadastro</h1>
    <p>Status: <%= mensagem %></p>
</div>

<%
    if (!valido) {
%>
    <form action="cadastrar.jsp" method="post">
        <label for="nome">Nome:</label>
        <input type="text" name="nome" value="<%= nome != null ? nome : "" %>" required>
        
        <label for="email">Email:</label>
        <input type="email" name="email" value="<%= e != null ? e : "" %>" required>
        
        <label for="senha">Senha:</label>
        <input type="password" name="senha" value="<%= s != null ? s : "" %>" required>
        
        <label for="cpf">CPF:</label>
        <input type="text" name="cpf" value="<%= cpf != null ? cpf : "" %>" required>
        <span class="warning"><%= cpfMensagem %></span>
        
        <label for="numero">Número Tel (com DDD):</label>
        <input type="text" id="numero" name="numero" value="<%= numeroStr != null ? numeroStr : "" %>" required pattern="\d{11}">
        <span class="warning"><%= numeroMensagem %></span>

        <button type="submit">Cadastrar</button>
    </form>
<%
    } else {
%>
    <div class="button-container">
        <a href="entrar.html"><button>Prosseguir</button></a>
    </div>
<%
    }
%>

</body>
</html>
