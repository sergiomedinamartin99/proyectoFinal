<?php
// Importa las clases de PHPMailer al espacio global
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

// Carga el autoloader de Composer
require '../mail/vendor/autoload.php';

/**
 * Envía un correo de match a dos direcciones de email.
 *
 * @param string $correo1 Primer correo (por ejemplo, del usuario1)
 * @param string $correo2 Segundo correo (por ejemplo, del usuario2)
 * @return string Mensaje indicando éxito o error en el envío.
 */
function enviarCorreoMatch($correo1, $correo2) {
    // Crea una nueva instancia de PHPMailer
    $mail = new PHPMailer(true);
    
    try {
        // Configuración del servidor SMTP
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';           // Servidor SMTP de Gmail
        $mail->SMTPAuth   = true;                       // Habilita la autenticación SMTP
        $mail->Username   = 'noreplyroomswipe@gmail.com'; // Tu correo de Gmail
        $mail->Password   = 'hwbx jvfk hrzu otuf';        // Contraseña de aplicación de Gmail
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; // Usa STARTTLS
        $mail->Port       = 587;                        // Puerto SMTP de Gmail

        // Configuración del correo
        $mail->setFrom('noreplyroomswipe@gmail.com', 'RoomSwipe');
        $mail->addAddress($correo1);
        $mail->addAddress($correo2);
        $mail->Subject = '¡Has hecho match!';
        $mail->Body    = "¡Felicidades!\n\nSe ha producido un match entre $correo1 y $correo2. Ahora podéis comenzar a hablar por el correo";

        // Envía el correo
        $mail->send();
        return ["status" => 1, "mensaje" => "Emails enviados correctamente"];
    } catch (Exception $e) {
        return ["status" => 0, "mensaje" => "error: {$mail->ErrorInfo}"];
    }
}
?>
