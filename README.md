# proyecto_api

Aplicación Flutter con backend Express + MongoDB para gestionar usuarios.

## Requisitos

- Flutter SDK
- Node.js 18+
- npm
- MongoDB Atlas o una base Mongo accesible

## Backend

1. Entra a la carpeta backend:
   ```bash
   cd backend
   ```
2. Instala dependencias:
   ```bash
   npm install
   ```
3. Crea tu archivo `.env` usando el ejemplo:
   ```bash
   copy .env.example .env
   ```
4. Configura `MONGODB_URI` con tu cadena de conexión.
5. Inicia la API:
   ```bash
   npm start
   ```

La API queda en:
- `http://localhost:3000/api/users`
- `http://localhost:3000/health`

## Flutter

Desde la raíz del proyecto:

```bash
flutter run -d chrome
```

La app usa por defecto este backend local:
`http://localhost:3000/api/users`

Si necesitas apuntar a otra API, puedes sobreescribirlo con:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api/users
```

## Endpoints principales

- `GET /api/users`
- `POST /api/users`
- `PUT /api/users/:id`
- `DELETE /api/users/:id`

## Nota sobre CORS

El backend habilita CORS para permitir peticiones desde Flutter Web en localhost y desde un frontend desplegado con origen permitido.
