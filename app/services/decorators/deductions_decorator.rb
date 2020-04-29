module Decorators
  class DeductionsDecorator
    def initialize(disposable_income_summary)
      @record = disposable_income_summary
    end

    def as_json
      {
        dependants_allowance: @record.dependant_allowance,
        disregarded_state_benefits: DisregardedStateBenefitsCalculator.call(@record)
      }
    end
  end
end
