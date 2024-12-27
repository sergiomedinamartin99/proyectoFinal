<?php

function getUsuarios() {
    $usuarios = null;
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $resultado = $conexion->query("SELECT * FROM Usuario;");
            $usuarios = $resultado->fetchAll();
        }
    } catch (Exception $ex) {
        // ESTA PARTE HABRIA QUE MODIFICARLE AL COMPLETO
        header("Location: index.php?mensajeError=Error en la consulta: " . urlencode($ex->getMessage()));
        exit;
    } finally {
        $conexion = null;
    }
    return $usuarios; 
}

$listado = getUsuarios();

print_r($listado);


?>