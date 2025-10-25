# 🏛️ Base de Datos Municipal – Ayuntamiento de Málaga

Proyecto académico de diseño e implementación de una **base de datos relacional** inspirada en la **directiva municipal del Ayuntamiento de Málaga**.  
Incluye el **modelo entidad–relación (E-R)** y el **script SQL** para la creación de las tablas y la inserción de datos de prueba.

---

## 📄 Descripción general

El objetivo del proyecto es modelar y gestionar la información relacionada con **establecimientos, titulares, solicitudes de ocupación de la vía pública, mobiliario urbano, infracciones y autorizaciones municipales**.

Se parte del análisis de la normativa y de los requisitos de gestión para definir un esquema relacional que garantice integridad, consistencia y normalización.

---

## 🧩 Estructura del repositorio

📂 malaga-municipal-db/
┣ 📜 modelo_ER.pdf # Diagrama E-R y descripción de entidades
┣ 📜 Creacion_tablas_inserciones.sql # Script SQL con creación e inserción de datos
┗ 📘 README.md # Documentación del proyecto
---

## 🧠 Modelo Entidad–Relación

El **modelo E-R** define las principales entidades del sistema:

- **Titular**: persona responsable de uno o varios establecimientos.  
- **Establecimiento**: local que puede solicitar autorizaciones de ocupación.  
- **Solicitud**: petición formal que puede ser de cuatro tipos (I, II, III, IV).  
- **Gestión**: historial de titularidad de cada establecimiento.  
- **Infracción**: sanción o multa sobre una solicitud.  
- **Parcela, Mobiliario Urbano y Voladizo**: recursos físicos autorizados.  

Cada entidad cuenta con sus claves primarias, foráneas y restricciones de dominio (CHECK, ENUM, etc.).

---

## ⚙️ Estructura SQL

El script `Creacion_tablas_inserciones.sql` incluye:

- **Definición del esquema completo** mediante `CREATE TABLE` y tipos personalizados (`ENUM`).
- **Restricciones de integridad** (claves primarias, foráneas, dominios, fechas válidas).
- **Inserción de datos de ejemplo**, con tuplas ficticias para probar el modelo.

Para ejecutar el script en **PostgreSQL**:
```bash
psql -U usuario -d basedatos -f Creacion_tablas_inserciones.sql
```

---

## 🧮 Ejemplo de uso

Tras ejecutar el script, podrás consultar relaciones como:
```bash
-- Consultar titulares activos y sus establecimientos
SELECT t.nombre, e.nombre
FROM titular t
JOIN gestion g ON t.nif = g.nif_titular
JOIN establecimiento e ON e.id = g.id_establecimiento
WHERE g.fin_titularidad IS NULL;
```

---

## ✨ Aprendizaje

Con este proyecto aprendí a:

- Diseñar bases de datos relacionales desde cero.

- Traducir un modelo E-R a un esquema SQL funcional.

- Aplicar integridad referencial, restricciones y tipado con ENUM.

- Cargar y validar datos en PostgreSQL.

---

## 🧑‍💻 Equipo de desarrollo

Proyecto desarrollado como trabajo académico colaborativo por:

- Marcos Alonso Ulloa (@Marcau04)

- Iván Álvaro Luis

- Marcos Cámara Vicente

- Eric Soto San José
