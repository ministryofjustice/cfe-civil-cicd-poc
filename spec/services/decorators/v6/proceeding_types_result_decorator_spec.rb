require "rails_helper"

module Decorators
  module V6
    RSpec.describe ProceedingTypesResultDecorator do
      let(:proceeding_types) { [%w[DA003 A], %w[DA005 Z], %w[SE013 W]] }
      let(:assessment) { create :assessment, proceedings: proceeding_types }

      let(:results) do
        assessment.proceeding_types.map do |pt|
          Eligibility::GrossIncome.new proceeding_type: pt, assessment_result: "eligible", upper_threshold: 27
        end
      end

      subject(:decorator) { described_class.new(results).as_json }

      describe "#as_json" do
        it "returns an array with three elements" do
          expect(decorator).to eq expected_result
        end
      end

      def expected_result
        [
          {
            ccms_code: "DA003",
            client_involvement_type: "A",
            upper_threshold: 27.0,
            lower_threshold: 0.0,
            result: "eligible",
          },
          {
            ccms_code: "DA005",
            client_involvement_type: "Z",
            upper_threshold: 27.0,
            lower_threshold: 0.0,
            result: "eligible",
          },
          {
            ccms_code: "SE013",
            client_involvement_type: "W",
            upper_threshold: 27.0,
            lower_threshold: 0.0,
            result: "eligible",
          },
        ]
      end
    end
  end
end
