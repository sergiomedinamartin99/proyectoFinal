<?php

require_once "../Conector/conexion.php";

function eliminarUsuario($idUsuario)
{
    try {
        $conexion = getConexion();
        $resultado = $conexion->prepare("DELETE FROM Usuario WHERE id = :idUsuario");
        $resultado->bindParam(":idUsuario", $idUsuario, PDO::PARAM_INT);
        $resultado->execute();
        return true;
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
    return true;
}

$idUsuario = $_POST["idUsuario"];

if (eliminarUsuario($idUsuario)) {
    echo json_encode(["status" => 1, "mensaje" => "Usuario eliminado correctamente"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "El usuario no se ha podido eliminar"]);
}
?>
