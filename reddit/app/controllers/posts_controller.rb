class PostsController < ApplicationController
    before_action :require_logged_in, except [:show, :index]
    def edit
        @post ||= Post.find_by(id:params[:id])
        if @post && @post.author_id == @current_user.id
            render :edit
        else
            flash[:errors] = ["This is not your post"]
            redirect_to post_url(@post)
        end
    end
    def update
        if @post.update(post_params)
            redirect_to post_url(@post)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :edit
        end
    end
    def show
        @post = Post.find_by(id: params[:id])
        render :show
    end
    def index
        @posts = Post.where(sub_id:params[:sub_id])
        render :index
    end
    def new
        @post = Post.new
        render :new
    end
    def create
        @post = Post.new(post_params)
        @post.author_id = @current_user.id
        if @post.save
            redirect_to post_url(@post)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :new
        end
    end
    private
    def post_params
        params.require(:post).permit(:title, :url, :content, :sub_id)
    end
end
