class DependantsController < ApplicationController
  def create
    if creation_service.success?
      render_success
    else
      render_unprocessable(creation_service.errors)
    end
  end

private

  def creation_service
    @creation_service ||= Creators::DependantsCreator.call(
      assessment_id: params[:assessment_id],
      dependants_params: request.raw_post,
    )
  end
end
