<?php

require_once "../Conector/conexion.php";

function bloquearUsuario($idUsuario) {
    try {
        $conexion = getConexion();
        $resultado = $conexion->prepare("SELECT correo FROM Usuario WHERE id = :idUsuario");
        $resultado->bindParam(":idUsuario", $idUsuario);
        $resultado->execute();
        $correo = $resultado->fetchColumn();
        
        $resultado = $conexion->prepare("INSERT INTO CuentasBloqueadas (correo) VALUES (:correo)");
        $resultado->bindParam(":correo", $correo);
        $resultado->execute();

        /*$resultado = $conexion->prepare("DELETE FROM Usuario WHERE id = :idUsuario");
        $resultado->bindParam(":idUsuario", $idUsuario, PDO::PARAM_INT);
        $resultado->execute();

        if ($resultado->rowCount() > 0) {
            return true;
        } else {
            return false;
        }*/
    } catch (Exception $ex) {
        return 0;
        error_log("Error al eliminar el perfil del usuario: " . $ex->getMessage());
        exit;
    } finally {
        $conexion = null;
    }
    return true;
}
$idUsuario = $_GET["idUsuario"];
bloquearUsuario($idUsuario)

/*if (isset($_GET["idUsuario"])) {
    
    if (bloquearUsuario($idUsuario)) {
        echo json_encode(["status" => 1, "mensaje" => "Usuario eliminado correctamente"]);
    } else {
        echo json_encode(["status" => 0, "mensaje" => "El usuario no se ha podido eliminar"]);
    }
} else {
    echo json_encode(["status" => 0, "mensaje" => "ID de usuario inválido"]);
}*/
?>
