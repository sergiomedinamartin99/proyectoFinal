<?php
require_once "../Conector/conexion.php";

function getSwipe($idUsuario) {
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $query = "CALL getPerfilesRoomSwipe(:id);";
    
    
            $stmt = $conexion->prepare($query);
            $stmt->bindParam(":id", $idUsuario);
            $stmt->execute();
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
            $usuarios = [];
    
            foreach ($resultados as $fila) {
                $id = $fila['id'];
    
                if (!isset($usuarios[$id])) {
                    $usuarios[$id] = [
                        "id" => $fila['id'],
                        "nombre" => $fila['nombre'],
                        "apellidos" => $fila['apellidos'],
                        "precio" => $fila['buscandoPiso'] === 1 ? "" : $fila['precio'],
                        "descripcionVivienda" => $fila['buscandoPiso'] === 1 ? "" : $fila['descripcionVivienda'],
                        "imagenes" => []
                    ];
                }
    
                if (!is_null($fila['posicionImagen'])) {
                    $usuarios[$id]["imagenes"][] = [
                        "posicionImagen" => $fila['posicionImagen'],
                        "nombre" => $fila['imagen_nombre'],
                        "tipo" => $fila['tipo'],
                        "datos" => $fila['datos']
                    ];
                }
            }
        }
        // Convertir a JSON y devolver la respuesta
        return $usuarios;
    
    } catch (PDOException $e) {
        return 0;
        error_log("Error al obtener el perfil del usuario: " . $ex->getMessage());
        exit;
    } finally {
        $conexion = null;
    }
}

// Se verifica que se haya enviado el idUsuario vía POST.
$idUsuario = 2;
$usuarios = getSwipe($idUsuario);

if ($usuarios) {
    echo json_encode(["status" => 1, "perfil" => $usuarios]);
} else if (empty($usuarios)) {
    echo json_encode(["status" => 2, "mensaje" => "No hay más perfiles"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "Usuario sin perfil"]);   
}
?>
