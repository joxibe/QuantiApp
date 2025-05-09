# 📁 Arquitectura del Proyecto

## Estructura de Carpetas

```
lib/
├── core/           # Configuraciones y utilidades centrales
│   ├── config/     # Configuraciones de la aplicación
│   ├── theme/      # Temas y estilos
│   ├── routes/     # Navegación
│   └── utils/      # Utilidades generales
│
├── features/       # Características principales
│   ├── auth/       # Autenticación y gestión de usuarios
│   │   ├── data/       # Repositorios y fuentes de datos
│   │   ├── domain/     # Modelos y lógica de negocio
│   │   └── presentation/ # Widgets y pantallas
│   │
│   ├── transactions/  # Gestión de ingresos y gastos
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── reports/     # Informes y estadísticas
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── challenges/  # Retos de ahorro
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── shared/         # Componentes compartidos
    ├── widgets/    # Widgets reutilizables
    ├── models/     # Modelos de datos compartidos
    └── services/   # Servicios compartidos
```

## 📝 Descripción de Carpetas

### Core
- `config/`: Configuraciones globales, constantes y variables de entorno
- `theme/`: Temas, colores, tipografía y estilos de la aplicación
- `routes/`: Sistema de navegación y rutas
- `utils/`: Funciones de utilidad y helpers

### Features
Cada feature sigue una arquitectura limpia con tres capas:
- `data/`: Repositorios y fuentes de datos
- `domain/`: Lógica de negocio y modelos
- `presentation/`: UI, widgets y pantallas

### Shared
- `widgets/`: Componentes UI reutilizables
- `models/`: Modelos de datos compartidos entre features
- `services/`: Servicios globales (analytics, storage, etc.)

## 🔄 Flujo de Datos
1. UI (presentation) → 
2. Lógica de negocio (domain) → 
3. Repositorios (data) → 
4. Fuentes de datos externas

## 📦 Convenciones de Nombrado

### Archivos
- `feature_screen.dart`: Pantallas principales
- `feature_widget.dart`: Widgets específicos
- `feature_model.dart`: Modelos de datos
- `feature_repository.dart`: Repositorios
- `feature_service.dart`: Servicios

### Carpetas
- Usar snake_case para nombres de carpetas
- Nombres descriptivos y en plural para colecciones 

## Arquitectura Limpia

El proyecto sigue los principios de Clean Architecture, dividiendo la aplicación en capas:

### 1. Capa de Presentación
- **Screens**: Pantallas de la aplicación
- **Providers**: Gestión del estado usando Provider
- **Widgets**: Componentes reutilizables

### 2. Capa de Dominio
- **Entities**: Modelos de negocio
- **Repositories**: Interfaces para acceso a datos
- **Use Cases**: Lógica de negocio

### 3. Capa de Datos
- **Repositories**: Implementaciones concretas
- **Data Sources**: Fuentes de datos (local/remoto)
- **Models**: Modelos de datos

## Patrones de Diseño

### 1. Provider
- Gestión del estado de la aplicación
- Inyección de dependencias
- Separación de responsabilidades

### 2. Repository
- Abstracción del acceso a datos
- Implementación de operaciones CRUD
- Manejo de fuentes de datos múltiples

### 3. Factory
- Creación de objetos complejos
- Encapsulamiento de la lógica de construcción
- Flexibilidad en la creación de instancias

## Componentes Compartidos

### 1. Widgets Reutilizables
- `ActionButton`: Botones de acción
- `AnimatedActionButton`: Botones con animaciones
- `AnimatedBalanceCard`: Tarjeta de balance animada
- `CategoryChip`: Chips para categorías
- `ReportCard`: Tarjetas de informes
- `StatRow`: Filas de estadísticas
- `TransactionCard`: Tarjetas de transacciones
- `TransactionForm`: Formulario de transacciones

### 2. Utilidades
- `Formatters`: Formateo de moneda y fechas
- `AppColors`: Paleta de colores
- `AppTextStyles`: Estilos de texto
- `AppTheme`: Tema de la aplicación

## Flujo de Datos

1. **Presentación**
   - Usuario interactúa con la UI
   - Providers manejan el estado
   - Widgets se actualizan

2. **Dominio**
   - Use Cases procesan la lógica
   - Entities representan el modelo
   - Repositories definen contratos

3. **Datos**
   - Repositories implementan operaciones
   - Data Sources manejan el almacenamiento
   - Models mapean datos

## Consideraciones Técnicas

### 1. Estado
- Provider para gestión de estado
- Inmutabilidad de datos
- Actualizaciones eficientes

### 2. Rendimiento
- Widgets optimizados
- Carga lazy de datos
- Caché local

### 3. Mantenibilidad
- Código modular
- Tests unitarios
- Documentación clara 