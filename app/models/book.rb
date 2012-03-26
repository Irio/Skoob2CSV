class Book < ActiveRecord::Base
  validates :isbn, presence: true, numericality: {only_integer: true}
end
