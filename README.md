# 🚀 Medcloud DevOps Challenge

Este repositório contém a solução para o desafio técnico da Medcloud, com foco em DevOps, infraestrutura na AWS e automação de ponta a ponta.

A proposta era criar uma **pipeline completa** com ferramentas nativas da AWS para fazer o **deploy de uma aplicação web simples** (à sua escolha), incluindo monitoramento e boas práticas de infraestrutura.

---

## 🧠 Objetivo

Demonstrar conhecimento prático em:

- Arquitetura escalável com AWS
- Infraestrutura como código com Terraform
- Automatização com CI/CD
- Observabilidade (monitoramento e alertas)
- Boas práticas de DevOps, FinOps e SRE

---

## 🧱 Estrutura do Projeto

```
.
├── app/
│   ├── service-todo/    # Aplicação TODO (Node.js + Docker)
│   └── service-med/     # Agendamentos médicos simulados
│
├── infra/
│   ├── dev/             # Infraestrutura para ambiente de desenvolvimento
│   └── modules/         # Módulos reutilizáveis do Terraform
```

---

## 🧰 Tecnologias e Serviços Utilizados

- **AWS ECS (Fargate)** – Execução serverless dos containers
- **AWS CodePipeline & CodeBuild** – CI/CD 100% automatizado
- **AWS ECR** – Armazenamento das imagens Docker
- **AWS Application Load Balancer (ALB)** – Balanceamento de carga
- **AWS CloudWatch** – Monitoramento de métricas e logs
- **AWS SNS** – Notificações via e-mail em caso de alertas
- **AWS Auto Scaling** – Escalonamento automático com base na CPU
- **Terraform** – IaC modular, com uso de workspaces
- **GitHub** – Versionamento e gatilho para o pipeline

---

## 📦 Serviços Desenvolvidos

| Serviço       | Descrição                                                                 |
|---------------|---------------------------------------------------------------------------|
| `service-todo`| API simples para gerenciar tarefas (exemplo genérico para testes)         |
| `service-med` | Microserviço simulado de agendamento médico (mais próximo da realidade)  |

---

## ✅ Funcionalidades Entregues

- [x] Pipeline CI/CD com CodePipeline + CodeBuild
- [x] Deploy automático em ECS Fargate com ALB
- [x] Auto scaling com base em CPU (1-3 instâncias)
- [x] Monitoramento com CloudWatch e alarmes
- [x] Notificação por e-mail via SNS
- [x] Scheduling para desligar serviços fora do horário (FinOps)
- [x] Uso de workspaces para ambientes isolados (dev/prod)
- [x] Infraestrutura como código 100% gerenciada via Terraform

---

## 🧪 Testes Realizados

- ✅ Push no GitHub dispara o pipeline
- ✅ Build + deploy automático com sucesso
- ✅ Simulação de carga para testar escalonamento
- ✅ Alarmes e e-mails recebidos com uso de `SNS`
- ✅ Testes manuais com `curl` e `Postman` para as rotas

---

## 📍 Conclusão

Esse projeto foi construído com foco em **eficiência, boas práticas e realismo**. Busquei simular um cenário próximo ao que se vive em uma equipe DevOps real, com ferramentas e abordagens adotadas em produção.

O projeto está modularizado, com infraestrutura automatizada e facilmente replicável. Além disso, inclui boas práticas de segurança e otimização de custos.

---

## 👨‍💻 Autor

Feito por [Lucas Mendes](https://github.com/mendesluca)

