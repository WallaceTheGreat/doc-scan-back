class Api::V1::DocumentsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :search]
  before_action :set_document, only: [:show, :update, :destroy]
  before_action :authorize_owner, only: [:update, :destroy]
  
  # GET /api/v1/documents
  def index
    render json: Document.all
  end

  # GET /api/v1/documents/:id
  def show
    render json: @document
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

  # POST /api/v1/documents
  def create
    document = current_user.documents.build(document_params)
    
    if document.save
      render json: document, status: :created
    else
      render json: { errors: document.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/documents/:id
  def update
    if @document.update(document_params)
      render json: @document
    else
      render json: { errors: @document.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/documents/:id
  def destroy
    @document.destroy
    head :no_content
  end

  private

  def set_document
    @document = Document.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Document not found' }, status: :not_found
  end

  def authorize_owner
    unless @document.created_by == current_user.id
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
    end
  end

  def document_params
    params.require(:document).permit(:title, :path)
  end
end
