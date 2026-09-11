# Backend CRUD

## Instalación local

```bash
cd backend
npm install
copy .env.example .env
```

Edita `backend/.env` y coloca la cadena de conexión de MongoDB en `MONGODB_URI`.

## Ejecutar

```bash
npm start
```

La API queda disponible en `http://localhost:3000`.

- `GET /api/users`
- `POST /api/users`
- `PUT /api/users/:id`
- `DELETE /api/users/:id`
- `GET /health`

CORS está habilitado para permitir el cliente Flutter Web durante el desarrollo.

## Ejecutar Flutter contra este backend

Desde la raíz del proyecto:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api/users
```

Para Render, define `MONGODB_URI` en Environment y usa el directorio `backend` como Root Directory. El Start Command debe ser `npm start`.
