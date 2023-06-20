class Mailing::SequenceStep < ApplicationRecord
  belongs_to :sequence, class_name: "Mailing::Sequence", foreign_key: "mailing_sequence_id", inverse_of: :steps

  def ready_to_send?(last_activity_at)
    return true if days_after_last_step == 0
    last_activity_at.beginning_of_day + days_after_last_step.days <= Time.zone.now
  end

  def send_to_owner(sequence_owner)
    # on a un scheduler qui appel les mails à envoyer les jours ouvrés
    #

    send_the_mail(sequence_owner.owner)
    sequence_owner.current_step = position
    sequence_owner.last_email_sent_at = Time.zone.now
    sequence_owner.save
  end

  def send_the_mail(owner)
    # InstallationMailer.user_promoted(owner.becomes(User)).deliver_later
    SequenceMailer.send(email_name, casted_owner(owner)).deliver_later
  end

  def email_name
    [sequence.name, name].join("_")
  end

  def casted_owner(owner)
    # Avoid an issue with serialization
    case owner.class.name
    when "CompanyAdmin", "OrganizationAdmin", "SimpleUser"
      owner.becomes(User)
    else
      owner
    end
  end
end
