<?php

require_once "../Conector/conexion.php";

function updateUsuario($idUsuario, $nombreUsuario, $apellidosUsuario, $fechaNacimientoUsuario, $telefonoUsuario, $generoUsuario, $ciudadUsuario, $buscandoPisoUsuario, $precioUsuario, $descripcionViviendaUsuario, $ocupacionUsuario, $biografiaUsuario)
{
    try {
        $conexion = getConexion();
        $resultado = $conexion->prepare("CALL actualizarPerfil(:idUsuario, :nombre, :apellidos, :fechaNacimiento, :telefono, :genero, :ciudad, :buscandoPiso, :precio, :descripcionVivienda, :ocupacion, :biografia)");
        $resultado->bindParam(":idUsuario", $idUsuario);
        $resultado->bindParam(":nombre", $nombreUsuario);
        $resultado->bindParam(":apellidos", $apellidosUsuario);
        $resultado->bindParam(":fechaNacimiento", $fechaNacimientoUsuario);
        $resultado->bindParam(":telefono", $telefonoUsuario);
        $resultado->bindParam(":genero", $generoUsuario);
        $resultado->bindParam(":ciudad", $ciudadUsuario);
        $resultado->bindParam(":buscandoPiso", $buscandoPisoUsuario);
        $resultado->bindParam(":precio", $precioUsuario);
        $resultado->bindParam(":descripcionVivienda", $descripcionViviendaUsuario);
        $resultado->bindParam(":ocupacion", $ocupacionUsuario);
        $resultado->bindParam(":biografia", $biografiaUsuario);
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
$nombreUsuario = $_POST["nombre"];
$apellidosUsuario = $_POST["apellidos"];
$fechaNacimientoUsuario = $_POST["fechaNacimiento"];
$telefonoUsuario = $_POST["telefono"];
$generoUsuario = $_POST["genero"];
$ciudadUsuario = $_POST["ciudad"];
$buscandoPisoUsuario = ($_POST["buscandoPiso"] === "true") ? 1 : 0;
$ocupacionUsuario = $_POST["ocupacion"];
$biografiaUsuario = $_POST["biografia"];
$precioUsuario = $_POST["precio"];
$descripcionViviendaUsuario = $_POST["descripcionVivienda"];

if (updateUsuario($idUsuario, $nombreUsuario, $apellidosUsuario, $fechaNacimientoUsuario, $telefonoUsuario, $generoUsuario, $ciudadUsuario, $buscandoPisoUsuario, $precioUsuario, $descripcionViviendaUsuario, $ocupacionUsuario, $biografiaUsuario)) {
    echo json_encode(["status" => 1, "mensaje" => "Usuario actualizado correctamente"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "El usuario no se ha podido actualizar"]);
}
?>