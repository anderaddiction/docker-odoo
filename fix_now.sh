#!/bin/bash
echo "=== SOLUCIÓN DEFINITIVA ==="

# 1. Eliminar Nginx
echo "1. Eliminando Nginx..."
sudo docker stop proj-nginx 2>/dev/null || true
sudo docker rm proj-nginx 2>/dev/null || true

# 2. Parar Odoo
echo "2. Parando Odoo..."
sudo docker stop proj 2>/dev/null || true
sudo docker rm proj 2>/dev/null || true

# 3. Asegurar que docker-compose.app.yml tiene puertos
echo "3. Configurando puertos..."
if ! grep -q "ports:" docker-compose.app.yml; then
    echo "Agregando configuración de puertos..."
    # Buscar línea después de container_name
    sed -i '/container_name: \${PROJECT_NAME}/a\    ports:\n      - "\${EXTERNAL_PORT_ODOO}:8069"' docker-compose.app.yml
fi

# 4. Asegurar que .env tiene puerto 8069
echo "4. Configurando .env..."
sed -i 's/EXTERNAL_PORT_ODOO=.*/EXTERNAL_PORT_ODOO=8069/' .env

# 5. Iniciar Odoo
echo "5. Iniciando Odoo..."
sudo docker compose -f docker-compose.app.yml up -d

# 6. Esperar
echo "6. Esperando inicio (30 segundos)..."
sleep 30

# 7. Mostrar resultados
echo ""
echo "=== RESULTADO ==="
sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "Logs de Odoo:"
sudo docker logs proj --tail 5 2>/dev/null || echo "Esperando..."

echo ""
echo "🌐 Accede ahora a: http://localhost:8069"
echo "🔑 Usuario: admin"
echo "🔑 Contraseña: admin"
