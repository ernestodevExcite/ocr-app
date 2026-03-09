# Blueprint de la Aplicación de Inventario de Documentos

## Visión General

Esta aplicación de Flutter está diseñada para ayudar a los usuarios a inventariar su colección de documentos, expedientes y juicios. La aplicación permite a los usuarios capturar imágenes de las carátulas de los documentos, utiliza OCR para extraer automáticamente información relevante (como títulos, números de caso o partes involucradas), y permite la revisión y exportación de los datos. La aplicación está diseñada para ser rápida, eficiente y fácil de usar, con una interfaz de usuario limpia y moderna.

## Características Implementadas

### 1. **Diseño y Estilo**

*   **Tema Moderno:** La aplicación utiliza Material 3 con un esquema de colores basado en un color semilla, asegurando una apariencia moderna y cohesiva.
*   **Tipografía Clara:** Se utiliza `google_fonts` para una tipografía legible y estéticamente agradable.
*   **Modo Claro y Oscuro:** Soporte completo para temas claro y oscuro, con un interruptor para que el usuario elija su preferencia.

### 2. **Arquitectura y Navegación**

*   **Gestión de Estado con Provider:** Se utiliza el paquete `provider` para una gestión de estado eficiente y centralizada, separando la lógica de la interfaz de usuario.
    *   `ThemeProvider`: Gestiona el tema de la aplicación (claro/oscuro).
    *   `AppImageProvider`: Gestiona el estado de las imágenes capturadas y sus metadatos.
*   **Navegación con go_router:** Se utiliza `go_router` para una navegación declarativa y robusta entre las diferentes pantallas de la aplicación.

### 3. **Funcionalidades Principales**

*   **Captura de Imágenes:** La aplicación utiliza el paquete `camera` para permitir a los usuarios capturar imágenes de las carátulas de sus documentos.
*   **Reconocimiento Óptico de Caracteres (OCR):**
    *   Se utiliza `google_mlkit_text_recognition` para extraer texto de las imágenes capturadas.
    *   Un `OcrService` personalizado analiza el texto extraído para identificar datos clave.
*   **Revisión y Edición:**
    *   La `ReviewScreen` muestra una lista de las imágenes capturadas y los metadatos extraídos.
    *   Los usuarios pueden editar los metadatos a través de un diálogo de edición.
    *   Los usuarios pueden marcar un documento como "completado".
*   **Exportación a CSV:**
    *   Un `ExportService` permite a los usuarios exportar los datos de su inventario a un archivo CSV.
    *   La exportación se activa desde la pantalla de revisión y la descarga funciona en la web a través de `universal_html`.

## Plan de Desarrollo

El plan de desarrollo se dividió en los siguientes pasos:

1.  **Configuración Inicial:** Configurar el proyecto, el tema y la navegación.
2.  **Pantallas Básicas:** Crear las pantallas de captura y revisión.
3.  **Gestión de Estado:** Implementar la gestión de estado con `provider`.
4.  **Integración de la Cámara:** Añadir la funcionalidad de captura de imágenes.
5.  **Integración de OCR:** Añadir la funcionalidad de OCR con ML Kit.
6.  **Funcionalidad de Revisión:** Implementar la edición y actualización de estado en la pantalla de revisión.
7.  **Funcionalidad de Exportación:** Implementar la exportación a CSV.

**Todos los pasos se han completado con éxito.**
