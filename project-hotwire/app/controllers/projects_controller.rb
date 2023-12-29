class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = Project.all
    @project = Project.new
  end

  def show
    @task = @project.tasks.build
    @tasks = @project.tasks
  end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if save_project_and_redirect(format)
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
      else
        handle_save_failure(format)
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy!
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def save_project_and_redirect(format)
    if @project.save
      true
    else
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@project, partial: 'projects/form', locals: { project: @project })
      end
      false
    end
  end

  def handle_save_failure(format)
    format.html { render :new, status: :unprocessable_entity }
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:content, :vote)
  end
end
