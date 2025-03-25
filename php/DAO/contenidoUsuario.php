<?php

require_once "../Conector/conexion.php";

function getPerfilUsuario($idUsuario) {
    $usuario = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $resultado = $conexion->prepare("SELECT * FROM Perfil WHERE usuarioId=:id");
            $resultado->bindParam(":id", $idUsuario);
            $resultado->execute();
            $usuario = $resultado->fetch();

            if ($usuario["buscandoPiso"]) {
                $stmtBuscador = $conexion->prepare("SELECT ocupacion, biografia FROM buscador WHERE perfilId = :perfilId");
                $stmtBuscador->bindParam(":perfilId", $usuario['usuarioId']);
                $stmtBuscador->execute();
                $datosBuscador = $stmtBuscador->fetch();
                $perfilCompleto = $usuario + $datosBuscador;
            } else {
                $stmtPropietario = $conexion->prepare("SELECT precio, descripcionVivienda FROM propietario WHERE perfilId = :perfilId");
                $stmtPropietario->bindParam(":perfilId", $usuario['usuarioId']);
                $stmtPropietario->execute();
                $datosPropietario = $stmtPropietario->fetch();
                $perfilCompleto = $usuario + $datosPropietario;
            }

            return $perfilCompleto;
        }
    } catch (Exception $ex) {
        return false;
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