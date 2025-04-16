# 🚀 Medcloud DevOps Challenge

Este repositório contém a solução para o desafio técnico da Medcloud, focado em práticas modernas de DevOps, automação com Terraform, CI/CD com CodePipeline, monitoramento com CloudWatch e deploy em ambiente AWS com containers Docker.

---

## 📁 Estrutura do Projeto

```
.
├── app/                    # Aplicações em Node.js (todo-api, service-med)
│   └── service-name/       # Cada microserviço com Dockerfile + buildspec.yml
├── infra/                  # Infraestrutura com Terraform
│   ├── dev/                # Workspace de desenvolvimento
│   └── modules/            # Módulos reutilizáveis (VPC, ECS, ECR, ALB, etc)
└── README.md
```

---

## ✅ Tecnologias e Ferramentas Utilizadas

- **AWS ECS Fargate** – execução serverless de containers
- **Amazon ECR** – repositório de imagens Docker
- **AWS CodePipeline + CodeBuild** – CI/CD completo
- **Application Load Balancer (ALB)** – balanceamento de carga
- **CloudWatch + SNS** – monitoramento e alertas por e-mail
- **Terraform** – infraestrutura como código (IaC)
- **Docker** – empacotamento e distribuição dos serviços
- **GitHub** – controle de versão e integração via CodePipeline

---

## 🧠 Objetivo do Projeto

- Automatizar o deploy de duas aplicações web em containers separados (simulando microserviços)
- Criar uma infraestrutura escalável, segura e monitorável utilizando apenas ferramentas da AWS
- Integrar CI/CD com build automatizado, push para o ECR e deploy no ECS
- Aplicar conceitos de **SRE** (confiabilidade) e **FinOps** (otimização de custo)
- Utilizar boas práticas de modularização com Terraform

---

## 📦 Microserviços

| Serviço       | Descrição                                                   |
|---------------|-------------------------------------------------------------|
| `todo-api`    | Aplicação simples de gerenciamento de tarefas               |
| `service-med` | Microserviço de agendamento médico, simulando o contexto real da Medcloud |

---

## 🚨 Monitoramento e Alertas

- **CloudWatch Logs**: logs de aplicação centralizados
- **CloudWatch Alarm**: monitora uso de CPU no ECS
- **SNS Topic**: envia alertas para o e-mail `mendes.lucasm740@gmail.com` quando a CPU excede 70%

---

## 📦 CI/CD com CodePipeline

- CodePipeline monitorando o GitHub
- CodeBuild com `buildspec.yml` que:
  - Instala dependências
  - Builda imagem Docker
  - Faz push da imagem para o ECR
- ECS atualizado automaticamente via CodePipeline

---

## 📄 Como rodar localmente

```bash
cd app/todo-api
npm install
npm start
```

---

## 🌐 Como provisionar a infraestrutura

```bash
cd infra/dev
terraform init
terraform workspace new dev
terraform apply
```

---

## 📬 Contato

Desenvolvido por **Lucas Wellinson Mendes Martins**  
Email: mendes.lucasm740@gmail.com  
LinkedIn: [lucas-mendes](https://www.linkedin.com/in/lucas-mendes-a675a7263/)
