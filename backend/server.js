require('dotenv').config();

const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

const port = process.env.PORT || 3000;
const mongoUri = process.env.MONGODB_URI;

function createApp() {
  const app = express();

  app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  }));
  app.options('*', cors());
  app.use(express.json());

  return app;
}

const app = createApp();

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, trim: true },
    age: { type: Number, required: true, min: 0 },
  },
  { versionKey: false },
);

const User = mongoose.model('User', userSchema);

app.get('/health', (_request, response) => {
  response.json({ status: 'ok' });
});

app.get('/api/users', async (_request, response, next) => {
  try {
    const users = await User.find().sort({ _id: -1 });
    response.json(users);
  } catch (error) {
    next(error);
  }
});

app.post('/api/users', async (request, response, next) => {
  try {
    const user = await User.create(request.body);
    response.status(201).json(user);
  } catch (error) {
    next(error);
  }
});

app.put('/api/users/:id', async (request, response, next) => {
  try {
    const user = await User.findByIdAndUpdate(
      request.params.id,
      request.body,
      { new: true, runValidators: true },
    );

    if (!user) {
      return response.status(404).json({ message: 'Usuario no encontrado' });
    }

    response.json(user);
  } catch (error) {
    next(error);
  }
});

app.delete('/api/users/:id', async (request, response, next) => {
  try {
    const user = await User.findByIdAndDelete(request.params.id);

    if (!user) {
      return response.status(404).json({ message: 'Usuario no encontrado' });
    }

    response.status(204).send();
  } catch (error) {
    next(error);
  }
});

app.use((error, _request, response, _next) => {
  if (error.name === 'ValidationError') {
    return response.status(400).json({ message: error.message });
  }

  if (error.name === 'CastError') {
    return response.status(400).json({ message: 'Id de usuario inválido' });
  }

  console.error(error);
  response.status(500).json({ message: 'Error interno del servidor' });
});

async function start() {
  if (!mongoUri) {
    throw new Error('Falta definir MONGODB_URI en backend/.env');
  }

  await mongoose.connect(mongoUri);
  app.listen(port, () => {
    console.log(`API escuchando en http://localhost:${port}`);
  });
}

if (require.main === module) {
  start().catch((error) => {
    console.error(error.message);
    process.exit(1);
  });
}

module.exports = { app, createApp, start };
