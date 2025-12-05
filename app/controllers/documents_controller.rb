class DocumentsController < ApplicationController
  before_action :set_project
  before_action :set_document, only: [:show, :edit, :update, :destroy, :commit_version, :preview]

  def index
    @documents = @project.documents.recent
  end

  def show
    @versions = @document.versions.ordered
  end

  def new
    @document = @project.documents.new
  end

  def create
    @document = @project.documents.new(document_params)
    
    if @document.save
      redirect_to project_document_path(@project, @document), notice: 'Document was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @document.update(document_params)
      redirect_to project_document_path(@project, @document), notice: 'Document was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to project_path(@project), notice: 'Document was successfully deleted.'
  end

  def commit_version
    commit_message = params[:commit_message] || 'Version update'
    @document.create_new_version(commit_message: commit_message)
    redirect_to project_document_path(@project, @document), notice: 'New version committed successfully.'
  end

  def preview
    # This will render the preview of what the AI would generate
    render :preview
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_document
    @document = @project.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :content, :document_type)
  end
end
