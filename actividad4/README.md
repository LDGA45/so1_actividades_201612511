# Instrucciones para crear un servicio `systemd` que ejecuta un script infinitamente

Este documento describe los pasos para crear un servicio `systemd` que ejecuta un script que imprime un saludo y la fecha actual infinitamente con una pausa de un segundo, y habilitarlo para que se inicie automáticamente con el sistema.

## Paso 1: Crear el script

Primero, crea un script que realice la tarea deseada. Por ejemplo, crea un archivo llamado `saludo.sh` en `/usr/local/bin/`:

``` bash
sudo nano /usr/local/bin/saludo.sh

```

Agrega el siguiente contenido al archivo:
```
while true; do
    echo "Hola, la fecha y hora actual es: $(date)"
    sleep 1
done
```

## Paso 2: Hacer el script ejecutable

```
sudo chmod +x /usr/local/bin/saludo.sh
```

## Paso 3: Crear el archivo de servicio systemd

Crear un archivo de unidad para systemd.

```
sudo nano /etc/systemd/system/saludo.service
```

Agregar lo siguiente en el archivo:
```
[Unit]
Description=Script que imprime un saludo y la fecha actual infinitamente

[Service]
ExecStart=/usr/local/bin/saludo.sh
Restart=always
User=root
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

## Paso 4: Recargar los servicios de systemd

`sudo systemctl daemon-reload`

## Paso 5: Iniciar y habilitar el servicio

Inicia el servicio por primera vez
`sudo systemctl start saludo.service`

Habilitar el servicio para que inicie con el sistema
`sudo systemctl enable saludo.service`

## Paso 6: Verificar que el servicio esté corriendo
`sudo systemctl status saludo.service`

## Paso 7: Ver los logs del servicio
Ver los log en tiempo REAL
`sudo journalctl -u saludo.service -f`

Ver los log historicos
`sudo journalctl -u saludo.service`


