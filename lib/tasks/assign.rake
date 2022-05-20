namespace :assign do
  desc "TODO"
  task free_coffee: :environment do
    AssignFreeCoffeeService.execute
  end

end
