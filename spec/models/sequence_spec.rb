require "rails_helper"

RSpec.describe Mailing::Sequence do
  describe "name_and_steps_count" do
    context "when no sequence" do
      it "returns the name and steps count" do
        expect(described_class.name_and_steps_count).to eq({})
      end
    end

    context "when sequence" do
      before do
        create(:sequence, :with_4_steps)
      end

      it "returns the name and steps count" do
        expect(described_class.name_and_steps_count).to eq({"onboarding_sigilium" => 4})
      end
    end
  end

  describe "owners" do
    let(:sequence) { create(:sequence, :with_4_steps) }
    let(:user) { create(:user) }

    before do
      user.add_to_sequence(sequence.name)
      sequence.reload
    end

    fit "returns the owners" do
      expect(sequence.owners).to eq([user])
    end
  end
end
