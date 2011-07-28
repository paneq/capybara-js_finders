require 'capybara/node/finders'

Capybara::Node::Finders.send(:include, Capybara::JsFinders)

require 'capybara/dsl'

Capybara::DSL.module_eval do
  def execute_script(*args, &block)
    page.execute_script(*args, &block)
  end

  def find_cell(*params, &block)
    page.find_cell(*params, &block)
  end

  def static_page(&block)
    page.static_page(&block)
  end
end

require 'capybara'

Capybara::Node::Base.module_eval do
  def execute_script(script)
    driver.execute_script(script)
  end

  def evaluate_script(script)
    driver.evaluate_script(script)
  end
end


Capybara::Session::NODE_METHODS.concat(Capybara::JsFinders::NEW_METHODS)
Capybara::Session::DSL_METHODS.concat(Capybara::JsFinders::NEW_METHODS)

Capybara::Session.class_eval do
  def find_cell(*params, &block)
    current_node.find_cell(*params, &block)
  end

  def static_page(&block)
    current_node.static_page(&block)
  end
end