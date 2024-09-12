# actividad 6 
## EJERCICIO 1

```
#include <stdio.h>
#include <unistd.h>

int main() {
    fork();  // Crea un nuevo proceso
    fork();  // Crea otro nuevo proceso
    fork();  // Crea un tercer nuevo proceso
    printf("Proceso: %d\n", getpid());
    return 0;
}

```
**Análisis del código:**

Primer fork(): Cuando se ejecuta, crea un proceso hijo. Ahora tenemos dos procesos: el proceso original (padre) y el nuevo proceso (hijo).

Segundo fork(): Cada uno de los procesos existentes (el padre y el hijo) ejecuta este fork(), lo que significa que cada uno crea un nuevo proceso. En este punto, tenemos 4 procesos en total.

Tercer fork(): Cada uno de los 4 procesos ejecuta este fork(), creando 4 nuevos procesos, lo que da un total de 8 procesos.

**Resumen:**
El primer fork() duplica el número de procesos de 1 a 2.
El segundo fork() duplica el número de procesos de 2 a 4.
El tercer fork() duplica el número de procesos de 4 a 8.
En total, se crean 7 nuevos procesos (además del proceso original).

**Ejecución:**
Si ejecutamos este programa en un sistema Linux, se veran 8 líneas de salida con el mensaje "Proceso: [PID]" donde [PID] es el identificador del proceso correspondiente.

**Conclusión:**
Incluyendo el proceso inicial, se crean 8 procesos en total.

## EJERCICIO 2

```
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();  // Crear un proceso hijo

    if (pid < 0) {
        // Si la llamada a fork() falla
        perror("Fork falló");
        exit(1);
    } else if (pid == 0) {
        // Este es el proceso hijo
        printf("Proceso hijo creado (PID: %d)\n", getpid());
        exit(0);  // El proceso hijo termina inmediatamente
    } else {
        // Este es el proceso padre
        printf("Proceso padre (PID: %d), el hijo es (PID: %d)\n", getpid(), pid);

        // El proceso padre duerme durante 60 segundos, lo que permite que el proceso hijo
        // se quede en estado zombie ya que el padre no ha llamado a wait().
        sleep(60);

        // Ahora el padre recoge el estado del hijo, eliminando el proceso zombie
        wait(NULL);
        printf("Proceso hijo con PID %d ha sido recolectado.\n", pid);
    }

    return 0;
}

```
**Explicación del Código:**
fork(): Crea un nuevo proceso hijo.

Si fork() devuelve 0, estamos en el proceso hijo.
Si fork() devuelve un valor mayor que 0, estamos en el proceso padre y el valor devuelto es el PID del proceso hijo.

Proceso hijo:

El proceso hijo simplemente imprime su PID y luego llama a exit(0);, lo que significa que termina inmediatamente.
Proceso padre:

El proceso padre imprime su propio PID y el del hijo. Luego, el padre llama a sleep(60); lo que hace que duerma durante 60 segundos sin llamar a wait(). Durante este tiempo, el proceso hijo estará en estado zombie porque el padre aún no ha leído su estado de salida.
Después de los 60 segundos, el proceso padre finalmente llama a wait(NULL);, lo que recoge el estado del proceso hijo y permite que el sistema elimine el proceso zombie.

**SALIDA**
```
Proceso padre (PID: 1234), el hijo es (PID: 1235)
Proceso hijo creado (PID: 1235)
# Aquí puedes verificar el proceso zombie en otro terminal usando 'ps -l'
Proceso hijo con PID 1235 ha sido recolectado.

```
## EJERCICIO 3

```
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

void* hilo_func(void* arg) {
    printf("Hilo creado en el proceso con PID: %d\n", getpid());
    return NULL;
}

int main() {
    pthread_t hilo;

    // Crear el primer proceso hijo
    pid_t pid1 = fork();

    if (pid1 == 0) {
        // Este es el primer proceso hijo
        printf("Primer proceso hijo creado (PID: %d)\n", getpid());
        pthread_create(&hilo, NULL, hilo_func, NULL);
        pthread_join(hilo, NULL);  // Esperar a que termine el hilo
    } else {
        // Crear el segundo proceso hijo
        pid_t pid2 = fork();

        if (pid2 == 0) {
            // Este es el segundo proceso hijo
            printf("Segundo proceso hijo creado (PID: %d)\n", getpid());
            pthread_create(&hilo, NULL, hilo_func, NULL);
            pthread_join(hilo, NULL);  // Esperar a que termine el hilo
        } else {
            // Este es el proceso padre
            printf("Proceso padre (PID: %d)\n", getpid());

            // Esperar a que terminen ambos hijos
            wait(NULL);
            wait(NULL);
        }
    }

    return 0;
}

```
**Explicación del Código:**
Proceso padre: Este es el proceso principal que ejecuta el programa.
fork():
Se ejecutan dos llamadas a fork(), lo que crea dos procesos hijos (cada llamada a fork() crea un nuevo proceso).
El primer fork() crea el primer proceso hijo.
El segundo fork() crea el segundo proceso hijo.
Hilos: Dentro de cada proceso hijo, se crea un hilo utilizando la función pthread_create().
Cada proceso hijo crea un único hilo y espera a que este hilo termine antes de continuar, usando pthread_join().

Cantidad de Procesos y Hilos Creados:

Procesos únicos:
El proceso padre (PID inicial).
El primer proceso hijo creado por el primer fork().
El segundo proceso hijo creado por el segundo fork().
Total de procesos: 3 (Padre + Hijo 1 + Hijo 2).

Hilos únicos:
El proceso hijo 1 crea un hilo.
El proceso hijo 2 crea un hilo.
Total de hilos: 2 (1 por cada hijo).

Respuesta a las preguntas:

**¿Cuántos procesos únicos son creados?**

Se crean 2 nuevos procesos hijos además del proceso original. En total, tenemos 3 procesos.

**¿Cuántos hilos únicos son creados?**

Cada proceso hijo crea 1 hilo, por lo que en total se crean 2 hilos.