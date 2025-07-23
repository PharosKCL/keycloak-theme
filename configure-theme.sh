#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎨 PharosAI Keycloak Theme Configuration Script${NC}"
echo ""

KEYCLOAK_URL="http://localhost:8080"
ADMIN_USER="admin"
ADMIN_PASS="admin"

# Function to get access token
get_access_token() {
    curl -s -X POST \
        "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "username=${ADMIN_USER}" \
        -d "password=${ADMIN_PASS}" \
        -d "grant_type=password" \
        -d "client_id=admin-cli" | \
        python3 -c "import sys, json; print(json.load(sys.stdin)['access_token'])" 2>/dev/null
}

# Check if Keycloak is running
echo -e "${YELLOW}Checking Keycloak status...${NC}"
if ! curl -s "${KEYCLOAK_URL}/health" > /dev/null; then
    echo -e "${RED}❌ Keycloak is not running on ${KEYCLOAK_URL}${NC}"
    echo -e "${BLUE}💡 Start Keycloak first with: ./start-keycloak.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Keycloak is running${NC}"

# Get access token
echo -e "${YELLOW}Getting admin access token...${NC}"
ACCESS_TOKEN=$(get_access_token)

if [ -z "$ACCESS_TOKEN" ]; then
    echo -e "${RED}❌ Failed to get access token. Please check admin credentials.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Access token obtained${NC}"

# Update master realm to use kc-theme
echo -e "${YELLOW}Configuring master realm to use PharosAI theme...${NC}"

REALM_CONFIG='{
    "loginTheme": "pharosai-theme",
    "displayName": "PharosAI",
    "displayNameHtml": "<div class=\"kc-logo\"><strong>PharosAI</strong></div>"
}'

curl -s -X PUT \
    "${KEYCLOAK_URL}/admin/realms/master" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${REALM_CONFIG}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Theme configured successfully!${NC}"
else
    echo -e "${RED}❌ Failed to configure theme${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 PharosAI theme is now active!${NC}"
echo ""
echo -e "${BLUE}🌐 Test the theme:${NC}"
echo -e "   Login Page: ${KEYCLOAK_URL}/realms/master/protocol/openid-connect/auth?client_id=account&redirect_uri=${KEYCLOAK_URL}/realms/master/account/&response_type=code"
echo ""
echo -e "${BLUE}🔧 Admin Console:${NC}"
echo -e "   URL: ${KEYCLOAK_URL}/admin"
echo -e "   User: ${ADMIN_USER}"
echo -e "   Pass: ${ADMIN_PASS}"
