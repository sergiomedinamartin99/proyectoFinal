<?php
require_once "../Conector/conexion.php";
require_once 'correoMatch.php';
function setLikeDislike($idUsuario1, $idUsuario2 , $tipoIteracion) {
    try {
        $conexion = getConexion();
        if ($conexion != null) {
            if ($tipoIteracion == 1) {
                $query = "INSERT INTO Likes (usuarioOrigenId, usuarioDestinoId, tipoInteraccion) VALUES (:idUsuario1, :idUsuario2, 1)";
            } else if ($tipoIteracion == 0) {
                $query = "INSERT INTO Likes (usuarioOrigenId, usuarioDestinoId, tipoInteraccion) VALUES (:idUsuario1, :idUsuario2, 0)";

            }
            $resultado = $conexion->prepare($query);
            $resultado->bindParam(":idUsuario1", $idUsuario1);
            $resultado->bindParam(":idUsuario2", $idUsuario2);
            $resultado->execute();
            if ($tipoIteracion == 1) {
                $queryReciprocidad = "SELECT 1 FROM Likes WHERE usuarioOrigenId = :idUsuario2 AND usuarioDestinoId = :idUsuario1 AND tipoInteraccion = 1";
                $resultado = $conexion->prepare($queryReciprocidad);
                $resultado->bindParam(":idUsuario2", $idUsuario2);
                $resultado->bindParam(":idUsuario1", $idUsuario1);
                $resultado->execute();

                if ($resultado->rowCount() > 0) {

                    $queryCreateMatch = "INSERT INTO UserMatch (usuario1Id, usuario2Id) SELECT :idUsuario1, :idUsuario2 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM UserMatch 
                    WHERE (usuario1Id = :idUsuario1 AND usuario2Id = :idUsuario2) OR (usuario1Id = :idUsuario2 AND usuario2Id = :idUsuario1))";
                    $resultado = $conexion->prepare($queryCreateMatch);
                    $resultado->bindParam(":idUsuario1", $idUsuario1);
                    $resultado->bindParam(":idUsuario2", $idUsuario2);
                    $resultado->execute();

                    $queryEmails = "SELECT id, correo FROM Usuario WHERE id IN (:idUsuario1, :idUsuario2)";
                    $resultado = $conexion->prepare($queryEmails);
                    $resultado->bindParam(":idUsuario1", $idUsuario1);
                    $resultado->bindParam(":idUsuario2", $idUsuario2);
                    $resultado->execute();
                    $emails = $resultado->fetchAll(PDO::FETCH_ASSOC);
                    $destinatarios = [];
                    foreach ($emails as $row) {
                        $destinatarios[] = $row['correo'];
                    }
                    if(count($destinatarios) == 2){

                        $resultado =  enviarCorreoMatch($destinatarios[0], $destinatarios[1]);
                        
                        if ($resultado["status"] == 1) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
    } catch (Exception $ex) {
        return false;
    } finally {
        $conexion = null;
    }
}

$idUsuario1 = $_POST['idUsuario1'];
$idUsuario2 = $_POST['idUsuario2'];
$tipoIteracion = $_POST['tipoIteracion'];

if (setLikeDislike($idUsuario1, $idUsuario2, $tipoIteracion)) {
    echo json_encode(["status" => 1, "mensaje" => "Like/Dislike/Match añadido correctamente"]);
} else {
    echo json_encode(["status" => 0, "mensaje" => "Error al añadir Like/Dislike"]);
}
