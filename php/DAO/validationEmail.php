<?php

require_once "../Conector/conexion.php";

function getUsuarioPorCorreo($correo) {
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $resultado = $conexion->prepare("SELECT * FROM Usuario WHERE correo = :correo");
            $resultado->bindParam(":correo", $correo);
            $resultado->execute();
            $usuario = $resultado->fetch(PDO::FETCH_ASSOC);
            if ($usuario != null) {
                return true;
            } else {
                return false;
            }
        }
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
}

$correo = $_POST["correo"];

$comprobarExistenciaCorreo = getUsuarioPorCorreo($correo);

if (!$comprobarExistenciaCorreo) {
    echo json_encode(["status" => 1, "mensaje" => "No existe el usuario."]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "Existen el usuario."]);
}

?>