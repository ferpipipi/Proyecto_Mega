## Proyecto Mega 


### Alitzel Alba Hernández
### Cynthia Fernanda Diaz Cervantes
### Iván Dalí García Torres
### Miguel Gómez Romero

## Descripción de la funcionalidad:
La funcionalidad actual consta de una tarea principal que fue la que desarrollamos que es el calculo de la deuda del suscriptor,

## Aportaciones y distribución de roles:
A continuación, se presentan los roles que asumimos cada integrante dentro del proyecto. Es importante mencionar que, desde el primer día, trabajamos de forma colaborativa, comenzando por definir una idea inicial sobre cómo abordar el desarrollo. En nuestro caso, decidimos iniciar con la parte lógica del sistema para posteriormente avanzar hacia el diseño visual.
En un primer momento, el compañero Miguel generó una base de datos inicial como punto de partida. A partir de esta, el compañero Dalí continuó con el desarrollo de la base de datos final y también participó en la implementación de la API. A lo largo del proceso, todas las etapas contaron con la intervención de los distintos miembros del equipo, ya sea para proponer mejoras, complementar secciones o resolver problemas específicos.
Un claro ejemplo de este trabajo en conjunto fue la creación de los mockups, donde participaron Miguel, Alitzel y Cynthia. Posteriormente, Alitzel comenzó a implementar la parte del frontend para visualizar cómo se reflejaría la idea del mockup en ejecución. A partir de ahí, Miguel se encargó completamente del desarrollo del frontend en los módulos de deuda y configurador de promociones, además de colaborar en la API y los endpoints correspondientes.

### Dalí:

El proyecto MegaCable tuvo como objetivo principal el desarrollo de un sistema integral para la gestión de suscriptores y contratos, implementando una base de datos relacional en SQL Server y una API REST desarrollada en C# con .NET. Además, se utilizaron procedimientos almacenados para automatizar tareas clave relacionadas con la operación de servicios de telecomunicaciones.
La arquitectura técnica del sistema se basó en una estructura relacional sólida, apoyada por procedimientos almacenados para manejar la lógica de negocio más compleja. El backend fue desarrollado con el patrón de servicios y se integró un sistema de pruebas automatizadas utilizando scripts en PowerShell para validar los endpoints de la API.
Entre los componentes principales se encuentra la gestión de suscriptores, que incluyó distintos tipos (residencial, empresarial, gobierno, etc.), validaciones automáticas y el procedimiento sp_agregar_suscriptor_final con control de errores. La gestión de contratos permitió la creación automática de contratos con múltiples servicios y promociones, utilizando triggers para recalcular precios al aplicar o quitar descuentos, junto con el procedimiento sp_aplicar_promocion_a_contrato.
El sistema de promociones incluyó descuentos aplicables por código o ID, tanto porcentuales como fijos, con control de vigencia y uso, además de actualizaciones automáticas de precios mediante triggers. En cuanto a las funcionalidades implementadas, se logró un CRUD completo de suscriptores, gestión dinámica de servicios, aplicación y revocación automática de promociones, una API REST funcional con endpoints completos, y validación de integridad referencial entre tablas.
Finalmente, el sistema fue probado con scripts automatizados en PowerShell, diagnósticos para errores 500, datos de prueba representativos y validación de las respuestas JSON y códigos HTTP, garantizando así una solución estable y funcional.

### Miguel:

Desde la asignación del reto, proyecté la estructura general del proyecto y compartí estas ideas con el equipo, quienes las aceptaron de inmediato. Acordamos iniciar con toda la lógica del sistema y, una vez establecida, avanzar hacia el diseño visual. Con esta cronología clara, diseñé y desarrollé una base de datos inicial que compartí con mis compañeros, sirviendo de referencia para el desarrollo posterior de la lógica de negocio.

Desde el principio, propuse reuniones periódicas para dar seguimiento al avance y asignar tareas. Junto con Alitzel y Cynthia, definimos responsabilidades: yo me encargué del frontend de los módulos de Deuda y Configurador de Promociones. Durante esta fase, trabajamos de forma conjunta y supervisé constantemente los avances para asegurar una correcta integración con la interfaz. Paralelamente, estuve revisando y ajustando tanto la base de datos como el backend, con el fin de brindar apoyo en todas las áreas y acelerar el progreso del equipo.

A pesar de mis habilidades multidisciplinarias, disfruto especialmente el desarrollo frontend, pues es donde mejor me desenvuelvo y donde puedo plasmar con mayor satisfacción las ideas que concebí desde un inicio. Finalmente, asumí la responsabilidad de identificar y resolver los errores técnicos que surgieron a lo largo del proceso.

### Alitzel:

Durante el desarrollo del proyecto, me encargué de liderar la implementación de los endpoints de la API para el módulo de suscriptores y deudass, priorizando primero la lógica y luego el diseño visual. Utilicé ASP.NET Core y SQL Server para construir operaciones CRUD RESTful, para así tener una integración efectiva entre el frontend y la base de datos.
Desarrollé DTOs personalizados para mantener una estructura de datos coherentes, validar entradas y evitar sobre-posteamiento, esto con el fin de evitar las vulnerabilidades y que a su vez sea consistente. Para un correcto manejo de la base de datos utilice bloques using, consultas parametizadas y control de valores nulos.

### Cynthia:



## Descripción del proceso del proyecto:
Iniciamos el proyecto con la idea de formular primero la parte lógica, para posteriormente comenzar con el diseño.
Para ello, se creó la base de datos en SQL Server, teniendo como tabla principal Contratos, de la cual se derivan el resto de las tablas, entre ellas: Suscriptores, Tipos_Suscriptores, entre otras.
Antes de realizar la conexión de la API con el frontend, se diseñó un mockup para visualizar lo que se mostraría al usuario. En este se crearon tres interacciones: la pantalla de inicio con las opciones para consultar la deuda y configurar promociones. Al seleccionar cualquiera de estas opciones desde la barra de navegación, se redirige al espacio correspondiente, y de igual forma es posible regresar al inicio para cambiar de opción.
Se crearon los endpoints necesarios para realizar la conexión con el frontend, tales como los de suscriptores, deuda y promociones.
Con los endpoints y la API listos, se comenzó a establecer la conexión con el frontend. Además de la interacción con la barra de navegación, ya es posible realizar las consultas necesarias.
En el apartado de deuda, se muestra una pantalla donde el usuario puede ingresar un ID para consultar los contratos asociados. Al introducir el ID y realizar la búsqueda, se despliega una pantalla con el desglose del resumen de deuda, servicios contratados y sus respectivos costos.

