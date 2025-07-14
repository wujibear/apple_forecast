# Thanx Rewards

A Rails API + React client application for managing rewards.

## Quick Start

1. **Start the application:**
   ```bash
   ./start.sh
   ```

2. **Open the client:**
   Navigate to http://localhost:5173

3. **Login with the seeded user:**
   - Email: `user@example.com`
   - Password: `password123`

4. **View API documentation (optional):**
   - **Interactive Docs**: http://localhost:3000/docs
   - **OpenAPI Spec**: http://localhost:3000/api-docs

That's it! You can now browse rewards, redeem them, and view your claimed rewards.

## Development Setup

<details>
<summary>Click to expand development setup details</summary>

### Prerequisites
- Ruby 3.4.3
- Rails 8.0.2
- Node.js (for React client)
- React 18+
- SQLite3

### Manual Setup

1. **Install dependencies:**
   ```bash
   # Install root-level dependencies (includes Foreman)
   bundle install
   
   # Install Rails dependencies
   cd thanx_api && bundle install
   
   # Install Node.js dependencies
   cd thanx_client && npm install
   ```

2. **Setup database:**
   ```bash
   cd thanx_api && bundle exec rails db:create db:migrate db:seed
   ```

3. **Start services:**
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
- **API Documentation**: http://localhost:3000/docs

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

# Run React tests
cd thanx_client && npm test

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

</details>

## Design Choices

<details>
<summary>Click to expand design choices and rationale</summary>

### Rails API-Only Architecture

**Why API-only mode?**
- **Separation of concerns**: Clear boundary between backend logic and frontend presentation
- **Scalability**: Frontend and backend can scale independently
- **Technology flexibility**: Frontend can be React, Vue, mobile apps, or any HTTP client
- **Performance**: No server-side rendering overhead for a SPA
- **Development speed**: Rails generators and conventions accelerate backend development

### Authentication Strategy

**Why Rails authentication generator?**
- **Rapid development**: `rails generate authentication` provides a solid foundation
- **API-first**: Designed for API-only mode with JWT token authentication
- **Security**: Built-in password hashing, session management, and security best practices
- **Database storage**: JWT tokens stored in database for session management
- **Customization**: Easy to extend and modify for specific requirements

### API Design

**Why namespace API controllers and serializers?**
- **Versioning**: `/api/v1/` allows for future API versions without breaking changes
- **Organization**: Clear separation between API and potential web controllers
- **Documentation**: Self-documenting URL structure
- **Testing**: Easier to test API endpoints in isolation
- **Serialization**: Dedicated serializers ensure consistent JSON responses

### Frontend Architecture

**Why TanStack Query (React Query)?**
- **Server state management**: Handles caching, background updates, and synchronization
- **Developer experience**: Automatic loading states, error handling, and optimistic updates
- **Performance**: Intelligent caching reduces unnecessary API calls
- **Real-time feel**: Background refetching keeps data fresh
- **TypeScript support**: Excellent TypeScript integration for type safety

**Why React Router?**
- **SPA routing**: Client-side routing for smooth user experience
- **Nested routes**: Clean organization of route structure
- **Type safety**: Good TypeScript support
- **Active development**: Well-maintained with modern React patterns

### Component Architecture

**Why feature-based folder structure?**
- **Cohesion**: Related components are grouped together
- **Scalability**: Easy to add new features without cluttering
- **Maintainability**: Clear ownership and responsibility
- **Testing**: Easier to test related components together
- **Imports**: Clean import paths with index files

**Why separate pages from components?**
- **Data fetching**: Pages handle API calls and state management
- **Reusability**: Components focus on presentation and can be reused
- **Testing**: Easier to test business logic vs. presentation logic
- **Performance**: Components can be optimized independently

### Testing Strategy

**Why Vitest for frontend testing?**
- **Speed**: Vite-based testing is significantly faster than Jest
- **Modern**: Built for modern JavaScript/TypeScript
- **React Testing Library**: Excellent integration for component testing
- **Watch mode**: Fast feedback loop during development

**Why RSpec for backend testing?**
- **Rails integration**: Native Rails testing framework
- **Readable**: Expressive syntax for test descriptions
- **Fixtures**: Easy to set up test data
- **Coverage**: Comprehensive testing tools and helpers

### Database Design

**Why nanoid for identifiers?**
- **Security**: Non-sequential IDs prevent enumeration attacks
- **Performance**: Fast generation and indexing
- **URL-friendly**: Safe for URLs and API endpoints, easy to type on mobile
- **Collision resistance**: Extremely low probability of duplicates

</details> 