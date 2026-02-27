#!/bin/bash
set -e

# Remove um possível servidor que não foi fechado corretamente
rm -f /app/tmp/pids/server.pid

# Executa o comando principal do Dockerfile (o CMD)
exec "$@"