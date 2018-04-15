class AssessmentsController < ApplicationController
  skip_before_action :check_attr

  def update
    assessment = Assessment.find_by(uid: params[:id])
    assessment.update(blend_name: assessment.blend.name)
    render nothing: true
  end
end
