require 'test_helper'

class FindCellTest < Bbq::TestCase

  class App < Sinatra::Base
    set :views,  File.join(  File.expand_path( File.dirname(__FILE__) ),  'views'  )
    set :public, File.join(  File.expand_path( File.dirname(__FILE__) ),  'public'  )
    get "/" do
      erubis :table
    end
  end

  setup do
    Capybara.app = App
  end

#  def test_respond_to
#    user = Bbq::TestUser.new(:driver => :selenium, :session_name => :default)
#    user.visit '/'
#    assert user.find('table').respond_to?(:find_cell)
#    assert user.respond_to?(:find_cell)
#  end

  def test_find_cell
    user = Bbq::TestUser.new(:driver => :selenium, :session_name => :default)
    user.visit '/'

    # First row
    assert user.find_cell(:row => "OneRow", :column => "OneColumn").has_content?("red")
    assert user.find_cell(:row => "OneRow", :column => "OneColumn", :text => "red").has_content?("red")

    assert user.find_cell(:row => "OneRow", :column => "TwoColumns").has_content?("hor")
    assert user.find_cell(:row => "OneRow", :column => "TwoColumns", :text => "hor").has_content?("hor")

    assert user.find_cell(:row => "OneRow", :column => "ThreeColumns").has_content?("CadetBlue")
    assert user.find_cell(:row => "OneRow", :column => "ThreeColumns", :text => "Chocolate").has_content?("Chocolate")
    # TODO: Find multiple cells matching without text

    # Second row
    assert user.find_cell(:row => "TwoRows", :column => "OneColumn").has_content?("ver")
    assert user.find_cell(:row => "TwoRows", :column => "OneColumn", :text => "ver").has_content?("ver")

    assert user.find_cell(:row => "TwoRows", :column => "TwoColumns").has_content?("sqr")
    assert user.find_cell(:row => "TwoRows", :column => "TwoColumns", :text => "sqr").has_content?("sqr")

    assert user.find_cell(:row => "TwoRows", :column => "ThreeColumns").has_content?("Sienna")
    assert user.find_cell(:row => "TwoRows", :column => "ThreeColumns", :text => "Tan").has_content?("Tan")
    assert user.find_cell(:row => "TwoRows", :column => "ThreeColumns", :text => "Tomato").has_content?("Tomato")


    # Test matching multiple rows and columns
  end

#  def test_find_cell_not_found
#
#  end
end