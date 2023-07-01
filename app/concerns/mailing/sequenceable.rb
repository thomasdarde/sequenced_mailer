module Mailing::Sequenceable
  extend ActiveSupport::Concern

  included do
    has_many :sequence_owners, class_name: "Mailing::SequenceOwner", dependent: :destroy, inverse_of: :owner, as: :owner

    def add_to_sequence(name)
      logger.debug { "Will try to add to sequence: #{name}" }
      sequence = Mailing::Sequence.find_by(name: name)
      return unless sequence.present?

      if sequence_owners.where(mailing_sequence_id: sequence.id, canceled_at: nil).any?
        logger.debug { "User is already in the sequence" }
        return
      end
      logger.debug { "Sequence found: #{sequence.name} with #{sequence.steps.count} step" }
      sequence_owners.create(sequence: sequence)
    end

    def cancel_sequence(name)
      sequence_owner = sequence_owners.joins(:sequence).where(sequence: { name: name }).first
      return if sequence_owner.blank?

      sequence_owner.cancel!
    end
  end
end
