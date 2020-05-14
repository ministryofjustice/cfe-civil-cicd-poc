require 'rails_helper'

module RemarkGenerators
  RSpec.describe FrequencyChecker do
    context 'state benefit payments' do
      let(:amount) { 123.45 }
      let(:dates) { [Date.today, 1.month.ago, 2.month.ago] }
      let(:state_benefit) { create :state_benefit }
      let(:assessment) { state_benefit.gross_income_summary.assessment }
      let(:payment_1) { create :state_benefit_payment, state_benefit: state_benefit, amount: amount, payment_date: dates[0] }
      let(:payment_2) { create :state_benefit_payment, state_benefit: state_benefit, amount: amount, payment_date: dates[1] }
      let(:payment_3) { create :state_benefit_payment, state_benefit: state_benefit, amount: amount, payment_date: dates[2] }
      let(:collection) { [payment_1, payment_2, payment_3] }

      context 'regular payments' do
        let(:dates) { [Date.today, 1.month.ago, 2.month.ago] }

        it 'does not update the remarks class' do
          original_remarks = assessment.remarks.as_json
          described_class.call(assessment, collection)
          expect(assessment.reload.remarks.as_json).to eq original_remarks
        end
      end

      context 'variation in dates' do
        let(:dates) { [2.days.ago, 10.days.ago, 55.days.ago] }

        it 'adds the remark' do
          expect_any_instance_of(Remarks).to receive(:add).with(:state_benefit_payment, :unknown_frequency, collection.map(&:client_id))
          described_class.call(assessment, collection)
        end

        it 'stores the changed the remarks class on the assessment' do
          original_remarks = assessment.remarks.as_json
          described_class.call(assessment, collection)
          expect(assessment.reload.remarks.as_json).not_to eq original_remarks
        end
      end
    end

    context 'outgoings' do
      let(:disposable_income_summary) { create :disposable_income_summary }
      let(:assessment) { disposable_income_summary.assessment }
      let(:amount) { 277.67 }
      let(:collection) do
        [
          create(:legal_aid_outgoing, disposable_income_summary: disposable_income_summary, payment_date: dates[0], amount: amount),
          create(:legal_aid_outgoing, disposable_income_summary: disposable_income_summary, payment_date: dates[1], amount: amount),
          create(:legal_aid_outgoing, disposable_income_summary: disposable_income_summary, payment_date: dates[2], amount: amount)
        ]
      end

      context 'regular payments' do
        let(:dates) { [Date.today, 1.month.ago, 2.months.ago] }

        it 'does not update the remarks class' do
          original_remarks = assessment.remarks.as_json
          described_class.call(assessment, collection)
          expect(assessment.reload.remarks.as_json).to eq original_remarks
        end
      end

      context 'irregular dates' do
        let(:dates) { [Date.today, 1.week.ago, 9.weeks.ago] }

        it 'adds the remark' do
          expect_any_instance_of(Remarks).to receive(:add).with(:outgoings_legal_aid, :unknown_frequency, collection.map(&:client_id))
          described_class.call(assessment, collection)
        end

        it 'stores the changed the remarks class on the assessment' do
          original_remarks = assessment.remarks.as_json
          described_class.call(assessment, collection)
          expect(assessment.reload.remarks.as_json).not_to eq original_remarks
        end
      end
    end
  end
end
