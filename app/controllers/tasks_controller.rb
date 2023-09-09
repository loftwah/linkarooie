class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy move]

  def index
    @tasks = current_user.tasks
  end

  def all_tasks
    @tasks = current_user.tasks
  end  

  def show
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully destroyed.'
  end

  def move
    # Fetch the task to move
    task = Task.find(params[:id])
  
    # Check if there's another task with the new position in the new status
    overlapping_task = Task.where(user_id: current_user.id, status: task_params[:status], position: task_params[:position]).first
  
    # If there's an overlapping task, increment the positions of all tasks from the overlapping position onward
    if overlapping_task
      Task.where(user_id: current_user.id, status: task_params[:status])
          .where("position >= ?", task_params[:position])
          .order(position: :desc)
          .each do |t|
            t.update!(position: t.position + 1)
          end
    end
  
    # Update the moved task's status and position
    if task.update(task_params)
      render json: { status: "success" }
    else
      render json: { status: "error", message: task.errors.full_messages.join(", ") }
    end
  end    

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :status, :priority, :category, :position)
  end
end
