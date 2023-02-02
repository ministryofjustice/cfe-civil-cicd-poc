# frozen_string_literal: true

require "rails_helper"
require "swagger_parameter_helpers"

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join("swagger")

  api_description = <<~DESCRIPTION.chomp
    # Check financial eligibility for legal aid.

    ## Usage:
      - Create an assessment by POSTing a payload to `/assessments`
        and store the `assessment_id` returned.
      - Add assessment components, such as applicant, capitals and properties using the
        `assessment_id` from the first call
      - Retrieve the result using the GET `/assessments/{assessment_id}`
  DESCRIPTION

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    "v5/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "API V5",
        description: api_description,
        contact: {
          name: "Github repository",
          url: "https://github.com/ministryofjustice/cfe-civil",
        },
        version: "v5",
      },
      components: {
        schemas: {
          ProceedingTypeResult: {
            type: :object,
            required: %i[ccms_code client_involvement_type upper_threshold lower_threshold result],
            properties: {
              ccms_code: {
                type: :string,
                enum: CFEConstants::VALID_PROCEEDING_TYPE_CCMS_CODES,
                description: "The code expected by CCMS",
              },
              client_involvement_type: {
                type: :string,
                enum: CFEConstants::VALID_CLIENT_INVOLVEMENT_TYPES,
                example: "A",
                description: "The client_involvement_type expected by CCMS",
              },
              upper_threshold: { type: :number },
              lower_threshold: { type: :number },
              result: {
                type: :string,
                enum: %w[eligible ineligible contribution_required],
              },
            },
          },
        },
      },
      paths: {},
    },
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml

  # mixin custom application specific swagger helpers
  config.extend SwaggerParameterHelpers, type: :request
end
