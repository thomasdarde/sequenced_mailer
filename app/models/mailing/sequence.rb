class Mailing::Sequence < ApplicationRecord
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

  def self.sequences_and_steps_names
    {"onboarding_admin_sigilium" => {user_promoted: 0},
     "onboarding_sigilium" => {welcome: 1},
     "subscription_failed_payment" => {first_alert: 1}}
  end

  def self.seed
    sequences_and_steps_names.each do |sequence_name, steps_details|
      sequence = Mailing::Sequence.find_or_create_by(name: sequence_name)
      steps_details.each.with_index do |step_details, index|
        step_name, days_after_last_step = step_details
        step = sequence.steps.find_or_initialize_by(name: step_name)
        step.days_after_last_step = days_after_last_step
        step.position = index + 1
        step.save!
      end
    end
  end
end
