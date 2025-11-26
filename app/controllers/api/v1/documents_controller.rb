class Api::V1::DocumentsController < ApplicationController
  
  # GET /api/v1/documents
  def index
    render json: Document.all
  end

  # GET /api/v1/documents/search?q=...
  def search
    query = params[:q]
    if query.present?
      results = Document.where("title ILIKE ?", "%#{query}%")
      render json: results
    else
      render json: { error: "Query param 'q' missing" }, status: :bad_request
    end
  end
end
