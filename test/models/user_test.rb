require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: 'Example user', email: 'example@gmail.com',
							password: 'foobar', password_confirmation: 'foobar')
	end

	test 'Should be valid' do
		assert @user.valid?
	end

	test 'name should be presence' do
		@user.name = '     '
		assert_not @user.valid?
	end

	test 'email should be presence' do
		@user.email = '    '
		assert_not @user.valid?
	end

	test 'username should not be too long' do
		@user.name = "a" *51
		assert_not @user.valid?
	end

	test 'email should not be too long' do
		@user.email = 'a' * 254 + "@gmail.com"
		assert_not @user.valid?
	end

	test 'email validation should accept valid email address' do
		valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |adr|
			@user.email = adr
			assert @user.valid?, "#{adr.inspect} should be valid" 
		end
	end 
	# test for valid address model

	test 'email should reject invalid email address' do 
	    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |adr|
			@user.email = adr
			assert_not @user.valid?, "#{adr.inspect} should be invalid address"
		end
	end
	# if emails is invalid, assert true -> bc of validates in model

	# if user is unique, assert true
	test 'email address should be unique' do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end		
	# create a user with the same email address which create a user with the same attribute
	# if model have uniqueness:true attr, then duplicate_user.valid? -> false, makes assert_not -> true
	# dup_user email with uppercase should return false since validates uniqueness is case-insensitive, assert_not -> true

	test 'email address should be downcase' do
		mixed_case_email = 'Fooz@ExaMple.com'
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	test 'password should be present (nonblank)' do
		@user.password = @user.password_confirmation = ' ' * 6
		assert_not @user.valid?
	end

	test 'password should have a minimum length' do 
		@user.password = @user.password_confirmation = 'a'* 5
		assert_not @user.valid?
	end
end
