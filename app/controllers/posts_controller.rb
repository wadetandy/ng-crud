class PostsController < ApplicationController
  respond_to :json

  # GET /posts.json
  def index
    respond_with Post.all
  end

  # GET /posts/1.json
  def show
    respond_with Post.find(params[:id])
  end

  # GET /posts/new
  def new
    respond_with Post.new
  end

  # POST /posts.json
  def create
    post = Post.new(post_params)

    if post.save
      respond_with post, status: :created
    else
      format.json { render json: post.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /posts/1.json
  def update
    post = Post.find(params[:id])

    if post.update(post_params)
      respond_with post, status: :ok
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1.json
  def destroy
    post = Post.find(params[:id])
    post.destroy

    head :no_content
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :published)
  end
end
