<div class='container'>
  <div class='row'>
    <div class='col-md-3'>
<%# @entries.each do |e| %>
  <!--<div class="user-name">-->
    <%#= image_tag e.user.avatar, class:"user-image" %>
      <!--<a class="rooms-user-link" href="/users/<%#= e.user.id %>">--><!--</a>-->
      <strong><%= @entries.name %>さんとのチャット</strong>
<%# end %>
<hr>
<div class="chats">
  <div class="chat">
    <% if @messages.present? %>
      <% @messages.each do |m| %>
        <div class="chat-box">
          <div class="chat-face">
            <%= image_tag m.user.avatar, class:"user-image" %>
          </div>
          <div class="chat-hukidashi"> <strong><%= m.content %></strong> <br>
            <%= m.created_at.strftime("%Y-%m-%d %H:%M")%>
          </div>
        </div>
      <% end %>
    <% end %>
  </div>
  <div class="posts">
    <%= form_with model:@message do |f| %>
      <%= f.text_field :message, placeholder: "メッセージを入力して下さい" , size: 70, class:"form-text-field" %>
        <%= f.hidden_field :room_id, value: @room.id %>
          <%= f.submit "投稿",class: 'form-submit'%>
    <% end %>
  </div>
</div>
</div></div></div>