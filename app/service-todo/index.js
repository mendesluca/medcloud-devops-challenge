const express = require("express");
const app = express();
const port = 3000;

app.use(express.json());

const todos = [
  { id: 1, task: "Fazer deploy na AWS", completed: false },
  { id: 2, task: "Criar pipeline no CodePipeline", completed: true },
];

app.get("/", (req, res) => {
  res.send("Service-TODO API");
});

app.get("/todos", (req, res) => {
  res.json(todos);
});

app.post("/todos", (req, res) => {
  const { task } = req.body;
  const newTodo = {
    id: todos.length + 1,
    task,
    completed: false,
  };
  todos.push(newTodo);
  res.status(201).json(newTodo);
});

app.listen(port, () => {
  console.log(`Service-TODO rodando na porta ${port}`);
});
