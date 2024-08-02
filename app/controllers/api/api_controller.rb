module Api
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    private

    def record_not_found
      render json: { message: 'Record not found' }, status: :not_found
    end
  end
end
