namespace :seed do
  task :category => :environment do
    data = File.read(Rails.root.join('doc/category.yml'))
    y_data = YAML.load(data)
    y_data["categories"].each do |a| 
      c_name = a.keys[0]
      puts " - " + c_name
      c = Category.create(:name => c_name)
      next unless a[c_name]
      a[c_name].each do |b|
        puts "   - " + b
        c.categories.create(:name => b)
      end
    end
  end

  task :accounts => :environment do
    data = File.read(Rails.root.join('doc/accounts.yml'))
    y_data = YAML.load(data)
    y_data["accounts"].each do |a| 
      c_name = a.keys[0]
      puts " - " + c_name
      a[c_name].each {|x,y| puts "#{x} => #{y}"}
      Account.create!(a[c_name])
    end
  end

end

