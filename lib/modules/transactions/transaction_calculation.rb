module Transactions
  module TransactionCalculation
    
    def config_for_transaction
      if is_a_domestic_transaction?
        @config_for_transaction ||= AppConfiguration.find_by_reward_type(AppConfiguration::RECEIVE_POINTS_FOR_DOMESTIC)
      else
        @config_for_transaction ||= AppConfiguration.find_by_reward_type(AppConfiguration::RECEIVE_POINTS_FOR_INTERNATIONAL)
      end
    end

    def reward_points
      if is_a_domestic_transaction?
        (amount/config_for_transaction.standard_amount).to_i * config_for_transaction.standard_reward_points
      else
        ((amount/config_for_transaction.standard_amount) * config_for_transaction.standard_reward_points).to_i
      end
    end

    def calculate_payable_amount
      percentage = user.cash_rebate.percentage
      self.amount -= self.amount * (percentage/100)
    end

    def set_cash_rebate_slot_for_user_and_calculate
      AssignCashRebateSlotService.new(user).execute
      calculate_payable_amount if user.cash_rebate.present?
    end
  end
end