# Tópicos de Geofísica: Pipeline de Modelado Sísmico y Tsunamis

Este repositorio documenta el flujo de trabajo técnico y académico desarrollado para el estudio de fenómenos geofísicos. Contiene herramientas para el cálculo de deformaciones elásticas, procesamiento de bases de datos topográficas y simulación de propagación de ondas.

## 📖 Descripción del Proyecto
El proyecto se estructura como una cadena de procesos (pipeline) donde el resultado de cada etapa sirve como insumo para la siguiente. El objetivo final es modelar el impacto de un evento sísmico desde la falla hasta la inundación costera.

## 🛠️ Mi Contribución Técnica
Aunque los códigos base forman parte de la cátedra de Geofísica en la UNMSM, mi labor técnica se centró en:
* **Actualización y Refactorización**: Adaptación de scripts de MATLAB y Fortran antiguos para asegurar su funcionamiento en versiones modernas de los lenguajes.
* **Desarrollo de Scripts de Interoperabilidad**: Creación de herramientas propias para la conversión de formatos de datos entre las distintas etapas del modelado.
* **Gestión de Datos**: Procesamiento de bases de datos internacionales para la generación de mallas de entrada.

## 🔬 Flujo de Trabajo (Pipeline de Laboratorios)

### 1. Pre-procesamiento y Datos de Entrada (Lab 1)
Preparación de bases de datos de elevación y batimetría para configurar las grillas de simulación.
* **Recursos**: `SRTM90`, `gebco30`, `Etopo5`.

### 2. Modelado de la Fuente Sísmica y Deformación (Lab 2 y 3)
Cálculo de la deformación elástica del terreno utilizando el modelo de Okada.
* **Archivos clave**: 
    * `deform.f` (Fortran): Motor de cálculo de deformación.
    * `falla.m` / `fault_plane_n.m`: Definición de planos de falla en MATLAB.
    * `a.exe`: Ejecutable actualizado para el procesamiento.
* **Visualización**: `Mansinha_8.5Mw.png` (Muestra de la deformación inicial para un sismo de 8.5 Mw).

### 3. Simulación de Tsunami (Lab 4)
Modelado de la propagación de la onda utilizando el modelo **TUNAMI**, integrando los resultados de deformación y batimetría obtenidos previamente.

## 📂 Estructura de Archivos Principal
* **`deform_a.grd`**: Resultados de deformación superficial en formato de grilla.
* **`pfalla01.inp`**: Archivo de parámetros de entrada para la simulación sísmica.
* **`tidal.dat`**: Datos de mareas para condiciones de frontera.
* **`comcot2asc.m` / `grd2xyz.m`**: Scripts de conversión para manejo de formatos científicos.

## 💻 Tecnologías y Herramientas
* **Lenguajes**: Fortran (Cálculo de alto rendimiento), MATLAB (Post-procesamiento y análisis).
* **Modelos**: Okada, TUNAMI, Modelos de transferencia de esfuerzos.

## 📝 Nota de Autoría y Contexto
Este repositorio es de carácter técnico-académico. Los algoritmos base fueron facilitados por Dr. Cesar Jimenez Tintaya. Mi trabajo consistió en la implementación, actualización de código y ejecución de los modelos para casos de estudio locales.

## 👤 Contacto
**Liuba Ramos** Ciencias Físicas - UNMSM  
[GitHub Profile](https://github.com/LiubaRamos) | [LinkedIn](https://www.linkedin.com/in/liuba-llantirhuay/)
