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

  def test_respond_to
    user = Bbq::TestUser.new(:driver => :selenium, :session_name => :default)
    user.visit '/'
    assert user.find('table').respond_to?(:find_cell)
    assert user.respond_to?(:find_cell)
  end

  #  def test_find_cell
  #    user = Bbq::TestUser.new(:driver => :selenium, :session_name => :default)
  #    user.visit '/'
  #
  #    red = user.find_cell(:row => "OneRow", :column => "OneColumn")
  #    assert red.has_text?("red")
  #
  #  end
end