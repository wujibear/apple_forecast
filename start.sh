#!/bin/bash

# Thanx Rewards - Foreman-based startup script

echo "🚀 Starting Thanx Rewards with Foreman..."

# Check if we're in the right directory
if [ ! -f "thanx_api/Procfile" ] || [ ! -f "thanx_api/Gemfile" ]; then
    echo "❌ Error: Procfile or Gemfile not found in thanx_api directory. Please run this script from the project root."
    exit 1
fi

# Install all dependencies
echo "📦 Installing dependencies..."

# Install Rails dependencies if needed
if [ ! -d "thanx_api/.bundle" ]; then
    echo "  - Installing API dependencies..."
    (cd thanx_api && bundle install && bundle exec rails db:create db:migrate db:seed)
fi

# Install Node.js dependencies if needed
if [ ! -d "thanx_client/node_modules" ]; then
    echo "  - Installing client app dependencies..."
    (cd thanx_client && npm install)
fi

echo "✅ Dependencies installed!"

# Start both services with Foreman
echo "🚀 Starting API and client services..."
echo "   - Rails API: http://localhost:3000"
echo "   - React Client: http://localhost:5173"
echo ""
echo "Press Ctrl+C to stop all services"

# Run foreman from the Rails app directory
(cd thanx_api && bundle exec foreman start)