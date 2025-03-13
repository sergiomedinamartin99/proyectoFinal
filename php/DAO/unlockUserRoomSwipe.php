<?php

require_once "../Conector/conexion.php";

function desbloquearUsuario($idUsuario)
{
    try {
        $conexion = getConexion();
        $resultado = $conexion->prepare("DELETE FROM CuentasBloqueadas WHERE id = :idCuentaBloqueada");
        $resultado->bindParam(":idCuentaBloqueada", $idUsuario);
        $resultado->execute();
        return true;
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
}

$idUsuario = $_POST["idUsuario"];

if (desbloquearUsuario($idUsuario)) {
    echo json_encode(["status" => 1, "mensaje" => "Usuario desbloqueado correctamente"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "El usuario no se ha podido desbloquear"]);
}
?>