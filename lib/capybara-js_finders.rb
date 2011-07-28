require "capybara-js_finders/version"
require "capybara-js_finders/xpath_extensions"

module Capybara

  module JsFinders

    extend XPath

    LR = "lr".freeze # Left range
    RR = "rr".freeze # Right range
    TR = "tr".freeze # Top range
    BR = "br".freeze # Bottom range
    XpathTrue = "(1=1)"
    NEW_METHODS = [:find_cell, :static_page].freeze

    # TODO: This script is only prototype compatible. Let it discover jquery or prototype and use proper methods.
    # 
    # If element left offset is 5 and element width is 10 then it cannot occupy pixels from 5 to 15 because that would give us 11px width.
    # Element must occupy pixels from 6 to 15 or from 5 to 14 (including).
    #
    # I assume that the former answer is correct.
    # Element starts on 6th pixel and that's why offset is equal to 5. TODO: Make sure there is test for that!
    #
    SCRIPT = <<-JS
      xpathResult = document.evaluate( "#{descendant(:th, :td)}", document, null, XPathResult.ANY_TYPE, null);
      var ary = [];
      var td;
      while( td = xpathResult.iterateNext() ){
        ary.push(td);
      }
      ary.each(function(ele){
        try{
          var dimensions = ele.getDimensions();
          var offset = ele.cumulativeOffset();

          ele.setAttribute('#{LR}', offset.left + 1);
          ele.setAttribute('#{RR}', offset.left + dimensions.width);
          ele.setAttribute('#{TR}', offset.top  + 1);
          ele.setAttribute('#{BR}', offset.top  + dimensions.height);
        } catch(err){
          /* ele.getDimensions() sometimes raises an exception, just skip ele in such case, there is nothing we can do about it! */
        }
      });
    JS
    SCRIPT.freeze

    def self.overlaps_columns(columns)
      return XpathTrue if columns.first == true
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
      return XpathTrue if rows.first == true
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

    def self.not_equal_to(headers)
      headers.reject{|h| h == true}.map do |h|
        "( ./@#{TR} != #{h[TR]} or ./@#{BR} != #{h[BR]} or ./@#{LR} != #{h[LR]} or ./@#{RR} != #{h[RR]} )"
      end.join(" and ")
    end

    # Condition for td to be under one of column and on the same level as one of the rows
    # and cannot be the same cell as one of the row-header or column-header
    def self.cell_condition(columns, rows)
      xpath = "( #{overlaps_rows(rows)} ) and ( #{overlaps_columns(columns)} ) and (#{not_equal_to(columns + rows)})"
      return xpath
    end

    # :column - text which should appear in the table column, or td/th Capybara::Node::Element object [or Array of them]
    #           representing the columns which narrow the search area of the table. Nil is allowed.
    #
    # :row - text which should appear in the row of the table, or td/th Capybara::Node::Element object [or Array of them]
    #           representing the columns which narrow the search area of the table. Nil is allowed.
    # :text - text which should appear in the cell
    # :multicolumn - set to true if finding column by test should return multiple results instead of just one
    # :multirow - set to true if finding rows by test should return multiple results instead of just one
    #
    # :visible
    # :with
    def find_cell(options = {})
      # TODO: Jak pierwszy arg to string to wywolaj cell zamiast tego

      columns = case options[:column]
      when String
        method = options[:multicolumn] ? :all : :find
        send(method, :xpath, XPath::HTML.cell(options[:column]) ) # TODO: jak all to musi byc conajmniej 1
      when Capybara::Node::Element
        options[:column]
      when Array
        options[:column].each{|x| raise ArgumentError unless x.is_a?(Capybara::Node::Element) }
      when NilClass
        true
      else
        raise ArgumentError
      end
      columns = Array.wrap(columns)

      rows = case options[:row]
      when String
        method = options[:multirow] ? :all : :find
        send(method, :xpath, XPath::HTML.cell(options[:row]) ) # TODO: jak all to musi byc conajmniej 1
      when Capybara::Node::Element
        options[:row]
      when Array
        options[:row].each{|x| raise ArgumentError unless x.is_a?(Capybara::Node::Element) }
      when NilClass
        true
      else
        raise ArgumentError
      end
      rows = Array.wrap(rows)

      if @static_page
        execute_script(SCRIPT) unless @executed
        @executed = true
      else
        execute_script(SCRIPT)
      end
      xpath = JsFinders.cell_condition(columns, rows)
      xpath = ".//td[ #{xpath} ]" # TODO: td or th ?
      # puts xpath
      find(:xpath, xpath, options)
    end

    def static_page(&block)
      @static_page = true
      return block.call
    ensure
      @executed = false
      @static_page = false
    end

  end

end

require "capybara-js_finders/capybara_extensions"