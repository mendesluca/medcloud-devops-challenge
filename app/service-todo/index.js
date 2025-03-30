const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

let todos = [];

app.get('/health', (req, res) => {
  res.status(200).send({ status: 'ok' });
});

app.get('/todos', (req, res) => {
  res.json(todos);
});

app.post('/todos', (req, res) => {
  const { task } = req.body;
  if (!task) return res.status(400).send({ error: 'task is required' });
  todos.push({ id: todos.length + 1, task });
  res.status(201).send({ message: 'Task added!' });
});

app.listen(port, () => {
  console.log(`Todo API rodando na porta ${port}`);
});
