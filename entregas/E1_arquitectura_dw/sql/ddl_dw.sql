-- 1. Dimensión Tiempo
CREATE TABLE `e1-aymd.eq01_dw.Dim_Tiempo` (
    sk_fecha INT64 NOT NULL,
    fecha_completa DATE,
    anio INT64,
    mes INT64,
    PRIMARY KEY (sk_fecha) NOT ENFORCED
) OPTIONS (description = 'Dimensión de tiempo. SCD Tipo 0. Responde a: P1, P4');

-- 2. Dimensión Libro
CREATE TABLE `e1-aymd.eq01_dw.Dim_Libro` (
    sk_libro INT64 NOT NULL,
    numero_adquisicion STRING,
    titulo STRING,
    clasificacion STRING,
    prefijo_lc STRING,
    clase_lc STRING,
    subclase_lc STRING,
    PRIMARY KEY (sk_libro) NOT ENFORCED
) OPTIONS (description = 'Dimensión de ejemplares físicos. SCD Tipo 1. Responde a: P1, P2, P3, P4');

-- 3. Tabla de Hechos: Préstamos
CREATE TABLE `e1-aymd.eq01_dw.Hecho_Prestamo` (
    sk_libro INT64 NOT NULL,
    sk_fecha_prestamo INT64 NOT NULL,
    sk_fecha_devolucion INT64,
    cantidad_prestamos INT64,
    dias_prestamo INT64,
    FOREIGN KEY (sk_libro) REFERENCES `e1-aymd.eq01_dw.Dim_Libro`(sk_libro) NOT ENFORCED,
    FOREIGN KEY (sk_fecha_prestamo) REFERENCES `e1-aymd.eq01_dw.Dim_Tiempo`(sk_fecha) NOT ENFORCED,
    FOREIGN KEY (sk_fecha_devolucion) REFERENCES `e1-aymd.eq01_dw.Dim_Tiempo`(sk_fecha) NOT ENFORCED
) OPTIONS (description = 'Grano: Una fila por cada evento de préstamo de un ejemplar físico.');
