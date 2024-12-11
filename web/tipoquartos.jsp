<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="img/img_logo.jpeg" type="image/png">
    <title>Seleção de Quartos</title>
    <style>
        /* Estilos Gerais */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        
        .container {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 100%;
            max-width: 600px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .quartos-lista {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 16px;
            color: #555;
            margin-bottom: 10px;
            padding: 5px;
            cursor: pointer;
            background-color: #f9f9f9;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        label:hover {
            background-color: #e0e0e0;
        }

        input[type="radio"] {
            margin-right: 10px;
        }

        .btn-submit {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #007BFF;
            color: white;
            font-size: 18px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-submit:hover {
            background-color: #0056b3;
        }

        /* Responsividade para telas pequenas (smartphones) */
        @media (max-width: 600px) {
            h1 {
                font-size: 20px;
            }
            .container {
                padding: 15px;
            }
            label {
                font-size: 14px;
                padding: 8px;
            }
            .btn-submit {
                font-size: 16px;
                padding: 12px;
            }
        }

        /* Responsividade para tablets */
        @media (max-width: 768px) {
            h1 {
                font-size: 22px;
            }
            .container {
                padding: 20px;
            }
            label {
                font-size: 15px;
                padding: 6px;
            }
            .btn-submit {
                font-size: 17px;
                padding: 14px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Seleção de Quartos</h1>
    <form action="processarquartos.jsp" method="POST">
        <div class="quartos-lista">
            <!-- Quarto 101 -->
            <label>
                <input type="radio" name="quarto" value="1" required>
                Quarto 101 - Individual - R$ 200,00
            </label>
            <!-- Quarto 102 -->
            <label>
                <input type="radio" name="quarto" value="2">
                Quarto 102 - Casal - R$ 300,00
            </label>
            <!-- Quarto 103 -->
            <label>
                <input type="radio" name="quarto" value="3">
                Quarto 103 - Duplo - R$ 350,00
            </label>
            <!-- Quarto 104 -->
            <label>
                <input type="radio" name="quarto" value="4">
                Quarto 104 - Deluxe - R$ 500,00
            </label>
        </div>

        <button type="submit" class="btn-submit">Confirmar Seleção</button>
    </form>
</div>

</body>
</html>
