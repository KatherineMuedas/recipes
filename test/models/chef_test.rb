require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(name: "Rafo", email: "rafo@gmail.com")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.name = ""
    assert_not @chef.valid?
  end

  test  "chef name should be less than 30 characters" do
    @chef.name = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = ""
    assert_not @chef.valid?
  end

  test "email should not be too long" do
    @chef.email = "a" * 245 + "@example.com"
    assert_not @chef.valid?
  end

  test "email should accept correct format" do
    valid_emails = %w[user@example.com MASHRUR@gmail.com M.first@yahoo.ca john+smith@co.uk.org]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid."
    end
  end

  test  "should reject invalid emails" do
    invalid_emails = %w[MASHRUR@example mashrur@example,com mashrur@gmail. joe@bar+foo.com ]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
      binding
    end

  end

    test "emails should be unique and case insensitive" do
      duplicate_chef = @chef.dup
      duplicate_chef.email = @chef.email.upcase
      @chef.save
      assert_not duplicate_chef.valid?
    end

    test "email should be lower case before hitting db" do
      mixed_email = "John@Example.com"
      @chef.email = mixed_email
      @chef.save
      assert_equal mixed_email.downcase, @chef.reload.email
    end
end
