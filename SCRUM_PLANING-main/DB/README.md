FELIX PEDRO LUNA BERMUDEZ-241906
HELLEN DEL CARMEN BARRERA VELAZQUEZ-241347


# 📋 DB_SCRUM_PLANNING - Base de Datos para Gestión Scrum

Este repositorio contiene el script de estructura y los procedimientos almacenados para el sistema de planificación **Scrum Planning**, desarrollado en **SQL Server (T-SQL)**.

---

## 🛠️ Tecnologías Utilizadas
* **Motor de Base de Datos:** SQL Server 2019+
* **Lenguaje:** Transact-SQL (T-SQL)
* **IDE Recomendado:** VS Code / SQL Server Management Studio (SSMS)

---

## 🗂️ Esquemas de la Base de Datos

La base de datos se organiza en tres esquemas principales:
1. `SQM_SECURITY`: Control de roles y usuarios del sistema.
2. `SQM_CATALOGS`: Tablas de catálogo (Estados, Prioridades, Valores de Negocio, Tipos de Actividad).
3. `SQM_GENERAL`: Gestión del backlog (Iniciativas, Épicas, Features, PBIs, Tareas y Comentarios).

---

##  Funcionalidades e Implementación

Para cada una de las **12 tablas** del proyecto se implementaron 3 procedimientos almacenados estandarizados:
* **Insertar (`_Insert`):** Registro de nuevos datos asignando automáticamente la fecha actual (`GETDATE()`).
* **Actualizar (`_Update`):** Modificación de registros existentes con control de fecha de actualización.
* **Listar con Paginación (`_List`):** Consulta eficiente con soporte para paginación mediante `OFFSET` y `FETCH NEXT` (`@PageNumber`, `@PageSize`).

Total de procedimientos almacenados creados: **36**.

---

##  Instrucciones de Ejecución

1. **Crear Base de Datos y Tablas:**
   Ejecuta el archivo `01_Create_Database_And_Tables.sql` para crear la base de datos `DB_SCRUM_PLANNING`, los esquemas y las 12 tablas.

2. **Crear Procedimientos Almacenados:**
   Ejecuta el archivo `02_Stored_Procedures.sql` para compilar todos los procedimientos almacenados de Inserción, Actualización y Paginación.

3. **Ejecución de Pruebas:**
   Corre el archivo `03_PruebasProcedimientos.sql` para verificar el correcto funcionamiento de las operaciones CRUD y la paginación por páginas.