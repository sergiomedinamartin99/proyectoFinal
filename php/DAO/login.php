<?php

require_once "../Conector/conexion.php";

function getComprobarUsuario($correo) {
    $usuario = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $resultado = $conexion->prepare("SELECT u.id, u.contrasena, u.esAdministrador, p.buscandoPiso FROM Usuario u, Perfil p WHERE correo=:correo AND u.id = p.usuarioId");
            $resultado->bindParam(":correo", $correo);
            $resultado->execute();
            $usuario = $resultado->fetch();
            return $usuario;
        }
    } catch (Exception $ex) {
        return false;
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
        echo json_encode(["status" => 1, "mensaje" => "Usuario logeado correctamente", "usuarioId" => $existeUsuario["id"], 
        "admin" => $existeUsuario["esAdministrador"] ? true : false, "buscandoPiso" => $existeUsuario["buscandoPiso"] ? true : false]);
    } else {
        echo json_encode(["status" => 0, "mensaje" => "Error en el correo electrónico y/o en la contraseña"]);
    }
} else {
    echo json_encode(["status" => 0, "mensaje" => "Usuario no encontrado"]);
}