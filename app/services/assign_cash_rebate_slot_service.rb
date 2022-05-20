class AssignCashRebateSlotService
  def initialize(user)
    @user = user
  end

  def execute
    user_cash_rebate_slot = nil
    CashRebate.all.each do |cash_rebate|
      user_cash_rebate_slot = cash_rebate if eligible_for_cash_rebate_slot?(@user, cash_rebate)
    end
    @user.update_column("cash_rebate_id", user_cash_rebate_slot&.id)
  end

  def eligible_for_cash_rebate_slot?(user, cash_rebate)
    user.transactions.where("amount >= ?", cash_rebate.of_amount).count >= cash_rebate.on_transactions
  end
end
