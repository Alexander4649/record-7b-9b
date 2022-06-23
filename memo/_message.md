<% unless @user.id == current_user.id %>
  <% if (current_user.followed_by? @user) && (@user.followed_by? current_user)  %>
  <% if @isRoom == true %>
    <p class="user-show-room"><a href="/rooms/<%= @roomId %>" class="btn btn-primary btn-lg">チャットへ</a>
  <% else %>
    <%= form_with model:@room do |f| %>
      <%= fields_for @entry do |e| %>
        <%= e.hidden_field :user_id, value: @user.id %>
      <% end %>
      <%= f.submit "チャットを始める", class:"btn btn-sm btn-primary user-show-chat"%></p>
    <% end %>
  <% end %>
  <% end %>
<% end %>