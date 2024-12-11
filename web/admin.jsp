<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            text-align: center;
            background-color: #f4f4f4;
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        /* Estilos para as mensagens */
        .success {
            color: green;
            font-size: 30px;
        }

        .error, .info {
            color: red;
            font-size: 30px;
        }

        .info {
            color: blue;
        }

        /* Estilos para o botão */
        button {
            padding: 10px 20px;
            font-size: 18px;
            margin-top: 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        /* Responsividade */
        @media (max-width: 768px) {
            h1 {
                font-size: 20px;
            }

            .success, .error, .info {
                font-size: 24px;
            }

            button {
                padding: 10px 15px;
                font-size: 16px;
            }
        }

        @media (max-width: 480px) {
            h1 {
                font-size: 18px;
            }

            .success, .error, .info {
                font-size: 20px;
            }

            button {
                padding: 10px 12px;
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

            // Consulta ao banco de dados com email e senha
            String sql = "SELECT * FROM admin WHERE email=?";
            pst = conecta.prepareStatement(sql);
            pst.setString(1, email);
            
            rs = pst.executeQuery();

            if (rs.next()) {
                // O email existe, agora vamos verificar a senha
                if (rs.getString("senha").equals(senha)) {
                    String nomeUsuario = rs.getString("nome");
                    message = "<p class='success'>Login realizado com sucesso! Bem-vindo, " + nomeUsuario + ".</p>";
                    message += "<form action='relatorio.html' method='get'>";
                    message += "<button type='submit'>Prosseguir para a próxima tela</button>";
                    message += "</form>";
                } else {
                    message = "<p class='error'>Login falhou.</p>";
                    message += "<p class='info'>A senha está incorreta. <a href='admin.html'>Tente novamente.</a></p>";
                }
            } else {
                message = "<p class='error'>Login falhou.</p>";
                message += "<p class='info'>Verifique se o email está correto ou se você possui uma conta.</p>";
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
