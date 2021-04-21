require 'rails_helper'

module Decorators
  module V4
    RSpec.describe Decorators::V4::GrossIncomeDecorator do
      let(:assessment) { create :assessment }
      let(:summary) do
        create :gross_income_summary,
               assessment: assessment,
               monthly_student_loan: 250,
               benefits_all_sources: 1_322.6,
               benefits_bank: 1_322.6,
               maintenance_in_all_sources: 350,
               maintenance_in_bank: 200,
               maintenance_in_cash: 150,
               friends_or_family_all_sources: 50,
               friends_or_family_cash: 50,
               property_or_lodger_all_sources: 250,
               property_or_lodger_bank: 250
      end
      let(:universal_credit) { create :state_benefit_type, :universal_credit }
      let(:child_benefit) { create :state_benefit_type, :child_benefit }
      let(:expected_results) do
        {
          irregular_income: {
            monthly_equivalents:
              {
                student_loan: 250.0
              }
          },
          state_benefits: {
            monthly_equivalents: {
              all_sources: 1322.6,
              cash_transactions: 0.0,
              bank_transactions: [
                {
                  name: 'Universal Credit',
                  monthly_value: 979.33,
                  excluded_from_income_assessment: false
                },
                {
                  name: 'Child Benefit',
                  monthly_value: 343.27,
                  excluded_from_income_assessment: false
                }
              ]
            }
          },
          other_income: {
            monthly_equivalents: {
              all_sources: {
                friends_or_family: 50.0,
                maintenance_in: 350.0,
                property_or_lodger: 250.0,
                pension: 0.0
              },
              bank_transactions: {
                friends_or_family: 0.0,
                maintenance_in: 200.0,
                property_or_lodger: 250.0,
                pension: 0.0
              },
              cash_transactions: {
                friends_or_family: 50.0,
                maintenance_in: 150.0,
                property_or_lodger: 0.0,
                pension: 0.0
              }
            }
          }
        }
      end

      describe '#as_json' do
        before do
          create :state_benefit, state_benefit_type: universal_credit, gross_income_summary: summary, monthly_value: 979.33
          create :state_benefit, state_benefit_type: child_benefit, gross_income_summary: summary, monthly_value: 343.27
        end

        subject { described_class.new(assessment).as_json }

        it 'returns the expected structure' do
          expect(subject).to eq expected_results
        end
      end
    end
  end
end
