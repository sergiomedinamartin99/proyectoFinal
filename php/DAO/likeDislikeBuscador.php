<?php
require_once "../Conector/conexion.php";
function setLikeDislike($idUsuario, $idPropietario , $tipoIteracion) {
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            if ($tipoIteracion == 1) {
                $query = "INSERT INTO Likes (usuarioOrigenId, usuarioDestinoId, tipoInteraccion) VALUES (:usuarioId, :propietarioId, 1)";
            } else if ($tipoIteracion == 0) {
                $query = "INSERT INTO Likes (usuarioOrigenId, usuarioDestinoId, tipoInteraccion) VALUES (:usuarioId, :propietarioId, 0)";
            }
            $resultado = $conexion->prepare($query);
            $resultado->bindParam(":usuarioId", $idUsuario);
            $resultado->bindParam(":propietarioId", $idPropietario);
            $resultado->execute();
            return true;
        }
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
}

$idUsuario = $_POST["idUsuario"];
$idPropietario = $_POST["idPropietario"];
$tipoIteracion = $_POST["tipoIteracion"];

if (setLikeDislike($idUsuario, $idPropietario, $tipoIteracion)) {
    echo json_encode(["status" => 1, "mensaje" => "Like/Dislike añadido correctamente"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "Error al añadir Like/Dislike"]);
}
