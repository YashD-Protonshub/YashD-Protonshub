namespace :assign do
  desc "Will assign Free Coffee"
  task free_coffee: :environment do
    AssignFreeCoffeeService.execute
  end

end
