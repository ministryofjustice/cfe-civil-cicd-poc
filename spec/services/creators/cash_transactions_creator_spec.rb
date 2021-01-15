require 'rails_helper'

describe Creators::CashTransactionsCreator do
  describe '.call' do
    let(:assessment) { create :assessment, :with_gross_income_summary }
    let(:gross_income_summary) { assessment.gross_income_summary }
    let(:income) { params[:income] }
    let(:outgoings) { params[:outgoings] }
    let(:month1) { Date.today.beginning_of_month - 3.months }
    let(:month2) { Date.today.beginning_of_month - 2.months }
    let(:month3) { Date.today.beginning_of_month - 1.months }

    subject { described_class.call(assessment_id: assessment.id, income: income, outgoings: outgoings) }

    context 'happy_path' do
      let(:params) { valid_params }
      let(:expected_category_details) do
        [
          %w[child_care debit],
          %w[maintenance_out debit],
          %w[friends_or_family credit],
          %w[maintenance_in credit]
        ]
      end
      it 'creates the cash transaction category records' do
        expect { subject }.to change { CashTransactionCategory.count }.by(4)
        category_details = gross_income_summary.cash_transaction_categories.pluck(:name, :operation)
        expect(category_details).to match_array expected_category_details
      end

      it 'creates the payment records' do
        expect { subject }.to change { CashTransaction.count }.by(12)
        cat = gross_income_summary.cash_transaction_categories.find_by(name: 'child_care')
        trx_details = cat.cash_transactions.order(:date).pluck(:date, :amount, :client_id)
        expect(trx_details).to eq(
          [
            [month1, 256.0, 'ec7b707b-d795-47c2-8b39-ccf022eae33b'],
            [month2, 257.0, 'ee7b707b-d795-47c2-8b39-ccf022eae33b'],
            [month3, 258.0, 'ff7b707b-d795-47c2-8b39-ccf022eae33b']
          ]
        )
      end

      it 'responds true to #success?' do
        expect(subject.success?).to be true
      end
    end

    context 'unhappy paths' do
      context 'not exactly three occurrences of payments' do
        let(:params) { invalid_params_two_payments }

        it 'does not create any CashTransactionCategory records' do
          expect { subject }.not_to change { CashTransactionCategory.count }
        end

        it 'does not create any CashTransaction records' do
          expect { subject }.not_to change { CashTransaction.count }
        end

        it 'responds false to #success?' do
          expect(subject.success?).to be false
        end

        it 'returns expected errors' do
          expect(subject.errors).to eq ['There must be exactly 3 payments for category maintenance_in']
        end
      end

      context 'not the expected dates' do
        let(:params) { invalid_params_wrong_dates }

        it 'does not create any CashTransactionCategory records' do
          expect { subject }.not_to change { CashTransactionCategory.count }
        end

        it 'does not create any CashTransaction records' do
          expect { subject }.not_to change { CashTransaction.count }
        end

        it 'responds false to #success?' do
          expect(subject.success?).to be false
        end

        it 'returns expected errors' do
          expect(subject.errors).to eq ['Expecting payment dates for category child_care to be 2020-10-01, 2020-11-01, 2020-12-01']
        end
      end
    end

    def valid_params
      {
        income: [
          {
            category: 'maintenance_in',
            payments: [
              {
                date: month1.strftime('%F'),
                amount: 1046.44,
                client_id: '05459c0f-a620-4743-9f0c-b3daa93e5711'
              },
              {
                date: month2.strftime('%F'),
                amount: 1034.33,
                client_id: '10318f7b-289a-4fa5-a986-fc6f499fecd0'
              },
              {
                date: month3.strftime('%F'),
                amount: 1033.44,
                client_id: '5cf62a12-c92b-4cc1-b8ca-eeb4efbcce21'
              }
            ]
          },
          {
            category: 'friends_or_family',
            payments: [
              {
                date: month2.strftime('%F'),
                amount: 250.0,
                client_id: 'e47b707b-d795-47c2-8b39-ccf022eae33b'
              },
              {
                date: month3.strftime('%F'),
                amount: 266.02,
                client_id: 'b0c46cc7-8478-4658-a7f9-85ec85d420b1'
              },
              {
                date: month1.strftime('%F'),
                amount: 250.0,
                client_id: 'f3ec68a3-8748-4ed5-971a-94d133e0efa0'
              }
            ]
          }
        ],
        outgoings:
          [
            {
              category: 'maintenance_out',
              payments: [
                {
                  date: month2.strftime('%F'),
                  amount: 256.0,
                  client_id: '347b707b-d795-47c2-8b39-ccf022eae33b'
                },
                {
                  date: month3.strftime('%F'),
                  amount: 256.0,
                  client_id: '722b707b-d795-47c2-8b39-ccf022eae33b'
                },
                {
                  date: month1.strftime('%F'),
                  amount: 256.0,
                  client_id: 'abcb707b-d795-47c2-8b39-ccf022eae33b'
                }
              ]
            },
            {
              category: 'child_care',
              payments: [
                {
                  date: month3.strftime('%F'),
                  amount: 258.0,
                  client_id: 'ff7b707b-d795-47c2-8b39-ccf022eae33b'
                },
                {
                  date: month2.strftime('%F'),
                  amount: 257.0,
                  client_id: 'ee7b707b-d795-47c2-8b39-ccf022eae33b'
                },
                {
                  date: month1.strftime('%F'),
                  amount: 256.0,
                  client_id: 'ec7b707b-d795-47c2-8b39-ccf022eae33b'
                }
              ]
            }
          ]
      }
    end

    def invalid_params_two_payments
      params = valid_params.clone
      params[:income].first[:payments].pop
      params
    end

    def invalid_params_wrong_dates
      params = valid_params.clone
      params[:outgoings].last[:payments].first[:date] = '2020-05-06'
      params
    end
  end
end
