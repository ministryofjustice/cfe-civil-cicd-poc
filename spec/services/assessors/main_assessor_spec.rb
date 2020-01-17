require 'rails_helper'

module Assessors
  RSpec.describe MainAssessor do
    let(:assessment) { create :assessment, :with_capital_summary, :with_gross_income_summary, :with_disposable_income_summary, :with_applicant }

    context 'passported' do
      before { assessment.applicant.update!(receives_qualifying_benefit: true) }

      it 'gives the expected results' do
        expect(%w[eligible contribution_required contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible contribution_required eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible contribution_required ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible contribution_required pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[eligible eligible contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible eligible eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible eligible ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible eligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[eligible ineligible contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible ineligible eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible ineligible ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible ineligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[eligible pending contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible pending eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible pending ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[eligible pending pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[ineligible contribution_required contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible contribution_required eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible contribution_required ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible contribution_required pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[ineligible eligible contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible eligible eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible eligible ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible eligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[ineligible ineligible contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible ineligible eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible ineligible ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible ineligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[ineligible pending contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible pending eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible pending ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[ineligible pending pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[pending contribution_required contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending contribution_required eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending contribution_required ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending contribution_required pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[pending eligible contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending eligible eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending eligible ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending eligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[pending ineligible contribution_required]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending ineligible eligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending ineligible ineligible]).to have_assessment_error(assessment, 'Invalid assessment status: for passported applicant')
        expect(%w[pending ineligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[pending pending contribution_required]).to have_main_assessment_result(assessment, 'contribution_required')
        expect(%w[pending pending eligible]).to have_main_assessment_result(assessment, 'eligible')
        expect(%w[pending pending ineligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[pending pending pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
      end
    end

    context 'not passported' do
      before { assessment.applicant.update!(receives_qualifying_benefit: false) }

      it 'gives the expected results' do
        expect(%w[eligible contribution_required contribution_required]).to have_main_assessment_result(assessment, 'contribution_required')
        expect(%w[eligible contribution_required eligible]).to have_main_assessment_result(assessment, 'contribution_required')
        expect(%w[eligible contribution_required ineligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[eligible contribution_required pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[eligible eligible contribution_required]).to have_main_assessment_result(assessment, 'contribution_required')
        expect(%w[eligible eligible eligible]).to have_main_assessment_result(assessment, 'eligible')
        expect(%w[eligible eligible ineligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[eligible eligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Capital assessment still pending')
        expect(%w[eligible ineligible contribution_required]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[eligible ineligible eligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[eligible ineligible ineligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[eligible ineligible pending]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[eligible pending contribution_required]).to have_assessment_error(assessment, 'Assessment not complete: Disposable Income assessment still pending')
        expect(%w[eligible pending eligible]).to have_assessment_error(assessment, 'Assessment not complete: Disposable Income assessment still pending')
        expect(%w[eligible pending ineligible]).to have_assessment_error(assessment, 'Assessment not complete: Disposable Income assessment still pending')
        expect(%w[eligible pending pending]).to have_assessment_error(assessment, 'Assessment not complete: Disposable Income assessment still pending')
        expect(%w[ineligible contribution_required contribution_required]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible contribution_required eligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible contribution_required ineligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible contribution_required pending]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible eligible contribution_required]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible eligible eligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible eligible ineligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible eligible pending]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible ineligible contribution_required]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible ineligible eligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible ineligible ineligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible ineligible pending]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible pending contribution_required]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible pending eligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible pending ineligible]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[ineligible pending pending]).to have_main_assessment_result(assessment, 'ineligible')
        expect(%w[pending contribution_required contribution_required]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending contribution_required eligible]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending contribution_required ineligible]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending contribution_required pending]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending eligible contribution_required]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending eligible eligible]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending eligible ineligible]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending eligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending ineligible contribution_required]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending ineligible eligible]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending ineligible ineligible]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending ineligible pending]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending pending contribution_required]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending pending eligible]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending pending ineligible]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
        expect(%w[pending pending pending]).to have_assessment_error(assessment, 'Assessment not complete: Gross Income assessment still pending')
      end
    end
  end
end
