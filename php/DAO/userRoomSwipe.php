<?php
require_once "../Conector/conexion.php";

function getSwipe($idUsuario) {
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            $query = "SELECT p.id, p.nombre, p.apellidos, p.fecha_nacimiento, p.genero, pr.precio, pr.descripcionVivienda, i.posicionImagen, i.nombre AS imagen_nombre, i.tipo, i.datos
                  FROM perfil p
                  LEFT JOIN propietario pr ON p.id = pr.perfilId
                  LEFT JOIN imagenes i ON p.id = i.perfilId
                  WHERE p.ubicacion = (SELECT ubicacion FROM perfil WHERE usuarioId = :id) 
                  AND p.buscandoPiso = 0 AND NOT EXISTS (SELECT 1 FROM Likes l WHERE l.usuarioOrigenId = :id AND l.usuarioDestinoId = p.usuarioId)
                  AND NOT EXISTS (SELECT 1 FROM UserMatch m WHERE (m.usuario1Id = :id AND m.usuario2Id = p.usuarioId) OR (m.usuario1Id = p.usuarioId AND m.usuario2Id = :id));";
    
    
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
                        "precio" => $fila['precio'] ?? null,
                        "descripcionVivienda" => $fila['descripcionVivienda'] ?? null,
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
$idUsuario = 1;
$usuarios = getSwipe($idUsuario);

if ($usuarios) {
    echo json_encode(["status" => 1, "perfil" => $usuarios]);
} else if (empty($usuarios)) {
    echo json_encode(["status" => 2, "mensaje" => "No hay más perfiles"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "Usuario sin perfil"]);   
}
?>
