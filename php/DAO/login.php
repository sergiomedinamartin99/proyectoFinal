<?php

require_once "../Conector/conexion.php";

function getComprobarUsuario($correo) {
    $usuario = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $resultado = $conexion->prepare("SELECT id, contrasena, esAdministrador FROM Usuario WHERE correo=:correo");
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

$correo = $_POST['correo'];
$contrasena = $_POST['contrasena'];



$existeUsuario = getComprobarUsuario($correo);
if ($existeUsuario) {
    if (password_verify($contrasena, $existeUsuario["contrasena"])) {
        echo json_encode(["status" => 1, "mensaje" => "Usuario logeado correctamente", "usuarioId" => $existeUsuario["id"], "admin" => $existeUsuario["esAdministrador"]]);
    } else {
        echo json_encode(["status" => 0, "mensaje" => "Error en el correo electrónico y/o en la contraseña"]);
    }
} else {
    echo json_encode(["status" => 0, "mensaje" => "Usuario no encontrado"]);
}