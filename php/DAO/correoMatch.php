<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require '../mail/vendor/autoload.php';

function enviarCorreoMatch($correo1, $correo2) {
    $mail = new PHPMailer(true);
    
    try {
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'noreplyroomswipe@gmail.com';
        $mail->Password   = 'hwbx jvfk hrzu otuf';
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port       = 587;

        $mail->setFrom('noreplyroomswipe@gmail.com', 'RoomSwipe');
        $mail->addAddress($correo1);
        $mail->addAddress($correo2);
        $mail->Subject = '¡Has hecho match!';
        $mail->Body    = "¡Felicidades!\n\nSe ha producido un match entre $correo1 y $correo2. Ahora podéis comenzar a hablar por el correo";

        $mail->send();
        return ["status" => 1, "mensaje" => "Emails enviados correctamente"];
    } catch (Exception $e) {
        return ["status" => 0, "mensaje" => "error: {$mail->ErrorInfo}"];
    }
}
?>
