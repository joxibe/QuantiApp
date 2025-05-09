# 📁 Arquitectura del Proyecto - QuantiApp

Este documento describe la estructura técnica de QuantiApp, siguiendo principios de arquitectura limpia.

## 📦 Estructura de Carpetas

```
lib/
├── core/           # Configuraciones centrales
├── features/       # Funcionalidades principales
├── shared/         # Componentes reutilizables
```

### core/
- `config/`: Configuraciones globales
- `theme/`: Temas y estilos
- `routes/`: Navegación
- `utils/`: Helpers y funciones comunes

### features/
Cada módulo se organiza en:
- `data/`: Repositorios y fuentes
- `domain/`: Lógica y modelos
- `presentation/`: UI y widgets

Features:
- `auth/`: Login y perfil
- `transactions/`: Ingresos y gastos
- `reports/`: Reportes financieros
- `challenges/`: Retos gamificados

### shared/
- `widgets/`: UI genérica
- `models/`: Modelos compartidos
- `services/`: Lógica y comunicación externa

## 🧠 Arquitectura Limpia

### Capa de Presentación
- Widgets, Providers y Screens

### Capa de Dominio
- Use Cases, Entities y Repositories

### Capa de Datos
- Repositories, Data Sources, Models

## 🔄 Flujo de Datos

1. UI → Provider
2. Use Case → Repository
3. Data Source (local/API)

## 📐 Patrones Usados

- **Provider**: Estado
- **Repository**: Abstracción de datos
- **Factory**: Construcción de objetos

## 🧩 Convenciones

- snake_case para carpetas
- camelCase para variables
- PascalCase para clases y widgets

---