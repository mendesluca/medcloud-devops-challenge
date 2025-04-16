FROM node:18-alpine

# Diretório de trabalho
WORKDIR /app

# Copia apenas arquivos de dependência e instala apenas produção
COPY package*.json ./
RUN npm install --production

# Copia o restante da aplicação
COPY . .

# Define a porta como variável de ambiente
ENV PORT=3000
EXPOSE $PORT

# Comando para iniciar a aplicação
CMD ["npm", "start"]
