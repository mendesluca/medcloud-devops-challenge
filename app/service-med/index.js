const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.status(200).send({ status: 'ok' });
});

// Lista de médicos mockados
app.get('/doctors', (req, res) => {
  res.json([
    { id: 1, name: "Dra. Ana", specialty: "Cardiologia" },
    { id: 2, name: "Dr. Bruno", specialty: "Dermatologia" },
  ]);
});

// Horários disponíveis
app.get('/slots', (req, res) => {
  res.json([
    { doctorId: 1, date: "2025-04-01", time: "14:00" },
    { doctorId: 2, date: "2025-04-01", time: "15:00" },
  ]);
});

// Agendamento fictício
app.post('/booking', (req, res) => {
  const { doctorId, date, time } = req.body;
  res.status(201).send({
    message: "Agendamento confirmado",
    doctorId,
    date,
    time,
  });
});

// Endpoint que simula carga
app.get('/report', (req, res) => {
  const seconds = parseInt(req.query.seconds || 5);
  const end = Date.now() + seconds * 1000;
  while (Date.now() < end) {
    // Simula carga na CPU
    Math.sqrt(Math.random() * 10000);
  }
  res.send({ message: `Relatório gerado em ${seconds}s` });
});

app.listen(port, () => {
  console.log(`Service-Med rodando na porta ${port}`);
});
