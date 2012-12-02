# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    amount 1
    debit_from nil
    credit_to nil
    category nil
    description "MyString"
    duration "MyString"
    on "2012-12-01"
  end
end
