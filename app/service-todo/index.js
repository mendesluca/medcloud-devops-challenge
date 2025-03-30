const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

const todos = [];

app.get('/', (req, res) => {
  res.send('Service-Todo rodando com sucesso');
});

app.get('/todos', (req, res) => {
  res.json(todos);
});

app.post('/todos', (req, res) => {
  const { task } = req.body;
  if (!task) {
    return res.status(400).json({ error: 'Campo "task" é obrigatório' });
  }

  const todo = { id: todos.length + 1, task };
  todos.push(todo);
  res.status(201).json(todo);
});

app.listen(port, () => {
  console.log(`Service-Todo rodando na porta ${port}`);
});
