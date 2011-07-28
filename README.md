# Capybara JS Finders

Capybara JS Finders is a set of additional finders for capybara. Currently it only contains cell finder which allows
you to find a table cell based on column and row descriptions.

## Installation

Simply add it to your Gemfile and bundle it up:

```ruby
gem 'capybara-js_finders', '~> 0.4'
gem 'capybara'
```

Make sure to add it before `capybara` in your Gemfile!

## API

Use it like any other capybara finder.

### find_cell

Allows you to find table cell (td, th) based on cell and row descriptions.
The method is colspan and rowspan attribute-aware which means it will be able to find
a cell even if it is under collspaned th containing a description.

#### Example

    <table>
      <tr>
        <th>
          User
        </th>
        <th>
          Email
        </th>
        <th>
          Permissions
        </th>
      </tr>

      <tr>
        <td>
          John Smith
        </td>
        <td>
          john@example.org
        </td>
        <td>
          Admin
        </td>
      </tr>

      <tr>
        <td>
          Andrew Bon
        </td>
        <td>
          andrew@example.org
        </td>
        <td>
          Moderator
        </td>
      </tr>

    </table>

```ruby
assert find_cell(:row => "John Smith", :column => "Permissions").has_content?("Admin")
assert find_cell(:row => "Andrew Bon", :column => "Email").has_no_content?("john")
```

#### Example

```ruby
assert find_cell(:row => "John Smith", :column => "January", :text => "28").has_text?("Present at work")
```

#### Multicolumn and multirow support

If there are many rows and/or columns matching `:row` and/or `:column` parameter you can wider the search to include all of them
by using `:multirow` and/or `:multicolumn` action.

##### Example

    <table>
      <tr>
        <th>
          User
        </th>
        <th>
          Email
        </th>
        <th>
          Permissions
        </th>
      </tr>

      <tr>
        <td>
          John Smith
        </td>
        <td>
          john@example.org
        </td>
        <td>
          Admin
        </td>
      </tr>

      <tr>
        <td>
          John Smith
        </td>
        <td>
          smith@example.org
        </td>
        <td>
          Moderator
        </td>
      </tr>

    </table>

```ruby
find_cell(:row => "John Smith", :column => "Permissions", :text => "Moderator") # raises an exception
find_cell(:multirow => true, :row => "John Smith", :column => "Permissions", :text => "Moderator") # will find the proper cell
```

#### Performance

Current implementation calculates the position of every th or td element on a page.
This might be slow especially when there are many such elements on the page. You if you have multiple
subsequent `find_cell` invocations and you know that the page does not change between them
you might use `static_page(&block)` method to improve the overall performance. Only first
call to `find_cell` will calculate cells' positions and the following checks will
reuse those values.

##### Example:

```ruby

click_link("Permissions")

static_page do
  find_cell(:row => "John Smith", :column => "Permissions") # execute JS to calculate elements' positions
  find_cell(:row => "Andrew Bon", :column => "Email")       # JS is not executed
end

click_link("Posts")

static_page do
  find_cell(:row => "Ruby is Awesome", :column => "Published at")       # execute JS to calculate elements' positions
  find_cell(:row => "And CoffeScript too", :column => "Published at")   # JS is not executed
end

click_link("Visitors")

find_cell(:row => "June 2011", :column => "Visitors")   # JS script is always executed outside static_page block
find_cell(:row => "July 2011", :column => "Page views") # JS script is always executed outside static_page block
```

## License

MIT License

## Integration

Integrates nicely with bbq

```ruby
user = Bbq::TestUser.new(:driver => :selenium, :session_name => :default)
user.visit '/page'
assert user.find_cell(:row => "RowDescription", :column => "ColumnDescription").has_content?("CellContent")
```