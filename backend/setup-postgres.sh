#!/bin/bash
set -e

CONTAINER_NAME="studentcert-postgres"
POSTGRES_PASSWORD="password"
POSTGRES_USER="postgres"
POSTGRES_PORT=5432

DATABASES=("studentcert_auth" "certificatesdb" "university_db")

echo "🚀 Checking PostgreSQL container..."

if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "📦 PostgreSQL container already exists."
    docker start $CONTAINER_NAME >/dev/null 2>&1 || true
else
    echo "👉 Starting new PostgreSQL container..."
    docker run -d \
        --name $CONTAINER_NAME \
        -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
        -p $POSTGRES_PORT:5432 \
        postgres:16
fi

echo "⏳ Waiting for PostgreSQL to be ready..."
until docker exec "$CONTAINER_NAME" pg_isready -U "$POSTGRES_USER" >/dev/null 2>&1; do
    printf "."
    sleep 1
done
echo " ✔ Ready!"

echo "🔍 Ensuring required databases exist..."

echo "🔍 Ensuring required databases exist..."
for DB in "${DATABASES[@]}"; do
    echo "📌 Checking database: $DB"
    if docker exec "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -h 127.0.0.1 -tAc "SELECT 1 FROM pg_database WHERE datname='$DB'" | grep -q 1; then
        echo "✔ Database '$DB' already exists — skipping."
    else
        echo "➕ Creating database '$DB'..."
        docker exec "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -h 127.0.0.1 -c "CREATE DATABASE \"$DB\";"
        echo "✨ Database '$DB' created!"
    fi
done


echo "🎉 PostgreSQL setup complete!"
docker ps | grep "$CONTAINER_NAME"
