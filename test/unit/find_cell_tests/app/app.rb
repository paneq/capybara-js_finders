require 'sinatra'

module FindCellTests

  class App < Sinatra::Base
    set :views,  File.join(  File.expand_path( File.dirname(__FILE__) ),  'views'  )
    set :public, File.join(  File.expand_path( File.dirname(__FILE__) ),  'public'  )
    get "/" do
      erubis :table
    end
  end
  
end