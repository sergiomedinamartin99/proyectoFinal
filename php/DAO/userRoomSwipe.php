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
                    // Si buscandoPiso es true (1)
                    if ($fila['buscandoPiso'] === 1) {
                        $usuarios[$id] = [
                            "id" => $fila['id'],
                            "nombre" => $fila['nombre'],
                            "apellidos" => $fila['apellidos'],
                            "fechaNacimiento" => $fila['fecha_nacimiento'],
                            "genero" => $fila['genero'],
                            "ubicacion" => $fila['ubicacion'],
                            "ocupacion" => $fila['ocupacion'], 
                            "biografia" => $fila['biografia'],
                            "imagenes" => []
                        ];
                    } else {
                        // Si buscandoPiso es false
                        $usuarios[$id] = [
                            "id" => $fila['id'],
                            "nombre" => $fila['nombre'],
                            "apellidos" => $fila['apellidos'],
                            "fechaNacimiento" => $fila['fecha_nacimiento'],
                            "genero" => $fila['genero'],
                            "ubicacion" => $fila['ubicacion'],
                            "precio" => $fila['precio'],
                            "descripcionVivienda" => $fila['descripcionVivienda'],
                            "imagenes" => []
                        ];
                    }
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
        error_log("Error al obtener el perfil del usuario: " . $e->getMessage());
        return 0;
        exit;
    } finally {
        $conexion = null;
    }
}

// Se verifica que se haya enviado el idUsuario vía POST.
$idUsuario = $_POST['idUsuario'];
$usuarios = getSwipe($idUsuario);

if ($usuarios) {
    echo json_encode(["status" => 1, "perfil" => $usuarios]);
} else if (empty($usuarios)) {
    echo json_encode(["status" => 2, "mensaje" => "No hay más perfiles"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "Usuario sin perfil"]);   
}
?>
