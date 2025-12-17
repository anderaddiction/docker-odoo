#!/bin/bash
echo "=== REINICIANDO ODOO SIN NGINX ==="

# 1. Parar todo
echo "Deteniendo servicios..."
sudo docker compose -f docker-compose.app.yml down 2>/dev/null || true
sudo docker compose -f docker-compose.db.yml down 2>/dev/null || true

# 2. Eliminar contenedores residuales
echo "Limpiando contenedores..."
sudo docker rm -f ${PROJECT_NAME} ${PROJECT_NAME}-nginx ${PROJECT_NAME}_db 2>/dev/null || true

# 3. Iniciar base de datos
echo "Iniciando PostgreSQL..."
sudo docker compose -f docker-compose.db.yml up -d

# 4. Esperar que PostgreSQL esté listo
echo "Esperando PostgreSQL (15 segundos)..."
sleep 15

# 5. Iniciar Odoo
echo "Iniciando Odoo..."
sudo docker compose -f docker-compose.app.yml up -d

# 6. Esperar que Odoo inicie
echo "Esperando Odoo (30 segundos)..."
sleep 30

# 7. Mostrar estado
echo ""
echo "=== ESTADO ACTUAL ==="
sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 8. Ver logs de inicio
echo ""
echo "=== ÚLTIMOS LOGS DE ODOO ==="
sudo docker logs ${PROJECT_NAME} --tail 10

echo ""
echo "✅ ODOO CONFIGURADO SIN NGINX"
echo "🌐 Accede en: http://localhost:8069"
echo "🔑 Usuario: admin"
echo "🔑 Contraseña: admin"
