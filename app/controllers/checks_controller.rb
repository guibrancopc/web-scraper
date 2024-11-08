class ChecksController < ApplicationController
    before_action :set_page

    def create 
        @page.check_and_notify
        redirect_to @page
    end

    private

    def set_page
        @page = Page.find(params[:page_id])
    end
end
