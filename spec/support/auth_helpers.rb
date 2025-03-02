module AuthHelpers
    def auth_headers(user)
      token = JsonWebToken.encode(user_id: user.id, user_type: user.class.name)
      { 'Authorization': "Bearer #{token}" }
    end
  end