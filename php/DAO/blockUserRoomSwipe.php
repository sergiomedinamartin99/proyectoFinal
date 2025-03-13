<?php

require_once "../Conector/conexion.php";

function bloquearUsuario($idUsuario) {
    try {
        $conexion = getConexion();
        $resultado = $conexion->prepare("SELECT correo FROM Usuario WHERE id = :idUsuario");
        $resultado->bindParam(":idUsuario", $idUsuario);
        $resultado->execute();
        $correo = $resultado->fetchColumn();
        
        $resultado = $conexion->prepare("INSERT INTO CuentasBloqueadas (correo, motivoBloqueo) VALUES (:correo, 'UwU')");
        $resultado->bindParam(":correo", $correo);
        $resultado->execute();

        $resultado = $conexion->prepare("DELETE FROM Usuario WHERE id = :idUsuario");
        $resultado->bindParam(":idUsuario", $idUsuario);
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

if (bloquearUsuario($idUsuario)) {
    echo json_encode(["status" => 1, "mensaje" => "Usuario bloqueado correctamente"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "El usuario no se ha podido bloquear"]);
}
?>
