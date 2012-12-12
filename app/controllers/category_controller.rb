class CategoryController < ApplicationController
  before_filter :authenticate_user!
  def index
    @categories = Category.all(:conditions => {:category_id => nil})
  end
end
