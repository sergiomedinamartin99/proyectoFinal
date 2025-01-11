<?php

require_once "../Conector/conexion.php";

function getPerfilUsuario($idUsuario) {
    $usuario = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $resultado = $conexion->prepare("SELECT * FROM Imagenes WHERE usuarioId=:id");
            $resultado->bindParam(":id", $idUsuario);
            $resultado->execute();
            $usuario = $resultado->fetch();
            return $usuario;
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

$idUsuario = $_POST['idUsuario'];

$perfilUsuario = getPerfilUsuario($idUsuario);
if ($perfilUsuario) {
    echo json_encode(["status" => 1, "perfilUsuario" => $perfilUsuario]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "Usuario sin perfil"]);
}