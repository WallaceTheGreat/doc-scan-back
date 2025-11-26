include Rails.application.routes.url_helpers

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

    def create
        doc = Document.new(document_params)

        if doc.save
            render json: doc, status: :created
        else
            render json: { errors: doc.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def upload
        unless params[:file]
            return render json: { error: "No file!" }, status: :bad_request
        end

        uploaded = params[:file]
        filename = "#{SecureRandom.uuid}#{File.extname(uploaded.original_filename)}"
        save_path = Rails.root.join("public", "uploads", filename)

        FileUtils.mkdir_p(File.dirname(save_path))
        File.open(save_path, "wb") { |f| f.write(uploaded.read) }

        render json: { path: "/uploads/#{filename}" }, status: :created

    end

    private

    def document_params
        params.require(:document).permit(:title, :created_by)
    end

end
