<?php

require_once "../Conector/conexion.php";

function getPerfilUsuarioBlock() {
    $usuario = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $lista = array();
            $resultado = $conexion->prepare("SELECT id, correo, motivoBloqueo, fechaBloqueo FROM CuentasBloqueadas");
            $resultado->execute();
            $usuarios = $resultado->fetchAll();
            return $usuarios;
        }
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
    return $usuario;
}

$usuarios = getPerfilUsuarioBlock();
if ($usuarios) {
    echo json_encode(["status" => 1, "usuarios" => $usuarios]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "No existen usuarios"]);
}