require 'xpath'

module XPath
  class Expression
    class Father < Multiple
      def to_xpath(predicate=nil)
        if @expressions.length == 1
          "#{@left.to_xpath(predicate)}/../self::#{@expressions.first.to_xpath(predicate)}"
        elsif @expressions.length > 1
          "#{@left.to_xpath(predicate)}/../self::*[#{@expressions.map { |e| "self::#{e.to_xpath(predicate)}" }.join(" | ")}]"
        else
          "#{@left.to_xpath(predicate)}/../self::*"
        end
      end
    end
  end

  def father(*expressions)
    Expression::Father.new(current, expressions)
  end
end

XPath::HTML.module_eval do
  def cell(locator)
    descendant(:td, :th)[attr(:id).equals(locator) | string.n.is(locator)]
  end
end