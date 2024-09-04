# app/controllers/waiting_lists_controller.rb
class WaitingListsController < ApplicationController
  def create
    @waiting_list = WaitingList.new(waiting_list_params)
    
    if @waiting_list.save
      flash[:notice] = "Thanks for joining our waiting list!"
    else
      error_message = @waiting_list.errors.full_messages.to_sentence
      flash[:alert] = "There was an error: #{error_message}"
    end
    redirect_to root_path
  end

  private

  def waiting_list_params
    params.require(:waiting_list).permit(:email)
  end
end