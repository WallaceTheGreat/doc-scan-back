class Api::V1::DocumentsController < ApplicationController
  def index
    render json: Document.all
  end
end
