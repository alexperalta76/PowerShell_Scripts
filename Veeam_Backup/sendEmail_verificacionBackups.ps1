########################################################################
## Script de PowerShell para validar los ficheros de backups de las maquinas virtuales generados 
## por Veeam Backup
## 
## Autor: Alejandro del Pozo Peralta
## Fecha: 4 de noviembre de 2015
##
## Material bajo licencia Creative Commons Reconocimiento-NoComercial-CompartirIgual 4.0
## 
## “Script PowerSherll para la notificación via email de la validación de las copias de seguridad 
## creadas por Veeam Backup is licensed under a Creative Commons 
## Reconocimiento-NoComercial-CompartirIgual 4.0 Internacional License”
## 
## License – http://creativecommons.org/licenses/by-nc-sa/4.0/
##############################################################################
## Constantes y variables
# Maquinas virtuales
$virtualMachines = “1”,”2?, “3”, “4”
$directorioDestino = “H:\FicherosValidacionBackups\”
$Fecha = Get-Date -Format d
## Generacion de los ficheros de validacion 
foreach ($element in $virtualMachines) {
    $parameter1 = ‘/backup:”‘ + $element + ‘”‘
    $parameter2 = ‘ /vmname:”‘ + $element + ‘”‘
    $parameter3 = ‘ /report:”‘ + $directorioDestino + $element + ‘.html”‘
    $parameter4 = ‘ /format:html’
    $parameter5 = ‘ /silence’
    $parameters = $parameter1 + $parameter2 + $parameter3 + $parameter4 + $parameter5
    Start-Process -Wait -FilePath “C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.Validator.exe” -ArgumentList $parameters
}
## Enviamos un email por cada backup generado 
# Parametros envio
$EmailFrom = “veeam@kk.es”
$EmailTo = “veeam@kk.es”
$SMTPServer = “mx1.kk.es”
$SMTPClient = New-Object net.mail.SmtpClient($SMTPServer)

foreach ($element in $virtualMachines) {
    $Subject =”Verificación del backup de ” + $element + ” – ” + $Fecha
    $File = $directorioDestino + $element + “.html”
    $Body = Get-Content $File
    
    $message = New-Object Net.Mail.MailMessage ($EmailFrom, $EmailTo, $Subject, $Body)
    $message.IsBodyHtml = $true
    
    $SMTPClient.send($message)
}