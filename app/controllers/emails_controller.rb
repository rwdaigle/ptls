class EmailsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :login_required

  def create
    InboundEmailLoader.load!(params['from'], params["subject"])
    # $queue.enqueue('InboundEmailLoader.load!', params['from'], params["subject"])
    render :text => "OK"
  end
end