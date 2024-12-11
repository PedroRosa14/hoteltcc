<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Entrar</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            text-align: center;
            background-color: #f5f5f5;
        }
        h1 {
            color: #333;
            font-size: 36px;
            margin-bottom: 20px;
        }
        .success, .error {
            font-size: 24px;
            padding: 20px;
            border-radius: 8px;
            margin: 15px 0;
            box-shadow: 0 4px 10px rgba(0, 128, 0, 0.1);
        }
        .success {
            color: #4CAF50;
            background-color: #dff0d8;
        }
        .error {
            color: #d9534f;
            background-color: #f2dede;
        }
        .info {
            color: #5bc0de;
            font-size: 18px;
            margin-top: 10px;
        }
        .info a {
            color: #337ab7;
            text-decoration: none;
            font-weight: bold;
        }
        .info a:hover {
            color: #23527c;
        }
        .highlight {
            font-size: 22px;
            color: #d9534f;
            font-weight: bold;
            background-color: #fff8dc;
            padding: 10px;
            border: 2px solid #f0ad4e;
            border-radius: 8px;
            display: inline-block;
            margin: 20px 0;
        }
        button {
            padding: 12px 20px;
            font-size: 16px;
            margin-top: 20px;
            background-color: #f3d177;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #e0be5d;
        }

        /* Responsividade para telas pequenas */
        @media (max-width: 600px) {
            h1 {
                font-size: 28px;
            }
            .success, .error {
                font-size: 18px;
                padding: 15px;
            }
            button {
                padding: 10px 18px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<%
    String email = request.getParameter("email");
    String senha = request.getParameter("senha");
    String message = "";

    if (email == null || senha == null) {
        message = "<p class='error'>Por favor, preencha todos os campos obrigatórios.</p>";
    } else {
        Connection conecta = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/hotel";
            String user = "root";
            String password = "";
            conecta = DriverManager.getConnection(url, user, password);

            String sql = "SELECT * FROM clientes WHERE email=?";
            pst = conecta.prepareStatement(sql);
            pst.setString(1, email);
            
            rs = pst.executeQuery();

            if (rs.next()) {
                // O email existe, agora vamos verificar a senha
                if (rs.getString("senha").equals(senha)) {
                    String idCliente = rs.getString("id_cliente"); // Recuperando o id_cliente
                    message = "<p class='success'>Login realizado com sucesso! Bem-vindo, " + email + ".</p>";
                    message += "<div class='highlight'>Seu ID de Cliente é: " + idCliente + "</div>"; // Exibindo o id_cliente com destaque
                    message += "<form action='quartos.html' method='get'>";
                    message += "<button type='submit'>Prosseguir para a próxima tela</button>";
                    message += "</form>";
                } else {
                    message = "<p class='error'>Login falhou.</p>";
                    message += "<p class='info'>A senha está incorreta. <a href='entrar.html'>Tente novamente.</a></p>";
                }
            } else {
                message = "<p class='error'>Login falhou.</p>";
                message += "<p class='info'>Verifique se o email está correto ou se você possui uma conta.</p>";
                message += "<p class='error'>Se você ainda não tem uma conta, <a href='cadastrar.html'>clique aqui para se cadastrar</a>.</p>";
            }
        } catch (ClassNotFoundException e) {
            message = "<p class='error'>Erro: Driver do banco de dados não encontrado. Verifique a configuração.</p>";
        } catch (SQLException e) {
            message = "<p class='error'>Erro ao acessar o banco de dados: " + e.getMessage() + "</p>";
        } catch (Exception e) {
            message = "<p class='error'>Erro inesperado: " + e.getMessage() + "</p>";
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conecta != null) conecta.close();
            } catch (SQLException e) {
                message += "<p class='error'>Erro ao fechar recursos: " + e.getMessage() + "</p>";
            }
        }
    }

    out.print(message);
%>

</body>
</html>
