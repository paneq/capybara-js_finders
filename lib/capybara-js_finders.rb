require "capybara-js_finders/version"
require "capybara-js_finders/xpath_extensions"

module Capybara

  module JsFinders

    extend XPath

    LR = "lr".freeze
    RR = "rr".freeze

    # TODO: This script is only prototype compatibile. Let it discover jquery or prototype and use proper methods.
    SCRIPT = <<-JS
    xpathResult = document.evaluate( "#{descendant(:th, :td)}", document, null, XPathResult.ANY_TYPE, null);
    var ary = [];
    var td;
    while( td = xpathResult.iterateNext() ){
      ary.push(td);
    }
    ary.each(function(ele){
      var sp = ele.cumulativeOffset().left;
      var sps = sp + ele.getWidth();
      ele.setAttribute('lr', sp);
      ele.setAttribute('rr', sps);
    });
    JS
    SCRIPT.freeze

    def self.overlaps_columns(columns)
      columns_xpath = columns.map{|column| overlaps_column(column) }.join(" or ")
      columns_xpath = "( #{columns_xpath} )"
      return columns_xpath
    end

    def self.overlaps_column(column)
      overlaps(column[LR], column[RR])
    end

    # crl, crr - Column left and right range
    def self.overlaps(clr, crr)
      "(./@rr >= #{clr} and ./@lr <= #{crr})"
    end

    # Condition for td to be under one of columna and in row with given text
    # This does not work with rowspan!
    def self.cell_condition(columns, father_row_text)
      row_xpath = father(:tr)[ string.n.is(father_row_text) ].to_s
      xpath = "( #{row_xpath} ) and ( #{overlaps_columns(columns)} ) "
      return xpath
    end

    # :column - text which should appear in the table column, or td/th Capybara::Node::Element object [or Array of them]
    #           representing the columns which narrow the search area of the table.
    # :row - text which should appear in the row of the table, (TODO: tr Capybara::Node::Element object [or Array of them])
    # :cell - text which should appear in the column (TODO: Implement it!)
    # :multicolumn - set to true if finding column by test should return multiple results instead of just one
    #
    # :text
    # :visible
    # :with
    def find_cell(options = {})
      # TODO: Jak pierwszy arg to string to wywolaj cell zamiast tego
      raise ArgumentError unless options[:column]
      columns = case options[:column]
      when String
        method = options[:multicolumn] ? :all : :find
        send(method, :xpath, XPath::HTML.cell(options[:column]) ) # TODO: jak all to musi byc conajmniej 1
      when Capybara::Node::Element
        options[:column]
      when Array
        options[:column].each{|x| raise ArgumentError unless x.is_a?(Capybara::Node::Element) }
      else
        raise ArgumentError
      end
      columns = Array.wrap(columns)

      execute_script(SCRIPT)
      xpath = FindCell.cell_condition(columns, options[:row])
      xpath = ".//td[ #{xpath} ]"
      #puts xpath
      find(:xpath, xpath, options)
    end
  end
end

require "capybara-js_finders/capybara_extensions"