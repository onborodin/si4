<table>
    <thead>
        <td>#</td>
        <td>address</td>
        <td>password</td>
    </thead>
<% n = 0 %>
<% user.list.each do |row| %>
    <% n += 1 %>
    <tr>
    <td><%= n %>
    <td><%= row['name'] %>@<%= row['domain'] %></td>
    <td><%= row['password'] %></td>
<% end %>
</table>

