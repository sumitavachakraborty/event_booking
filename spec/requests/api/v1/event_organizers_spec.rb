require 'rails_helper'

RSpec.describe "Api::V1::EventOrganizers", type: :request do
  describe "POST /api/v1/event_organizers" do
    let(:valid_attributes) do
      {
        event_organizer: {
          name: "Test Organizer",
          email: "organizer@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    
    let(:invalid_attributes) do
      {
        event_organizer: {
          name: "",
          email: "invalid-email",
          password: "pass",
          password_confirmation: "not_matching"
        }
      }
    end
    
    context "with valid parameters" do
      before do
        post "/api/v1/event_organizers", params: valid_attributes
      end
      
      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
      
      it "creates a new EventOrganizer" do
        expect(EventOrganizer.count).to eq(1)
        expect(EventOrganizer.first.email).to eq("organizer@example.com")
      end
      
      it "returns a JWT token" do
        expect(json["token"]).not_to be_nil
      end
    end
    
    context "with invalid parameters" do
      before do
        post "/api/v1/event_organizers", params: invalid_attributes
      end
      
      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      
      it "does not create a new EventOrganizer" do
        expect(EventOrganizer.count).to eq(0)
      end
      
      it "returns validation errors" do
        expect(json["errors"]).to be_present
      end
    end
  end
  
  describe "GET /api/v1/event_organizers/:id" do
    let!(:organizer) { create(:event_organizer) }
    
    context "when authenticated as the organizer" do
      before do
        get "/api/v1/event_organizers/#{organizer.id}", headers: auth_headers(organizer)
      end
      
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
      
      it "returns the organizer details" do
        expect(json["id"]).to eq(organizer.id)
        expect(json["name"]).to eq(organizer.name)
        expect(json["email"]).to eq(organizer.email)
      end
    end
    
    context "when not authenticated" do
      before do
        get "/api/v1/event_organizers/#{organizer.id}"
      end
      
      it "returns status code 401" do
        expect(response).to have_http_status(401)
      end
    end
    
    context "when authenticated as a different user type" do
      let(:customer) { create(:customer) }
      
      before do
        get "/api/v1/event_organizers/#{organizer.id}", headers: auth_headers(customer)
      end
      
      it "returns status code 403" do
        expect(response).to have_http_status(403)
      end
    end
  end
  
  describe "PUT /api/v1/event_organizers/:id" do
    let!(:organizer) { create(:event_organizer) }
    
    let(:valid_attributes) do
      {
        event_organizer: {
          name: "Updated Organizer",
          email: "updated@example.com"
        }
      }
    end
    
    context "when authenticated as the organizer" do
      before do
        put "/api/v1/event_organizers/#{organizer.id}", 
            params: valid_attributes,
            headers: auth_headers(organizer)
      end
      
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
      
      it "updates the organizer" do
        organizer.reload
        expect(organizer.name).to eq("Updated Organizer")
        expect(organizer.email).to eq("updated@example.com")
      end
    end
    
    context "when authenticated as a different organizer" do
      let(:other_organizer) { create(:event_organizer) }
      
      before do
        put "/api/v1/event_organizers/#{organizer.id}", 
            params: valid_attributes,
            headers: auth_headers(other_organizer)
      end
      
      it "returns status code 403" do
        expect(response).to have_http_status(403)
      end
      
      it "does not update the organizer" do
        original_name = organizer.name
        organizer.reload
        expect(organizer.name).to eq(original_name)
      end
    end
  end
  
  def json
    JSON.parse(response.body)
  end
end