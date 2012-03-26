require 'test_helper'

class BookTest < ActiveSupport::TestCase
  test "invalid isbn" do
    assert !books(:invalid_isbn).save, "dont accept isbn characters besides numbers"
  end

  test "10 digit isbn" do
    assert books(:_10_digit_isbn).save
  end

  test "13 digit isbn" do
    assert books(:_13_digit_isbn).save
  end
end
