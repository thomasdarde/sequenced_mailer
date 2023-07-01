class Mailing::SequenceOwner < ActiveRecord::Base
  belongs_to :sequence, class_name: "Mailing::Sequence", foreign_key: "mailing_sequence_id", inverse_of: :sequence_owners
  belongs_to :owner, polymorphic: true
  delegate :steps, to: :sequence
  after_create :send_next_step_if_ready

  delegate :name, to: :next_step, prefix: true
  delegate :name, to: :owner, prefix: true
  delegate :name, to: :sequence, prefix: true

  def owner_name
    if owner.respond_to?(:full_name)
      owner.full_name
    else
      owner.name
    end
  end

  def description
    ["Sequence: #{sequence_name}", "Owner: #{owner_name}", "Step: #{next_step_name}"].join(" - ")
  end

  def cancel!
    update!(canceled_at: Time.zone.now)
  end

  def canceled?
    canceled_at.present?
  end

  def send_next_step_if_ready(dry_run: false)
    # First email is sent at creation if no delay is set
    # This method is then called every day of the week

    if ready_to_send_next_step?
      logger.debug { "Will send email to owner" }
      next_step.send_to_owner(self) unless dry_run
    else
      logger.debug { "Not ready to send next step" }
      nil
    end
  end

  def ready_to_send_next_step?
    return false if canceled?
    return false if last_step?
    next_step.ready_to_send?(last_activity_at)
  end

  def last_step?
    next_step.blank?
  end

  def next_step
    @next_step ||= steps.where("position > ?", current_step).order(position: :asc).first
  end

  def last_activity_at
    last_email_sent_at.presence || created_at
  end
end
