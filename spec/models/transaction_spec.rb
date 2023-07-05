require 'rails_helper'
RSpec.describe Transaction, type: :model do
  describe 'validations' do
    subject { build(:transaction) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    context 'when skip_wallet_id_validate is true' do
      before { subject.skip_wallet_id_validate = true }
      context 'when both source_wallet_id and target_wallet_id are blank' do
        before do
          subject.source_wallet_id = nil
          subject.target_wallet_id = nil
        end
        it { is_expected.to validate_presence_of(:source_wallet_id) }
        it { is_expected.to validate_presence_of(:target_wallet_id) }
      end

      context 'when target_wallet_id is present' do
        before {subject.target_wallet_id = 1 }
        it { is_expected.not_to validate_presence_of(:source_wallet_id) }
      end

      context 'when source_wallet_id is present' do
        before { subject.source_wallet_id = 1 }
        it { is_expected.not_to validate_presence_of(:target_wallet_id) }
      end
    end
  end
end