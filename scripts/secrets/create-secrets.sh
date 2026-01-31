#!/bin/bash
set -e

echo "Creating Docker secrets..."

echo "RootPass_ChangeMe_123!" | docker secret create db_root_password - || true
echo "AppPass_ChangeMe_123!"  | docker secret create db_app_password - || true
echo "jwt_secret_min_32_bytes_change_me_123456" | docker secret create jwt_secret - || true
echo "RedisPass_ChangeMe_123!" | docker secret create redis_password - || true

echo "Secrets created."

