require "rails_helper"

RSpec.describe Mailing::SequenceOwner do
  describe ".description" do
    let(:sequence) { create(:sequence, :with_4_steps) }
    let(:owner) { create(:user, first_name: "Robert") }
    let(:sequence_owner) { create(:sequence_owner, sequence: sequence, owner: owner) }

    it "returns owner and steps" do
      expect(sequence_owner.description).to eq("Sequence: onboarding_sigilium - Owner: Robert - Step: #{sequence_owner.next_step.name}")
    end
  end
end
