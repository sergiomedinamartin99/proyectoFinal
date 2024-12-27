<?php

require_once "../Conector/conexion.php";
//session_start();

function getComprobarUsuario($correo) {
    $usuario = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $resultado = $conexion->prepare("SELECT id, contrasena FROM Usuario WHERE correo=:correo");
            $resultado->bindParam(":correo", $correo);
            $resultado->execute();
            $usuario = $resultado->fetch();
            return $usuario;
        }
    } catch (Exception $ex) {
        return 0;
        error_log("Error al comprobar usuario: " . $ex->getMessage());
        exit;
    } finally {
        $conexion = null;
    }
    return $usuario;
}

$correo = filter_var($_POST['correo'], FILTER_VALIDATE_EMAIL);
$contrasena = htmlspecialchars($_POST['contrasena'], ENT_QUOTES, 'UTF-8');


$existeUsuario = getComprobarUsuario($correo);
if ($existeUsuario) {
    if (password_verify($contrasena, $existeUsuario["contrasena"])) {
        //$_SESSION["idUsuario"] = $existeUsuario["id"];
        echo json_encode(["status" => 1, "mensaje" => "Usuario encontrado"]);
    } else {
        echo json_encode(["status" => 0, "mensaje" => "Usuario no encontrado"]);
    }
} else {
    echo json_encode(["status" => 0, "mensaje" => "Usuario no encontrado"]);
}