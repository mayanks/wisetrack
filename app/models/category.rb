class Category < ActiveRecord::Base
  belongs_to :category
  has_many :categories
  attr_accessible :name

  def self.income_categories
    Category.find_by_name('income').categories
  end

  def self.expense_categories
    Category.all(:conditions => ["name != 'income' and category_id is null"])
  end
end
