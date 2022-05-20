require "./lib/modules/transactions/transaction_calculation.rb"

class Transaction < ApplicationRecord
  include Transactions::TransactionCalculation

  belongs_to :user
  belongs_to :country
  has_one :reward_point, dependent: :destroy

  after_create :credit_reward_points
  before_save :cash_rebate_for_users


  def credit_reward_points
    if is_a_domestic_transaction? && amount >= config_for_transaction.standard_amount
      self.create_reward_point(user_id: user.id, point: reward_points)
    elsif is_a_international_transaction?
      self.create_reward_point(user_id: user.id, point: reward_points)
    end

    # Checking for points and adding rewards if eligible
    check_and_assign_reward

  end

  def cash_rebate_for_users
    set_cash_rebate_slot_for_user_and_calculate
  end

  private

  def is_a_domestic_transaction?
    user.country == country
  end

  def is_a_international_transaction?
    user.country != country
  end

  def check_and_assign_reward
    # Here we are adding a Free Coffe Reward if user accumulates 100 points in 1 calender month.
    # We can again make it dynamic by storing values in model as we did for other rewards and for crediting reward points
     AssignFreeCoffeeService.execute(user, true) if eligible_for_free_coffee?
     AssignFreeMovieTicketService.execute(user)
  end

  def eligible_for_free_coffee?
    user.reward_points.where("DATE(created_at) BETWEEN ? AND ?", (Date.today - 1.month), Date.today).sum(:point) >= 100
  end
end
