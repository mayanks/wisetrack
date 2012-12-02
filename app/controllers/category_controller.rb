class CategoryController < ApplicationController
  def index
    @categories = Category.all(:conditions => {:category_id => nil})
  end
end
