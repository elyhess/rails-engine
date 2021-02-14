class ApplicationController < ActionController::API
	include ActionController::Helpers
	helper_method :paginate

	rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
	rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

	def render_unprocessable_entity_response(exception)
		render json: exception.record.errors, status: :bad_request
	end

	def render_not_found_response(exception)
		render json: { error: exception.message }, status: :not_found
	end

	def paginate(items)
		page = [params.fetch(:page, 1).to_i, 1].max
		per_page = [params.fetch(:per_page, 20).to_i, 1].max
		items.limit(per_page).offset((page - 1) * per_page)
	end

end
