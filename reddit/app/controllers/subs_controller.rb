class SubsController < ApplicationController
    before_action :require_logged_in, except: [:show, :index]

    def index
        @subs = Sub.all
        render :index
    end

    def show
        @sub = Sub.find_by(id: params[:id])
        render :show
    end

    def edit
        @sub ||= Sub.find_by(id: params[:id])
        if @sub && current_user.id == @sub.moderator_id
            render :edit
        else
            flash[:errors] = @sub.errors.full_messages
            redirect_to subs_url
        end
    end

    def update
        if @sub.update(sub_params)
            redirect_to sub_url(@sub)
        else
            flash.now[:errors] = @sub.errors_full_messages
            render :edit
        end
    end
    def new
        @sub = Sub.new
        render :new
    end
    def create
        @sub = Sub.new(sub_params)
        @sub.moderator_id = current_user.id
        if @sub.save
            redirect_to sub_url(@sub)
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :new
        end
    end

    private
    def sub_params
        params.require(:sub).permit(:title, :description)
    end
end
