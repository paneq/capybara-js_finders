# Capybara JS Finders

Capybara JS Finders is a set of additional finders for capybara. Currently it only contains cell finder which allows
you to find a table cell based on column and row descriptions.

## Installation

TODO!

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
        <th>
          John Smith
        </th>
        <th>
          john@example.org
        </th>
        <th>
          Admin
        </th>
      </tr>

      <tr>
        <th>
          Andrew Bon
        </th>
        <th>
          andrew@example.org
        </th>
        <th>
          Moderator
        </th>
      </tr>

    </table>

```ruby
assert find_cell(:row => "John Smith", :column => "Permissions").has_content?("Admin")
assert find_cell(:row => "Andrew Bon", :column => "Email").has_no_content?("john")
```

#### Example

```ruby
assert find_cell(:row => "John Smith", :column => "January", :text => "28" ).has_text?("Present at work")
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