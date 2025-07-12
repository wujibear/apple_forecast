# Thanx Rewards

A Rails API + React client application for managing rewards.

## Development Setup

### Prerequisites
- Ruby (with Rails 8.0.2)
- Node.js (for React client)
- SQLite3

### Quick Start

1. **Start everything with one command:**
   ```bash
   ./start.sh
   ```
   
   This will automatically:
   - Install all dependencies (root, Rails, and Node.js)
   - Start both services with Foreman

2. **Or install dependencies manually:**
   ```bash
   # Install root-level dependencies (includes Foreman)
   bundle install
   
   # Install Rails dependencies
   cd thanx_api && bundle install
   
   # Install Node.js dependencies
   cd thanx_client && npm install
   ```

3. **Setup database (first time only):**
   ```bash
   cd thanx_api && bundle exec rails db:create db:migrate
   ```

4. **Start services manually:**
   ```bash
   # Start both services with Foreman
   bundle exec foreman start
   
   # Or start individually
   cd thanx_api && bundle exec rails server -p 3000
   cd thanx_client && npm run dev
   ```

### Services

- **Rails API**: http://localhost:3000
- **React Client**: http://localhost:5173

### Development Commands

```bash
# Start both services with Foreman
./start.sh

# Start only Rails API
cd thanx_api && bundle exec rails server -p 3000

# Start only React client
cd thanx_client && npm run dev

# Run Rails tests
cd thanx_api && bundle exec rspec

# Build React for production
cd thanx_client && npm run build
```

### Project Structure

```
thanx_rewards/
├── thanx_api/          # Rails API
├── thanx_client/       # React client
├── Gemfile            # Root-level dependencies (Foreman)
├── .ruby-version      # Ruby version specification
├── Procfile           # Foreman process definitions
├── start.sh           # Development startup script
└── README.md          # This file
``` 