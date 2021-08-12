class ChecksController < ApplicationController
  def update
    @task = Task.find(params[:task_id])
    if @task.pratical == "実施済"
      @task.update_attribute(:pratical, "未実施")
      # @task.update(pratical:true)
    else
      @task.update_attribute(:pratical, "実施済")
    end
  end
end
