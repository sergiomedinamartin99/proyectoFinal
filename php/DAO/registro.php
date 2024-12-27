<?php
require_once "../Conector/conexion.php";
//session_start();

function setAniadirUsuario($correo, $contrasena, $nombre, $apellidos, $edad, $telefono, $genero, $buscandoPiso, $biografia, $ciudad) {
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $contrasenaHasheada = password_hash($contrasena, PASSWORD_DEFAULT);
            $resultado = $conexion->prepare("INSERT INTO Usuario (correo, contrasena) VALUES (:correo, :contrasena)");
            $resultado->bindParam(":correo", $correo);
            $resultado->bindParam(":contrasena", $contrasenaHasheada);
            $resultado->execute();

            $usuarioId = $conexion->lastInsertId();

            $resultado = $conexion->prepare("INSERT INTO Perfil (usuarioId, nombre, apellidos, edad, telefono, genero, buscandoPiso, biografia, ubicacion) VALUES (:usuarioId, :nombre, :apellidos, :edad, :telefono, :genero, :buscandoPiso, :biografia, :ubicacion)");
            $resultado->bindParam(":usuarioId", $usuarioId);
            $resultado->bindParam(":nombre", $nombre);
            $resultado->bindParam(":apellidos", $apellidos);
            $resultado->bindParam(":edad", $edad);
            $resultado->bindParam(":telefono", $telefono);
            $resultado->bindParam(":genero", $genero);
            $resultado->bindParam(":buscandoPiso", $buscandoPiso);
            $resultado->bindParam(":biografia", $biografia);
            $resultado->bindParam(":ubicacion", $ciudad);
            $resultado->execute();

            //$_SESSION["usuarioId"] = $usuarioId;

            return true;
        }
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
    

}


function getUsuarioPorCorreo($correo) {
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $resultado = $conexion->prepare("SELECT * FROM Usuario WHERE correo = :correo");
            $resultado->bindParam(":correo", $correo);
            $resultado->execute();
            $usuario = $resultado->fetch(PDO::FETCH_ASSOC);
            return $usuario;
        }
    } catch (Exception $ex) {
        return null;
    } finally {
        $conexion = null;
    }
}

$nombre = $_POST["nombre"];
$apellidos = $_POST["apellidos"];
$correo = $_POST["correo"];
$contrasena = $_POST["contrasena"];
$edad = $_POST["edad"];
$telefono = $_POST["telefono"];
$genero =$_POST["genero"];
$buscandoPiso = ($_POST["buscandoPiso"]) ? 1 : 0;
$ciudad = $_POST["ciudad"];
$biografia = $_POST["biografia"];

$comprobarUsuario = getUsuarioPorCorreo($correo);
if($comprobarUsuario != null){
    echo json_encode(["status" => 0, "mensaje" => "El correo ya está registrado"]);
    return;
}else{
    $usuarioRegistrado = setAniadirUsuario($correo, $contrasena, $nombre, $apellidos, $edad, $telefono, $genero, $buscandoPiso, $ciudad, $biografia);

    if ($usuarioRegistrado) {
        echo json_encode(["status" => 1, "mensaje" => "Usuario registrado"]);
    } else {
        echo json_encode(["status" => 0, "mensaje" => "Error al registrar usuario"]);
    }
}



?>