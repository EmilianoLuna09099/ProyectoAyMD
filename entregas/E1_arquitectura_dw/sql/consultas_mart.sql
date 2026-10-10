-- Responde: P1 ¿Qué libros no son localizables en el acervo?
SELECT 
    l.numero_adquisicion,
    l.titulo,
    l.clasificacion,
    t.fecha_completa AS fecha_del_prestamo_perdido
FROM `e1-aymd.eq01_dw.Hecho_Prestamo` h
INNER JOIN `e1-aymd.eq01_dw.Dim_Libro` l ON h.sk_libro = l.sk_libro
INNER JOIN `e1-aymd.eq01_dw.Dim_Tiempo` t ON h.sk_fecha_prestamo = t.sk_fecha
WHERE h.sk_fecha_devolucion IS NULL;

-- Responde: P2 Características comunes de ejemplares fuera de circulación (ROLLUP)
SELECT 
    COALESCE(l.clase_lc, 'Sin Clasificación') AS clase,
    l.subclase_lc AS subclase,
    l.tema_especifico_lc AS tema_especifico,
    SUM(h.cantidad_prestamos) AS total_prestamos
FROM `e1-aymd.eq01_dw.Dim_Libro` l
LEFT JOIN `e1-aymd.eq01_dw.Hecho_Prestamo` h ON l.sk_libro = h.sk_libro
GROUP BY ROLLUP(clase, l.subclase_lc, l.tema_especifico_lc)
ORDER BY clase, subclase, tema_especifico;

-- Responde: P3 Criterios de descarte (Ejemplares con Cero uso o nula circulación)
SELECT 
    l.numero_adquisicion,
    l.titulo,
    COALESCE(SUM(h.cantidad_prestamos), 0) AS historico_prestamos
FROM `e1-aymd.eq01_dw.Dim_Libro` l
LEFT JOIN `e1-aymd.eq01_dw.Hecho_Prestamo` h ON l.sk_libro = h.sk_libro
GROUP BY l.numero_adquisicion, l.titulo
HAVING historico_prestamos = 0;

-- Responde: P4 Factores de obsolescencia (Tendencia de caída temporal)
SELECT 
    t.anio AS anio_prestamo,
    l.clase_lc AS area_tematica,
    SUM(h.cantidad_prestamos) AS total_prestamos
FROM `e1-aymd.eq01_dw.Hecho_Prestamo` h
INNER JOIN `e1-aymd.eq01_dw.Dim_Libro` l ON h.sk_libro = l.sk_libro
INNER JOIN `e1-aymd.eq01_dw.Dim_Tiempo` t ON h.sk_fecha_prestamo = t.sk_fecha
WHERE t.anio IS NOT NULL
GROUP BY t.anio, l.clase_lc
ORDER BY l.clase_lc, t.anio;