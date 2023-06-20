require "rails_helper"

RSpec.describe Mailing::SequenceStep do
  let(:sequence_step) { build(:sequence_step) }

  it "sends email immediatly if no waiting" do
    expect(described_class.new(days_after_last_step: 0).ready_to_send?(Time.zone.now)).to be(true)
  end

  it "sends email later if waiting" do
    expect(described_class.new(days_after_last_step: 1).ready_to_send?(1.day.ago)).to be(true)
    expect(described_class.new(days_after_last_step: 1).ready_to_send?(2.hours.ago)).to be(false)
  end

  describe ".email_name" do
    it "s a concatenation" do
      expect(sequence_step.email_name).to eq("onboarding_sigilium_#{sequence_step.name}")
    end
  end
end
