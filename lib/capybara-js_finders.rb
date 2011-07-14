require "capybara-js_finders/version"
require "capybara-js_finders/xpath_extensions"

module Capybara

  module JsFinders

    extend XPath

    LR = "lr".freeze # Left range
    RR = "rr".freeze # Right range
    TR = "tr".freeze # Top range
    BR = "br".freeze # Bottom range

    # TODO: This script is only prototype compatibile. Let it discover jquery or prototype and use proper methods.
    SCRIPT = <<-JS
    xpathResult = document.evaluate( "#{descendant(:th, :td)}", document, null, XPathResult.ANY_TYPE, null);
    var ary = [];
    var td;
    while( td = xpathResult.iterateNext() ){
      ary.push(td);
    }
    ary.each(function(ele){
      var offset = ele.cumulativeOffset();
      var lr = offset.left;
      var rr = lr + ele.getWidth();
      var tr = offset.top;
      var br = tr + ele.getHeight();
      ele.setAttribute('#{LR}', lr);
      ele.setAttribute('#{RR}', rr);
      ele.setAttribute('#{TR}', tr);
      ele.setAttribute('#{BR}', br);
    });
    JS
    SCRIPT.freeze

    def self.overlaps_columns(columns)
      columns_xpath = columns.map{|column| overlaps_column(column) }.join(" or ")
      columns_xpath = "( #{columns_xpath} )"
      return columns_xpath
    end

    def self.overlaps_column(column)
      overlaps_horizontal(column[LR], column[RR])
    end

    # clr, crr - Column left and right range
    def self.overlaps_horizontal(clr, crr)
      "(./@#{RR} >= #{clr} and ./@#{LR} <= #{crr})"
    end

    def self.overlaps_rows(rows)
      rows_xpath = rows.map{|row| overlaps_row(row) }.join(" or ")
      rows_xpath = "( #{rows_xpath} )"
      return rows_xpath
    end

    def self.overlaps_row(row)
      overlaps_vertical(row[TR], row[BR])
    end

    # rtr, rbr - row top and bottom range
    def self.overlaps_vertical(rtr, rbr)
      "(./@#{BR} >= #{rtr} and ./@#{TR} <= #{rbr})"
    end

    # Condition for td to be under one of column and on the same level as one of the rows
    def self.cell_condition(columns, rows)
      xpath = "( #{overlaps_rows(rows)} ) and ( #{overlaps_columns(columns)} ) "
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

      raise ArgumentError unless options[:row]
      rows = case options[:row]
      when String
        method = options[:multirow] ? :all : :find
        send(method, :xpath, XPath::HTML.cell(options[:row]) ) # TODO: jak all to musi byc conajmniej 1
      when Capybara::Node::Element
        options[:row]
      when Array
        options[:row].each{|x| raise ArgumentError unless x.is_a?(Capybara::Node::Element) }
      else
        raise ArgumentError
      end
      rows = Array.wrap(rows)

      execute_script(SCRIPT)
      xpath = JsFinders.cell_condition(columns, rows)
      xpath = ".//td[ #{xpath} ]"
      #puts xpath
      find(:xpath, xpath, options)
    end
  end
end

require "capybara-js_finders/capybara_extensions"