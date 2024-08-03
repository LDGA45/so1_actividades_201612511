# Actividad
Detalles
Objetivo: Familiarizar a los estudiantes con la administración de usuarios, grupos y permisos en un sistema operativo Linux.
Requisitos previos: Tener instalado un sistema Linux y acceso al terminal.
Envio: Enviar Link al folder actividad3 de su repositorio de GitHub
Instrucciones
Crear un md file y resolver cada uno de los items solicitados a continución. Debe de colocar el comando utilizado asi como el resultado si este fuera necesario. 

Parte 1: Gestión de Usuarios
1. Creación de Usuarios: Crea tres usuarios llamados `usuario1`, `usuario2` y `usuario3`.

2. Asignación de Contraseñas: Establece una nueva contraseñas para cada usuario creado.

3. Información de Usuarios: Muestra la información de `usuario1` usando el comando `id`.

4. Eliminación de Usuarios: Elimina `usuario3`, pero conserva su directorio principal.

Parte 2: Gestión de Grupos
1. Creación de Grupos: Crea dos grupos llamados `grupo1` y `grupo2`.

2. Agregar Usuarios a Grupos: Agrega `usuario1` a `grupo1` y `usuario2` a `grupo2`.

3. Verificar Membresía: Verifica que los usuarios han sido agregados a los grupos utilizando el comando `groups`.

4. Eliminar Grupo: Elimina `grupo2`.

Parte 3: Gestión de Permisos
1. Creación de Archivos y Directorios:

Como `usuario1`, crea un archivo llamado `archivo1.txt` en su directorio principal y escribe algo en él.
Crea un directorio llamado `directorio1` y dentro de ese directorio, un archivo llamado `archivo2.txt`.
2. Verificar Permisos: Verifica los permisos del archivo y directorio usando el comando `ls -l` y `ls -ld` respectivamente.

3. Modificar Permisos usando `chmod` con Modo Numérico: Cambia los permisos del `archivo1.txt` para que sólo `usuario1` pueda leer y escribir (permisos `rw-`), el grupo pueda leer (permisos `r--`) y nadie más pueda hacer nada.

4. Modificar Permisos usando `chmod` con Modo Simbólico: Agrega permiso de ejecución al propietario del `archivo2.txt`.

5. Cambiar el Grupo Propietario: Cambia el grupo propietario de `archivo2.txt` a `grupo1`.

6. Configurar Permisos de Directorio: Cambia los permisos del `directorio1` para que sólo el propietario pueda entrar (permisos `rwx`), el grupo pueda listar contenidos pero no entrar (permisos `r--`), y otros no puedan hacer nada.

7. Comprobación de Acceso: Intenta acceder al `archivo1.txt` y `directorio1/archivo2.txt` como `usuario2`. Nota cómo el permiso de directorio afecta el acceso a los archivos dentro de él.

8. Verificación Final: Verifica los permisos y propietario de los archivos y directorio nuevamente con `ls -l` y `ls -ld`.

Reflexión: (Opcional)
Contestar las siguientes preguntas:

¿Por qué es importante gestionar correctamente los usuarios y permisos en un sistema operativo?
¿Qué otros comandos o técnicas conocen para gestionar permisos en Linux?

----------------------------------------------------
# Solucion 

## Codigo en consola

```
#!/bin/bash

# Parte 1: Gestión de Usuarios

# 1. Creación de Usuarios
sudo adduser --disabled-password --gecos "" usuario1
sudo adduser --disabled-password --gecos "" usuario2
sudo adduser --disabled-password --gecos "" usuario3

# 2. Asignación de Contraseñas
echo "usuario1:password1" | sudo chpasswd
echo "usuario2:password2" | sudo chpasswd
echo "usuario3:password3" | sudo chpasswd

# 3. Información de Usuarios
id usuario1

# 4. Eliminación de Usuarios pero conservando su directorio principal
sudo deluser usuario3 --backup --backup-to /home/backup

# Parte 2: Gestión de Grupos

# 1. Creación de Grupos
sudo addgroup grupo1
sudo addgroup grupo2

# 2. Agregar Usuarios a Grupos
sudo usermod -aG grupo1 usuario1
sudo usermod -aG grupo2 usuario2

# 3. Verificar Membresía
groups usuario1
groups usuario2

# Parte 3: Gestión de Permisos

# 1. Creación de Archivos y Directorios como usuario1
sudo -u usuario1 bash << EOF
touch /home/usuario1/archivo1.txt
echo "Contenido de archivo1.txt" > /home/usuario1/archivo1.txt
mkdir /home/usuario1/directorio1
touch /home/usuario1/directorio1/archivo2.txt
EOF

# 2. Verificar Permisos
ls -l /home/usuario1/archivo1.txt
ls -ld /home/usuario1/directorio1

# 3. Modificar Permisos usando chmod con Modo Numérico
chmod 644 /home/usuario1/archivo1.txt

# 4. Modificar Permisos usando chmod con Modo Simbólico
chmod u+x /home/usuario1/directorio1/archivo2.txt

# 5. Cambiar el Grupo Propietario
chown :grupo1 /home/usuario1/directorio1/archivo2.txt

# 6. Configurar Permisos de Directorio
chmod 744 /home/usuario1/directorio1

# 7. Comprobación de Acceso como usuario2
sudo -u usuario2 bash << EOF
echo "Intentando acceder a /home/usuario1/archivo1.txt:"
cat /home/usuario1/archivo1.txt || echo "Acceso denegado"
echo "Intentando acceder a /home/usuario1/directorio1/archivo2.txt:"
cat /home/usuario1/directorio1/archivo2.txt || echo "Acceso denegado"
EOF

# 8. Verificación Final
ls -l /home/usuario1/archivo1.txt
ls -l /home/usuario1/directorio1/archivo2.txt
ls -ld /home/usuario1/directorio1

# Mensaje final
echo "Todas las tareas han sido completadas exitosamente."


```

--------------------------------------------------------

## Refelxion
**¿Por qué es importante gestionar correctamente los usuarios y permisos en un sistema operativo?**
Seguridad: La correcta gestión de usuarios y permisos es esencial para la seguridad del sistema. Permite controlar quién tiene acceso a qué recursos, previniendo accesos no autorizados que podrían comprometer la integridad y confidencialidad de los datos.

Protección de Datos: Al restringir los permisos, se asegura que solo las personas autorizadas puedan modificar o visualizar datos sensibles. Esto es crucial en entornos empresariales y personales para proteger información confidencial.

Estabilidad del Sistema: Un buen manejo de permisos ayuda a prevenir cambios accidentales en archivos o configuraciones críticas del sistema, lo cual podría llevar a fallos en el sistema operativo o en aplicaciones importantes.

Cumplimiento Normativo: Muchas industrias están sujetas a regulaciones que requieren un control estricto sobre el acceso a datos y recursos. La correcta gestión de usuarios y permisos ayuda a cumplir con estas regulaciones.

Productividad: Al definir roles y permisos claramente, los usuarios pueden trabajar de manera más eficiente sin tener que solicitar acceso constantemente, y los administradores pueden gestionar el sistema de forma más efectiva.

**¿Qué otros comandos o técnicas conocen para gestionar permisos en Linux?**
chmod: Cambia los permisos de archivos y directorios. Se puede usar con modos simbólicos (chmod u+x archivo) o numéricos (chmod 755 archivo).

chown: Cambia el propietario y/o el grupo de un archivo o directorio (chown usuario:grupo archivo).

chgrp: Cambia el grupo propietario de un archivo o directorio (chgrp grupo archivo).

umask: Establece permisos predeterminados para nuevos archivos y directorios. Se puede usar para definir los permisos que no se otorgarán automáticamente a nuevos archivos y directorios (umask 022).

setfacl y getfacl: Administran las listas de control de acceso (ACL) para archivos y directorios, proporcionando un control más granular sobre los permisos (setfacl -m u:usuario:rwx archivo).

sudoers: Configura permisos y privilegios elevados a través del archivo /etc/sudoers. Esto permite definir qué comandos pueden ejecutar los usuarios con privilegios de superusuario (sudo visudo).

find: Con el comando find combinado con -exec, se pueden cambiar permisos de forma masiva en una estructura de directorios (find /ruta -type f -exec chmod 644 {} \;).

sticky bit: Un permiso especial que se puede establecer en directorios para que solo el propietario de un archivo dentro del directorio pueda eliminar o renombrar el archivo (chmod +t /directorio).

suid y sgid: Permisos especiales que permiten que un archivo se ejecute con los permisos del propietario (suid) o del grupo (sgid) en lugar del usuario que lo ejecuta (chmod u+s archivo para suid y chmod g+s archivo para sgid).