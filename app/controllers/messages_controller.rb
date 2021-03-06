class MessagesController < ApplicationController
  before_filter :authenticate_entrepreneur!
  before_filter :set_user
  
  def index
    if params[:mailbox] == "sent"
      @messages = @entrepreneur.sent_messages
    else
      @messages = @entrepreneur.received_messages
    end
  end
  
  def show
    @message = Message.read_message(params[:id], current_entrepreneur)
  end
  
  def new
    @message = Message.new

    if params[:reply_to]
      @reply_to = @entrepreneur.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @message.to = @reply_to.sender.login
        @message.subject = "Re: #{@reply_to.subject}"
        @message.body = "\n\n*Original message*\n\n #{@reply_to.body}"
      end
    end
  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = @entrepreneur
    @message.recipient = Entrepreneur.find_by_id(params[:message][:to])

    if @message.save
      flash[:notice] = "Message sent"
      redirect_to entrepreneur_messages_path(@entrepreneur)
    else
      render :action => :new
    end
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @entrepreneur, @entrepreneur])
          @message.mark_deleted(@entrepreneur) unless @message.nil?
        }
        flash[:notice] = "Messages deleted"
      end
      redirect_to :back
    end
  end
  
  private
    def set_user
      @entrepreneur = Entrepreneur.find(params[:entrepreneur_id])
    end
end