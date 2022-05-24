require 'rails_helper'

RSpec.describe Transaction, type: :model do
  before(:all) do 
    @domestic_country  = Country.find_or_create_by(name: "India")
    @international_country  = Country.find_or_create_by(name: "China")

    ["Free Coffee", "Free Movie Ticket", "4x Airport Lounge Access Reward"].each do |reward|
      Reward.find_or_create_by(name: reward)
    end
    CashRebate.find_or_create_by(percentage: 5, on_transactions: 10, of_amount: 100)
    AppConfiguration.find_or_create_by(reward_type: AppConfiguration::RECEIVE_POINTS_FOR_DOMESTIC, standard_reward_points: 10, standard_amount: 100, valid_for: 0)
    AppConfiguration.find_or_create_by(reward_type: AppConfiguration::RECEIVE_POINTS_FOR_INTERNATIONAL, standard_reward_points: 20, standard_amount: 100, valid_for: 1)
  end

  context "For every $100 the end user spends they receive 10 points for domestic transaction" do
    it "For every $100 the end user spends user should receive 10 points for domestic transaction" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      transaction = user.transactions.create(amount: 100, country_id: @domestic_country.id)
      expect(transaction.reward_point.present?).to eq true
      expect(transaction.reward_point.point).to eq 10
    end

    it "For every less than $100 the end user spends they should not receive any points for domestic transaction" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      transaction = user.transactions.create(amount: 80, country_id: @domestic_country.id)
      expect(transaction.reward_point.present?).to eq false
    end
  end

  context "If the end user spends any amount of money in a foreign country they receive 2x the standard points" do
    it "If the end user spends any amount of money in a foreign country they receive 2x the standard points" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      transaction = user.transactions.create(amount: 100, country_id: @international_country.id)
      expect(transaction.reward_point.present?).to eq true
      expect(transaction.reward_point.point).to eq 20
    end
  end

  context "If the end user accumulates 100 points in one calendar month they are given a Free Coffee reward" do
    it "If the end user accumulates 100 points in one calendar month they are given a Free Coffee reward" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      (Date.today.beginning_of_month..Date.today.beginning_of_month + 9.days).each do |date|
        transaction = user.transactions.create(amount: 100, country_id: @international_country.id, created_at: date, updated_at: date)
      end
      reward = Reward.find_by(name: "Free Coffee")
      expect(user.rewards.include?(reward)).to eq true
    end
  end

  context "A Free Coffee reward is given to all users during their birthday month" do
    it "A Free Coffee reward is given to all users during their birthday month" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      AssignFreeCoffeeService.execute
      reward = Reward.find_by(name: "Free Coffee")
      expect(user.rewards.include?(reward)).to eq true
    end
  end

  context "A 5% Cash Rebate reward is given to all users who have 10 or more transactions that have an amount > $100" do
    it "A 5% Cash Rebate reward is given to all users who have 10 or more transactions that have an amount > $100" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      (Date.today.beginning_of_month..Date.today.beginning_of_month + 10.days).each do |date|
        transaction = user.transactions.create(amount: 101, country_id: @international_country.id, created_at: date, updated_at: date)
      end
      reward = CashRebate.find_by(percentage: 5.0, on_transactions: 10, of_amount: 100)
      expect(user.cash_rebate_id).to eq reward.id
    end
  end

  context "A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction" do
    it "A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      (Date.today.beginning_of_month..Date.today.beginning_of_month + 10.days).each do |date|
        transaction = user.transactions.create(amount: 101, country_id: @international_country.id, created_at: date, updated_at: date)
      end
      reward =  Reward.find_by(name: "Free Movie Ticket")
      expect(user.rewards.include?(reward)).to eq true
    end
  end

  context "A standard tier customer is an end user who accumulates 0 points" do
    it "A standard tier customer is an end user who accumulates 0 points" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      (Date.today.beginning_of_month..Date.today.beginning_of_month + 10.days).each do |date|
        transaction = user.transactions.create(amount: 50, country_id: @international_country.id, created_at: date, updated_at: date)
      end
      expect(user.tier).to eq "Standard"
    end
  end


  context "A gold tier customer is an end user who accumulates 1000 points" do
    it "A gold tier customer is an end user who accumulates 1000 points" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      transaction = user.transactions.create(amount: 7000, country_id: @international_country.id)
      expect(user.reload.tier).to eq "Gold"
      reward = Reward.find_or_create_by(name: "4x Airport Lounge Access Reward")
      expect(user.rewards.include?(reward)).to eq true
    end
  end


  context "A platinum tier customer is an end user who accumulates 5000 points" do
    it "A platinum tier customer is an end user who accumulates 5000 points" do
      user = User.create(first_name: "consumer", email: "consumer@yopmail.com", dob: Date.today, country_id: @domestic_country.id)
      transaction = user.transactions.create(amount: 50000, country_id: @international_country.id)
      expect(user.reload.tier).to eq "Platinum"
    end
  end
end
