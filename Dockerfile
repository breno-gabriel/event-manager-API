# Usa uma imagem oficial do Ruby (verifique sua versão com ruby -v)
FROM ruby:3.4.1

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o Gemfile e instala as gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia o restante do código
COPY . .

# Script para corrigir problemas de PID do servidor Rails
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Comando principal para iniciar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]