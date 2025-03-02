# Event Booking System API

## Getting Started

### Prerequisites

- Ruby 2.7.6
- Rails 6.1.7
- PostgreSQL
- Redis (for Sidekiq)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/event-booking-api.git
   cd event-booking-api
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Setup the database:
   ```bash
   rails db:create
   rails db:migrate
   ```

4. Start Redis for Sidekiq:
   ```bash
   redis-server
   ```

5. Start Sidekiq:
   ```bash
   bundle exec sidekiq
   ```

6. Start the Rails server:
   ```bash
   rails s
   ```

The API should now be running at `http://localhost:3000`.

### Running Tests

```bash
bundle exec rspec
```

## Project Structure

### Models

- **EventOrganizer**: Represents event organizers who can create and manage events
- **Customer**: Represents customers who can book tickets
- **Event**: Represents events created by event organizers
- **Ticket**: Represents ticket types for events with pricing information
- **Booking**: Represents ticket bookings made by customers

### Controllers

- **AuthenticationController**: Handles user login and JWT token generation
- **EventOrganizersController**: Manages event organizer profiles
- **CustomersController**: Manages customer profiles
- **EventsController**: Handles CRUD operations for events
- **TicketsController**: Manages ticket types for events
- **BookingsController**: Handles ticket booking operations

### Workers

- **SendBookingConfirmationWorker**: Sends email confirmations for bookings
- **NotifyCustomersWorker**: Sends notifications when events are updated

## API Endpoints

### Authentication

- **POST /api/v1/login**: Authenticate a user (event organizer or customer)
  ```json
  {
    "user_type": "event_organizer",
    "email": "organizer@example.com",
    "password": "password"
  }
  ```

### Event Organizers

- **POST /api/v1/event_organizers**: Register a new event organizer
- **GET /api/v1/event_organizers/:id**: Get event organizer profile
- **PUT /api/v1/event_organizers/:id**: Update event organizer profile

### Customers

- **POST /api/v1/customers**: Register a new customer
- **GET /api/v1/customers/:id**: Get customer profile
- **PUT /api/v1/customers/:id**: Update customer profile

### Events

- **GET /api/v1/events**: List all events (for customers) or organizer's events (for organizers)
- **GET /api/v1/events/:id**: Get event details with ticket information
- **POST /api/v1/events**: Create a new event (for organizers only)
- **PUT /api/v1/events/:id**: Update an event (for organizers only)
- **DELETE /api/v1/events/:id**: Delete an event (for organizers only)

### Tickets

- **GET /api/v1/events/:event_id/tickets**: List tickets for an event
- **POST /api/v1/events/:event_id/tickets**: Create a new ticket type (for organizers only)
- **PUT /api/v1/events/:event_id/tickets/:id**: Update a ticket type (for organizers only)
- **DELETE /api/v1/events/:event_id/tickets/:id**: Delete a ticket type (for organizers only)

### Bookings

- **GET /api/v1/bookings**: List customer's bookings
- **GET /api/v1/bookings/:id**: Get booking details
- **POST /api/v1/bookings**: Create a new booking (for customers only)
  ```json
  {
    "booking": {
      "event_id": 1,
      "ticket_id": 2,
      "quantity": 3
    }
  }
  ```

## Code Navigation

The project follows a standard Rails API structure:

- **app/models/**: Contains the data models and their relationships
- **app/controllers/api/v1/**: Contains the API controllers for each resource
- **app/serializers/**: Contains the serializers for formatting API responses
- **app/workers/**: Contains Sidekiq workers for background jobs
- **lib/json_web_token.rb**: Contains code for JWT token generation and validation

## Deployment

