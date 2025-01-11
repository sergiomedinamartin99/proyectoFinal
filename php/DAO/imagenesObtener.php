<?php

require_once "../Conector/conexion.php";

function getPerfilUsuario($idUsuario) {
    $imagenes = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $lista = array();
            $resultado = $conexion->prepare("SELECT * FROM Imagenes WHERE perfilId=:id");
            $resultado->bindParam(":id", $idUsuario);
            $resultado->execute();
            while ($row = $resultado->fetch(PDO::FETCH_ASSOC)) {
                $lista[] = $row;
            }
            return $lista;
        }
    } catch (Exception $ex) {
        return 0;
        error_log("Error al obtener el perfil del usuario: " . $ex->getMessage());
        exit;
    } finally {
        $conexion = null;
    }
    return $imagenes;
}

$idUsuario = 1;
$imagenesRecuperadas = getPerfilUsuario($idUsuario);
if ($imagenesRecuperadas) {
    echo json_encode(["status" => 1, "imagenes" => $imagenesRecuperadas]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "Usuario sin perfil"]);
}