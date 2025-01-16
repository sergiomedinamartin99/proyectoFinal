<?php
require_once "../Conector/conexion.php";

function insertarOActualizarImagenes($perfilId, $imagenes)
{
    try {
        $conexion = getConexion();

        $posicionesRecibidas = array_keys($imagenes['tmp_name']);  
  
        if (!empty($posicionesRecibidas)) {
            $placeholders = rtrim(str_repeat('?,', count($posicionesRecibidas)), ','); 
            $sqlDelete = "
                DELETE FROM Imagenes
                WHERE perfilId = ?
                  AND posicionImagen NOT IN ($placeholders)
            ";
            $stmtDelete = $conexion->prepare($sqlDelete);

            $bindArray = array_merge([$perfilId], $posicionesRecibidas);

            $stmtDelete->execute($bindArray);
        } 
        
        foreach ($imagenes['tmp_name'] as $index => $tmpName) {
            $nombreImagen = $imagenes['name'][$index];
            $tipoImagen   = $imagenes['type'][$index];
            $dataImagen   = base64_encode(file_get_contents($tmpName));

            $consultaExistente = $conexion->prepare("
                SELECT id 
                FROM Imagenes 
                WHERE perfilId = :perfilId 
                  AND posicionImagen = :posicionImagen
            ");
            $consultaExistente->bindParam(":perfilId", $perfilId);
            $consultaExistente->bindParam(":posicionImagen", $index);
            $consultaExistente->execute();

            if ($consultaExistente->rowCount() > 0) {
                $resultadoUpdate = $conexion->prepare("
                    UPDATE Imagenes
                    SET nombre = :nombre,
                        tipo   = :tipo,
                        datos  = :datos
                    WHERE perfilId = :perfilId
                      AND posicionImagen = :posicionImagen
                ");
                $resultadoUpdate->bindParam(":nombre", $nombreImagen);
                $resultadoUpdate->bindParam(":tipo", $tipoImagen);
                $resultadoUpdate->bindParam(":datos", $dataImagen);
                $resultadoUpdate->bindParam(":perfilId", $perfilId);
                $resultadoUpdate->bindParam(":posicionImagen", $index);
                $resultadoUpdate->execute();

            } else {
                $resultadoInsert = $conexion->prepare("
                    INSERT INTO Imagenes (perfilId, posicionImagen, nombre, tipo, datos) 
                    VALUES (:perfilId, :posicionImagen, :nombre, :tipo, :datos)
                ");
                $resultadoInsert->bindParam(":perfilId", $perfilId);
                $resultadoInsert->bindParam(":posicionImagen", $index);
                $resultadoInsert->bindParam(":nombre", $nombreImagen);
                $resultadoInsert->bindParam(":tipo", $tipoImagen);
                $resultadoInsert->bindParam(":datos", $dataImagen);
                $resultadoInsert->execute();
            }
        }

        return true;
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
}

if (isset($_FILES['imagenes'])) {
    $perfilId = $_POST['perfilId'];

    if (insertarOActualizarImagenes($perfilId, $_FILES['imagenes'])) {
        echo json_encode(["status" => 1, "mensaje" => "Imágenes subidas/actualizadas correctamente"]);
    } else {
        echo json_encode(["status" => 0, "mensaje" => "Error al subir/actualizar las imágenes"]);
    }

} else {
    echo json_encode(["status" => 0, "mensaje" => "No se recibieron imágenes"]);
}