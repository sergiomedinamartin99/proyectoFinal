<?php

require_once "../Conector/conexion.php";

function getPerfilUsuario() {
    $usuario = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $lista = array();
            $resultado = $conexion->prepare("SELECT u.id, p.nombre, p.apellidos, u.correo FROM usuario u, perfil p WHERE u.id = p.id");
            $resultado->execute();
            $usuarios = $resultado->fetchAll();
            return $usuarios;
        }
    } catch (Exception $ex) {
        return 0;
        error_log("Error al obtener el perfil del usuario: " . $ex->getMessage());
        exit;
    } finally {
        $conexion = null;
    }
    return $usuario;
}

$usuarios = getPerfilUsuario();
if ($usuarios) {
    echo json_encode(["status" => 1, "usuarios" => $usuarios]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "No existen usuarios"]);
}