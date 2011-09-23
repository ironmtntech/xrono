# Ticket Flow State Machine

module StateMachines::Ticket
  extend ActiveSupport::Concern

  included do
    state_machine :initial => :fridge do
      # Tickets start out "in the fridge"
      state :fridge

      # Tickets leaving fridge go to "stove" (development)
      state :stove
      event :pull_ticket do
        transition :pending => :stove
      end

      # Tickets leaving stove go to "taste_test" (peer review)
      state :taste_test
      event :submit_for_peer_review do
        transition :stove => :taste_test
      end

      # Tickets done cooking go to the "plate" (customer acceptance)
      state :plate
      event :show_to_client do
        transition :stove => :plate
      end

      # If the customer likes it, ticket is archived
      state :archive
      event :client_accepts do
        transition :plate => :archive
      end
    end
  end
