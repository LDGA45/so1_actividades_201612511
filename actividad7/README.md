# Tarea 7

**Describir las características principales y el funcionamiento del Completely Fair Scheduler (CFS) de Linux.**

## Completely Fair Scheduler (CFS) en Linux

El **Completely Fair Scheduler (CFS)** es el planificador de procesos predeterminado en el núcleo de Linux desde la versión 2.6.23, lanzada en octubre de 2007. Fue diseñado para reemplazar al antiguo planificador O(1) y mejorar la equidad y eficiencia en la asignación de tiempo de CPU a los procesos.

## **Objetivo Principal**

El objetivo del CFS es proporcionar una distribución **justa** del tiempo de CPU entre todos los procesos en ejecución. Pretende simular un procesador "ideal" que comparte su tiempo de manera equitativa entre los procesos, evitando problemas como la inanición de procesos de baja prioridad.

## **Características Principales**

### 1. Equidad en la Planificación

- **Tiempo de Ejecución Virtual (`vruntime`):** Cada proceso tiene asociado un `vruntime`, que es una medida del tiempo que el proceso ha consumido en la CPU ajustado por su prioridad. El CFS utiliza este valor para decidir qué proceso debe ejecutarse a continuación.
- **Selección Basada en `vruntime`:** El proceso con el menor `vruntime` es seleccionado para ejecutarse, asegurando que los procesos que han consumido menos tiempo de CPU tengan prioridad para equilibrar la distribución.

### 2. Estructura de Datos Eficiente

- **Árbol Rojo-Negro:** Los procesos se almacenan en un árbol rojo-negro, una estructura de datos auto-balanceada que permite operaciones eficientes de inserción, eliminación y búsqueda en tiempo O(log n).
- **Ordenación de Procesos:** Los procesos están ordenados en el árbol según su `vruntime`, lo que facilita la selección del próximo proceso a ejecutar.

### 3. Soporte para Prioridades

- **Valores "Nice":** El CFS soporta los valores "nice" de Unix para ajustar las prioridades de los procesos. Un valor "nice" más bajo significa mayor prioridad.
- **Pesos de Procesos:** Cada proceso tiene un peso calculado en función de su valor "nice", lo que afecta la tasa a la que incrementa su `vruntime`. Procesos de mayor prioridad acumulan `vruntime` más lentamente, permitiéndoles más tiempo de CPU.

### 4. Asignación Dinámica de Tiempo

- **Sin Slices Fijos:** A diferencia de planificadores anteriores, el CFS no asigna "slices" de tiempo fijos. En su lugar, calcula dinámicamente cuánto tiempo debe ejecutarse cada proceso para mantener la equidad.
- **Latencia de Planificación:** Define un período (latencia de planificación) durante el cual todos los procesos en ejecución deben tener oportunidad de ejecutarse. Este período se ajusta según el número de procesos activos.

### 5. Soporte para Sistemas Multi-Núcleo

- **Balanceo de Carga:** CFS incorpora mecanismos para distribuir los procesos equitativamente entre múltiples núcleos de CPU, optimizando el rendimiento en sistemas multi-procesador.
- **Afinidad de CPU:** Mantiene la afinidad de procesos con ciertos núcleos cuando es beneficioso para el rendimiento, minimizando el overhead de migración de procesos entre núcleos.

### 6. Control de Grupos (cgroups)

- **Planificación en Grupos:** Permite agrupar procesos y asignarles una proporción del tiempo de CPU, útil para controlar y limitar el uso de recursos en entornos compartidos.

## **Funcionamiento Detallado**

- **Cálculo de `vruntime`:**
  - El `vruntime` de un proceso incrementa a medida que consume tiempo de CPU.
  - Se ajusta por el peso del proceso: `vruntime` incrementa más lentamente para procesos de mayor prioridad.

- **Selección del Proceso a Ejecutar:**
  - El planificador selecciona el proceso con el menor `vruntime` del árbol rojo-negro.
  - Esto garantiza que los procesos que han tenido menos tiempo de CPU sean programados antes, promoviendo la equidad.

- **Actualización del Árbol:**
  - Cuando un proceso es seleccionado o deja de ejecutarse, el árbol rojo-negro se actualiza para reflejar los cambios en `vruntime`.
  - Las operaciones en el árbol son eficientes, asegurando que la sobrecarga del planificador sea mínima.

## **Ventajas del CFS**

- **Equidad Mejorada:** Proporciona una distribución más justa del tiempo de CPU, evitando la inanición de procesos.
- **Eficiencia:** La utilización de estructuras de datos eficientes y algoritmos optimizados reduce la sobrecarga del sistema.
- **Flexibilidad:** Soporta ajustes dinámicos y priorización de procesos según las necesidades del sistema.
- **Escalabilidad:** Funciona eficazmente en sistemas con gran cantidad de procesos y en arquitecturas multi-núcleo.

## **Consideraciones Adicionales**

- **Interactividad:** El CFS está diseñado para responder bien en sistemas de escritorio, manteniendo la interactividad incluso bajo carga.
- **Personalización:** Permite ajustes a través de parámetros del kernel para adaptar el comportamiento del planificador a diferentes escenarios.

## **Conclusión**

El Completely Fair Scheduler es un componente crucial del núcleo Linux que mejora la gestión de procesos mediante una planificación equitativa y eficiente. Su diseño innovador y características avanzadas permiten un rendimiento óptimo en una amplia gama de aplicaciones y entornos, desde servidores de alta carga hasta sistemas de escritorio y dispositivos embebidos.
