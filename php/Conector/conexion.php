<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

function getConexion() {
    try {
        $conexion = new PDO("mysql:host=localhost;dbname=ProyectoFinal", "root", "admin");
        $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $conexion->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    } catch (Exception $ex) {
        header("Location: index.php?mensajeError=Error de conexión: " . urlencode($ex->getMessage()));
        exit;
    }
    return $conexion;
}

getConexion();

?>