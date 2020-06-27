class ArticlesController < ApplicationController
 before_action :load_articles, except: [:destroy] 
 before_action :load_my_articles, only: [:my]
 #before_action :load_article, only: [:destroy, :update]

	def index
    # before_action
	end

  def my
    # before_action
  end

  def show
   # article_param = params[:article_id]
    binding.pry
    @article = Article.find(params[:article_id])
    @comments = @article.comments.desc(:created_at).page(params[:page]).per(10)
    prepare_meta_tags(title: @article.title,
                      description: @article.text,
                      keywords: @article.keywords)
  end

  def edit
    @page_title       = 'Edit Article'
  end

  def create
    # Use Jinda $xvars
    @article = Article.new(
                      title: $xvars["form_article"]["title"],
                      text: $xvars["form_article"]["text"],
                      keywords: $xvars["form_article"]["keywords"],
                      body: $xvars["form_article"]["body"],
                      user_id: $xvars["user_id"])
    @article.save!
  end

  def update
    # Use Jinda $xvars
		article_id = $xvars["select_article"] ? $xvars["select_article"]["title"] : $xvars["p"]["article_id"]

    @article.update(title: $xvars["edit_article"]["article"]["title"],
                    text: $xvars["edit_article"]["article"]["text"],
                    keywords: $xvars["edit_article"]["article"]["keywords"],
                    body: $xvars["edit_article"]["article"]["body"]
										)
  end

  def destroy
    # Use Rails 
    # before_action

    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @article.user
      @article.destroy
    end
    redirect_to :action=>'my'

  end

  private
  def load_articles
    @articles = Article.desc(:created_at).page(params[:page]).per(10)
  end

  def load_my_articles
    @my_articles = @articles.where(user: current_ma_user)
  end

  def load_article
    @article = Article.find(params.require(:article).permit(:article_id))
  end

  def article_params
    params[:article_id]
  end

  def load_edit_article
    @article = Article.find(params.require(:article).permit(:article_id))
  end

  def load_comments
    @comments = @article.comments.find_all
  end

end
