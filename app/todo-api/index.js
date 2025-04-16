const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

const todos = [
  { id: 1, task: "Fazer deploy na AWS", completed: false },
  { id: 2, task: "Criar pipeline no CodePipeline", completed: true },
];

// Health check
app.get("/health", (req, res) => {
  res.status(200).send({ status: "ok" });
});

app.get("/", (req, res) => {
  res.send("Service-TODO API");
});

app.get("/todos", (req, res) => {
  res.json(todos);
});

app.post("/todos", (req, res) => {
  const { task, completed = false } = req.body; // pega do body, usa false como padrão
const newTodo = {
  id: todos.length + 1,
  task,
  completed,
};
  todos.push(newTodo);
  res.status(201).json(newTodo);
});

app.listen(port, () => {
  console.log(`Service-TODO rodando na porta ${port}`);
});
