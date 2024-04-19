# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost",
            %r{\Ahttps://*\.gallegoiv\.com\z}
  end
end
