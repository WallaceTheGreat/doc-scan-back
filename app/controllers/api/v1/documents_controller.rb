class Api::V1::DocumentsController < ApplicationController
  
  # GET /api/v1/documents
  def index
    render json: Document.all
  end

  # GET /api/v1/documents/search?q=...
  def search
    query = params[:q]
    if query.blank?
      return render json: { error: "Query param 'q' missing" }, status: :bad_request
    end

    # remove leading zeros if any
    numeric_id = query.to_i if query.match?(/\A0*\d+\z/)

    results = Document.where("title ILIKE ?", "%#{query}%")
    results = results.or(Document.where(id: numeric_id)) if numeric_id

    render json: results
  end
end
