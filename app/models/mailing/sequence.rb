class Mailing::Sequence < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :sequence_owners, class_name: "Mailing::SequenceOwner", dependent: :destroy, inverse_of: :sequence, foreign_key: "mailing_sequence_id"
  has_many :steps, class_name: "Mailing::SequenceStep", dependent: :destroy, foreign_key: :mailing_sequence_id, inverse_of: :sequence
  has_many :owners, through: :sequence_owners, source_type: "User"

  def self.name_and_steps_count
    left_joins(:steps).group(:name).count("mailing_sequence_steps.id")
  end

  #  Mailing::Sequence.send_mails(dry_run: true)
  def self.send_mails(dry_run: false)
    name_and_steps_count.each do |name, steps_count|
      logger.debug { "Sending mails for #{name} (#{steps_count} steps)" }
      Mailing::SequenceOwner.joins(:sequence).where(sequence: {name: name}).where("current_step < ? ", steps_count).where(canceled_at: nil).each do |owner|
        logger.debug { "\tVerify to send mail to #{owner.owner_name} current_step is #{owner.current_step}" }
        owner.send_next_step_if_ready(dry_run: dry_run)
      end
    end
  end
end
