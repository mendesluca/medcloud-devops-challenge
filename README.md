# Medcloud DevOps Challenge

Este repositório contém a solução para o desafio técnico da Medcloud, utilizando AWS, Docker, Terraform, e uma aplicação Web de exemplo baseada em microserviços.

## 🧱 Estrutura

- **/app/** - Código dos serviços (todo-api, service-med)
- **/infra/** - Infraestrutura como código com Terraform
- **/modules/** - Módulos reutilizáveis do Terraform

## ✅ Tecnologias utilizadas

- AWS ECS Fargate
- CodePipeline + CodeBuild
- ALB + Auto Scaling + CloudWatch
- Docker
- Terraform
- SNS para alertas
- GitHub como SCM

## 📦 Serviços

- **todo-api:** Aplicação simples simulando gerenciamento de tarefas
- **service-med:** Microserviço de agendamento médico, simula contexto real da Medcloud

## 🧠 Objetivo

Demonstrar conhecimento em práticas DevOps, arquitetura escalável na AWS, automação de infraestrutura e boas práticas de CI/CD.

---

Mais detalhes serão adicionados conforme o projeto é desenvolvido.
