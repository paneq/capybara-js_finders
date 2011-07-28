require 'test_helper'
require 'unit/find_cell_tests/app/app'

module FindCellTests
  
  class BasicTest < Bbq::TestCase

    attr_reader :user

    setup do
      Capybara.app = App
      Capybara.default_wait_time = 0.1
      @user = Bbq::TestUser.new(:driver => :selenium, :session_name => :default)
    end

    def test_respond_to
      user.visit '/'
      assert user.find('table').respond_to?(:find_cell)
      assert user.respond_to?(:find_cell)
    end

    def test_find_cell
      user.visit '/'

      # First row
      assert user.find_cell(:row => "OneRow", :column => "OneColumn").has_content?("red")
      assert user.find_cell(:row => "OneRow", :column => "OneColumn", :text => "red").has_content?("red")

      assert user.find_cell(:row => "OneRow", :column => "TwoColumns").has_content?("hor")
      assert user.find_cell(:row => "OneRow", :column => "TwoColumns", :text => "hor").has_content?("hor")

      assert user.find_cell(:row => "OneRow", :column => "ThreeColumns").has_content?("CadetBlue")
      assert user.find_cell(:row => "OneRow", :column => "ThreeColumns", :text => "Chocolate").has_content?("Chocolate")

      # Second row
      assert user.find_cell(:row => "TwoRows", :column => "OneColumn").has_content?("ver")
      assert user.find_cell(:row => "TwoRows", :column => "OneColumn", :text => "ver").has_content?("ver")

      assert user.find_cell(:row => "TwoRows", :column => "TwoColumns").has_content?("sqr")
      assert user.find_cell(:row => "TwoRows", :column => "TwoColumns", :text => "sqr").has_content?("sqr")

      assert user.find_cell(:row => "TwoRows", :column => "ThreeColumns").has_content?("Sienna")
      assert user.find_cell(:row => "TwoRows", :column => "ThreeColumns", :text => "Tan").has_content?("Tan")
      assert user.find_cell(:row => "TwoRows", :column => "ThreeColumns", :text => "Tomato").has_content?("Tomato")

      # Third row
      assert user.find_cell(:row => "ThreeRows", :column => "OneColumn").has_content?("Crimson")
      assert user.find_cell(:row => "ThreeRows", :column => "OneColumn", :text => "DarkSalmon").has_content?("DarkSalmon")

      assert user.find_cell(:row => "ThreeRows", :column => "TwoColumns").has_content?("DarkGray")
      assert user.find_cell(:row => "ThreeRows", :column => "TwoColumns", :text => "NavajoWhite").has_content?("NavajoWhite")
      assert user.find_cell(:row => "ThreeRows", :column => "TwoColumns", :text => "DeepPink").has_content?("DeepPink")

      assert user.find_cell(:row => "ThreeRows", :column => "ThreeColumns").has_content?("Tan")
      assert user.find_cell(:row => "ThreeRows", :column => "ThreeColumns", :text => "Green").has_content?("Green")
      assert user.find_cell(:row => "ThreeRows", :column => "ThreeColumns", :text => "SandyBrown").has_content?("SandyBrown")
      assert user.find_cell(:row => "ThreeRows", :column => "ThreeColumns", :text => "DeepPink").has_content?("DeepPink")
      assert user.find_cell(:row => "ThreeRows", :column => "ThreeColumns", :text => "Tan").has_content?("Tan")

      # Test matching multiple rows and columns
      assert user.find_cell(:multicolumn => true, :multirow => true, :row => "Row", :column => "Column").has_content?("red")
      assert user.find_cell(:multicolumn => true, :multirow => true, :row => "Rows", :column => "Columns").has_content?("sqr")
      assert user.find_cell(:multicolumn => true, :multirow => true, :row => "Rows", :column => "Columns", :text => "Tan").has_content?("Tan")
      assert user.find_cell(:multicolumn => true, :multirow => true, :row => "Rows", :column => "Columns", :text => "DeepPink").has_content?("DeepPink")
      assert user.find_cell(:multicolumn => true, :multirow => true, :row => "Rows", :column => "Columns", :text => "Peru").has_content?("Peru")
      assert user.find_cell(:multicolumn => true, :multirow => true, :row => "Rows", :column => "Columns", :text => "Snow").has_content?("Snow")
    end

    def test_find_cell_not_found
      user.visit '/'
      assert_not_found{ user.find_cell(:row => "OneRow", :column => "OneColumn", :text => "hor") }
      assert_not_found{ user.find_cell(:row => "OneRow", :column => "OneColumn", :text => "ver") }

      assert_not_found{ user.find_cell(:row => "ThreeRows", :column => "OneColumn", :text => "DeepPink") }
      assert_not_found{ user.find_cell(:row => "OneRow", :column => "ThreeColumns", :text => "Tan") }
      assert_not_found{ user.find_cell(:multicolumn => false, :multirow => true,  :row => "Rows", :column => "Columns", :text => "SandyBrown") }
      assert_not_found{ user.find_cell(:multicolumn => true,  :multirow => false, :row => "Rows", :column => "Columns", :text => "SandyBrown") }
    end

    def test_find_cell_without_row_or_column
      user.visit '/'
      assert user.find_cell(:row => "OneRow", :text => "red").has_content?("red")
      assert user.find_cell(:column => "OneColumn", :text => "red").has_content?("red")
    end

    def test_does_not_find_row_header_as_a_cell
      user.visit '/'
      assert ! user.find_cell(:row => "January 2012", :text => "12").has_content?("January")
    end

    def test_does_not_find_column_header_as_a_cell
      user.visit '/'
      assert ! user.find_cell(:column => "March 2013", :text => "13").has_content?("March")
    end

    def test_assume_static_page
      user.visit '/'

      red = user.find(:xpath, XPath::HTML.cell("red").to_s )
      attributes = [Capybara::JsFinders::LR, Capybara::JsFinders::RR, Capybara::JsFinders::TR, Capybara::JsFinders::BR]
      attributes.each {|attr| assert_nil red[attr]}

      user.static_page do
        user.find_cell(:row => "OneRow", :column => "OneColumn", :text => "red")
        positions = attributes.map do |attr|
          assert red[attr]
          red[attr]
        end

        user.click_link("Hide me!") # Changes positions of elements

        user.find_cell(:row => "OneRow", :column => "OneColumn", :text => "red") # Find the cell but without recalculating positions because we are inside static_page block
        assert_equal positions, attributes.map{|attr| red[attr] } # Attributes store the same positions as after first find_cell call
      end

      user.find_cell(:row => "OneRow", :column => "OneColumn", :text => "red") # Find the cell but recalculates positions because we are outside of static_page block
      assert_not_equal positions, attributes.map{|attr| red[attr] } # Attributes store different positions than after first find_cell call
    end

    private


    def assert_not_found(&block)
      assert_raise(Capybara::ElementNotFound, &block)
    end

  end
end
