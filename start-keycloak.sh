#!/bin/bash

echo "🚀 Building and starting Keycloak with PharosAI theme..."

# Check which Docker Compose command is available
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
elif command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "❌ Error: Neither 'docker-compose' nor 'docker compose' command found!"
    echo "Please install Docker Compose:"
    echo "  - For Docker Compose V2: Install Docker Desktop or 'docker-compose-plugin'"
    echo "  - For Docker Compose V1: pip install docker-compose"
    exit 1
fi

echo "Using: $DOCKER_COMPOSE"

# Build and start the container
$DOCKER_COMPOSE up --build -d

echo "⏳ Waiting for Keycloak to start..."
echo "This may take a few minutes on first run..."

# Wait for Keycloak to be ready
until curl -s http://localhost:8080/health > /dev/null 2>&1; do
    echo "Still waiting for Keycloak..."
    sleep 10
done

echo ""
echo "✅ Keycloak is ready!"
echo ""
echo "🌐 Access URLs:"
echo "   Admin Console: http://localhost:8080/admin"
echo "   Login Page:    http://localhost:8080/realms/master/protocol/openid-connect/auth?client_id=account&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Frealms%2Fmaster%2Faccount%2F&response_type=code"
echo ""
echo "🔑 Admin Credentials:"
echo "   Username: admin"
echo "   Password: admin"
echo ""
echo "🎨 To apply the PharosAI theme:"
echo "   1. Go to Admin Console"
echo "   2. Select 'master' realm (or create a new realm)"
echo "   3. Go to Realm Settings → Themes"
echo "   4. Set Login Theme to 'kc-theme'"
echo "   5. Save the configuration"
echo ""
echo "📋 To stop: $DOCKER_COMPOSE down"
echo "📋 To view logs: $DOCKER_COMPOSE logs -f"
