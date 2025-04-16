const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Lista de médicos mockados
const doctors = [
  { id: 1, name: "Dra. Ana", specialty: "Cardiologia" },
  { id: 2, name: "Dr. Bruno", specialty: "Dermatologia" },
];

// Horários disponíveis mockados
const slots = [
  { doctorId: 1, date: "2025-04-01", time: "14:00" },
  { doctorId: 2, date: "2025-04-01", time: "15:00" },
];

// Agendamentos salvos em memória
const bookings = [];

// Health check
app.get('/health', (req, res) => {
  res.status(200).send({ status: 'ok' });
});

// Lista de médicos
app.get('/doctors', (req, res) => {
  res.json(doctors);
});

// Horários disponíveis
app.get('/slots', (req, res) => {
  res.json(slots);
});

// Agendamento fictício (salvo em memória e remove slot)
app.post('/booking', (req, res) => {
  const { doctorId, date, time } = req.body;

  // Verifica se o slot existe
  const slotIndex = slots.findIndex(
    (slot) =>
      slot.doctorId === doctorId &&
      slot.date === date &&
      slot.time === time
  );

  if (slotIndex === -1) {
    return res.status(400).json({ message: "Horário indisponível para agendamento" });
  }

  // Remove o slot da lista de disponíveis
  slots.splice(slotIndex, 1);

  // Salva o agendamento
  const newBooking = { doctorId, date, time };
  bookings.push(newBooking);

  res.status(201).json({
    message: "Agendamento confirmado",
    ...newBooking
  });
});

// Listagem de agendamentos
app.get('/booking', (req, res) => {
  res.json(bookings);
});

// Endpoint que simula carga
app.get('/report', (req, res) => {
  const seconds = parseInt(req.query.seconds || 5);
  const end = Date.now() + seconds * 1000;
  while (Date.now() < end) {
    Math.sqrt(Math.random() * 10000);
  }
  res.send({ message: `Relatório gerado em ${seconds}s` });
});

app.listen(port, () => {
  console.log(`Service-Med rodando na porta ${port}`);
});
