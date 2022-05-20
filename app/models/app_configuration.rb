# Here we will store values for Global use. 
# For example if need to set standard reward point that a user will get on transactions. 

class AppConfiguration < ApplicationRecord
  RECEIVE_POINTS_FOR_DOMESTIC = "receive_points_for_domestic"
  RECEIVE_POINTS_FOR_INTERNATIONAL = "receive_points_for_international"

  enum valid_for: ["Domestic", "International", "Both"]
end
