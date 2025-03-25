<?php
require_once "../Conector/conexion.php";

function insertarImagenes($perfilId, $imagenes)
{
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            foreach ($imagenes['tmp_name'] as $index => $tmpName) {
                $nombreImagen = $imagenes['name'][$index];
                $tipoImagen = $imagenes['type'][$index];
                $dataImagen = base64_encode(file_get_contents($tmpName));

                $resultado = $conexion->prepare("INSERT INTO Imagenes (perfilId, posicionImagen, nombre, tipo, datos) 
                                                 VALUES (:perfilId, :posicionImagen, :nombre, :tipo, :datos)");
                $resultado->bindParam(":perfilId", $perfilId);
                $resultado->bindParam(":posicionImagen", $index);
                $resultado->bindParam(":nombre", $nombreImagen);
                $resultado->bindParam(":tipo", $tipoImagen);
                $resultado->bindParam(":datos", $dataImagen);
                $resultado->execute();
            }
            return true;
        }
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
}

if (isset($_FILES['imagenes'])) {
    $perfilId = $_POST['perfilId'];
    if (insertarImagenes($perfilId, $_FILES['imagenes'])) {
        echo json_encode(["status" => 1, "mensaje" => "Imágenes subidas correctamente"]);
    } else {
        echo json_encode(["status" => 0, "mensaje" => "Error al subir las imágenes"]);
    }
} else {
    echo json_encode(["status" => 0, "mensaje" => "No se recibieron imágenes"]);
}
