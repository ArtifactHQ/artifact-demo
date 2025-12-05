class VersionsController < ApplicationController
  before_action :set_project
  before_action :set_document
  before_action :set_version, only: [:show, :deploy, :rollback]

  def index
    @versions = @document.versions.ordered
  end

  def show
  end

  def deploy
    @version.deploy!
    redirect_to project_document_path(@project, @document), notice: "Version #{@version.version_number} deployed successfully."
  end

  def rollback
    @version.rollback!
    redirect_to project_document_path(@project, @document), notice: "Version #{@version.version_number} rolled back."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_document
    @document = @project.documents.find(params[:document_id])
  end

  def set_version
    @version = @document.versions.find(params[:id])
  end
end
