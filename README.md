# Capybara JS Finders

Capybara JS Finders is a set of additional finders for capybara. Currently it only contains cell finder which allows
you to find a table cell based on column and row descriptions.

## Installation

Simply add it to your Gemfile and bundle it up:

```ruby
gem 'capybara-js_finders', '~> 0.2.1'
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

#### Multicolumn and multirows support

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

## License

MIT License

## Integration

Integrates nicely with bbq

```ruby
user = Bbq::TestUser.new(:driver => :selenium, :session_name => :default)
user.visit '/page'
assert user.find_cell(:row => "RowDescription", :column => "ColumnDescription").has_content?("CellContent")
```