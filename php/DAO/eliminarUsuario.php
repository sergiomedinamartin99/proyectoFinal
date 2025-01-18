<?php

require_once "../Conector/conexion.php";

function eliminarUsuario($idUsuario)
{
    try {
        $conexion = getConexion();
        $resultado = $conexion->prepare("DELETE FROM Usuario WHERE id = :idUsuario");
        $resultado->bindParam(":idUsuario", $idUsuario, PDO::PARAM_INT);
        $resultado->execute();

        if ($resultado->rowCount() > 0) {
            return true;
        } else {
            return false;
        }
    } catch (Exception $ex) {
        return 0;
        error_log("Error al eliminar el perfil del usuario: " . $ex->getMessage());
        exit;
    } finally {
        $conexion = null;
    }
    return true;
}

if (isset($_POST["idUsuario"])) {
    $idUsuario = $_POST["idUsuario"];

    if (eliminarUsuario($idUsuario)) {
        echo json_encode(["status" => 1, "mensaje" => "Usuario eliminado correctamente"]);
    } else {
        echo json_encode(["status" => 0, "mensaje" => "El usuario no se ha podido eliminar"]);
    }
} else {
    echo json_encode(["status" => 0, "mensaje" => "ID de usuario inválido"]);
}
?>
