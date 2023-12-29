class TasksController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project, only: %i[create edit]
  before_action :set_task, only: %i[update edit destroy]

  def create
    @task = @project.tasks.build(tasks_params)

    if @task.save
      flash[:notice] = 'Task successfully created!'
      redirect_to_project_with_notice('Task was successfully created', @project)
    else
      flash[:alert] = 'Task has not been created!'
      render 'project/show'
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @task.update(tasks_params)
        redirect_to_project_with_notice('Task was successfully updated', @task.project, format)
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
      redirect_to_project_with_notice('Task was successfully deleted', @task.project, format)
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_project
    @project = Project.find_by(id: params[:project_id])
  end

  def tasks_params
    params.require(:task).permit(:body, :status)
  end

  def redirect_to_project_with_notice(notice_message, project, format = nil)
    if format
      format.html { redirect_to [project], notice: notice_message }
    else
      redirect_to [project], notice: notice_message
    end
  end
end
