# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# db/seeds.rb

# Clear existing data to avoid duplicates
puts "Clearing existing data..."
Booking.destroy_all
Ticket.destroy_all
Event.destroy_all
Customer.destroy_all
EventOrganizer.destroy_all

# Create Event Organizers
puts "Creating event organizers..."
organizers = [
  {
    name: "Concert Promotions Inc",
    email: "concerts@example.com",
    password: "password123"
  },
  {
    name: "Sports Events Ltd",
    email: "sports@example.com",
    password: "password123"
  },
  {
    name: "Tech Conference Group",
    email: "tech@example.com",
    password: "password123"
  },
  {
    name: "Art Exhibition Curators",
    email: "art@example.com",
    password: "password123"
  }
]

created_organizers = organizers.map do |organizer|
  EventOrganizer.create!(organizer)
end

# Create Customers
puts "Creating customers..."
customers = [
  {
    name: "John Smith",
    email: "john@example.com",
    password: "password123"
  },
  {
    name: "Jane Doe",
    email: "jane@example.com",
    password: "password123"
  },
  {
    name: "Bob Johnson",
    email: "bob@example.com",
    password: "password123"
  },
  {
    name: "Alice Williams",
    email: "alice@example.com",
    password: "password123"
  },
  {
    name: "Charlie Brown",
    email: "charlie@example.com",
    password: "password123"
  }
]

created_customers = customers.map do |customer|
  Customer.create!(customer)
end

# Create Events
puts "Creating events..."
events = [
  {
    title: "Rock Music Festival",
    description: "A weekend of the best rock bands in the country",
    venue: "Central Park",
    event_date: 30.days.from_now,
    event_organizer: created_organizers[0]
  },
  {
    title: "Championship Football Match",
    description: "The season finale with two top teams battling for the title",
    venue: "National Stadium",
    event_date: 45.days.from_now,
    event_organizer: created_organizers[1]
  },
  {
    title: "Web Development Conference",
    description: "Learn the latest trends in web development",
    venue: "Tech Convention Center",
    event_date: 60.days.from_now,
    event_organizer: created_organizers[2]
  },
  {
    title: "Modern Art Exhibition",
    description: "Featuring works from contemporary artists around the world",
    venue: "Metropolitan Museum",
    event_date: 15.days.from_now,
    event_organizer: created_organizers[3]
  },
  {
    title: "Jazz Night",
    description: "An evening of smooth jazz and fine dining",
    venue: "Blue Note Club",
    event_date: 7.days.from_now,
    event_organizer: created_organizers[0]
  },
  {
    title: "Tennis Tournament",
    description: "International tennis stars compete in the annual tournament",
    venue: "Sports Complex",
    event_date: 90.days.from_now,
    event_organizer: created_organizers[1]
  },
  {
    title: "AI and Machine Learning Summit",
    description: "Explore the future of AI with industry experts",
    venue: "Innovation Hub",
    event_date: 120.days.from_now,
    event_organizer: created_organizers[2]
  },
  {
    title: "Photography Exhibition",
    description: "Award-winning photographs from around the globe",
    venue: "Gallery of Fine Arts",
    event_date: 21.days.from_now,
    event_organizer: created_organizers[3]
  }
]

created_events = events.map do |event|
  Event.create!(event)
end

# Create Tickets
puts "Creating tickets..."
created_events.each do |event|
  # Create General Admission tickets
  Ticket.create!(
    name: "General Admission",
    price: rand(20..50),
    quantity_available: rand(100..500),
    event: event
  )
  
  # Create VIP tickets
  Ticket.create!(
    name: "VIP",
    price: rand(80..150),
    quantity_available: rand(20..100),
    event: event
  )
  
  # Some events have Early Bird tickets
  if [true, false].sample
    Ticket.create!(
      name: "Early Bird",
      price: rand(10..30),
      quantity_available: rand(50..200),
      event: event
    )
  end
  
  # Some events have Premium tickets
  if [true, false].sample
    Ticket.create!(
      name: "Premium",
      price: rand(100..200),
      quantity_available: rand(10..50),
      event: event
    )
  end
end

# Create Bookings
puts "Creating bookings..."
30.times do
  customer = created_customers.sample
  event = created_events.sample
  ticket = event.tickets.sample
  quantity = rand(1..5)
  
  # Ensure there are enough tickets available
  next if ticket.quantity_available < quantity
  
  # Create booking
  Booking.create!(
    customer: customer,
    event: event,
    ticket: ticket,
    quantity: quantity,
    total_price: ticket.price * quantity
  )
  
  # Update ticket availability
  ticket.update!(quantity_available: ticket.quantity_available - quantity)
end

puts "Seed data created successfully!"
puts "Created #{EventOrganizer.count} event organizers"
puts "Created #{Customer.count} customers"
puts "Created #{Event.count} events"
puts "Created #{Ticket.count} tickets"
puts "Created #{Booking.count} bookings"

# Print login information for testing
puts "\n=== LOGIN INFORMATION FOR TESTING ==="
puts "\nEvent Organizers:"
created_organizers.each do |organizer|
  puts "Email: #{organizer.email} | Password: password123"
end

puts "\nCustomers:"
created_customers.each do |customer|
  puts "Email: #{customer.email} | Password: password123"
end