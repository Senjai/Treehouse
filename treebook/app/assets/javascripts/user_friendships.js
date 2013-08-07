window.userFriendships = [];

$(document).ready(function() {

  $.ajax({
    url: Routes.user_friendships_path({format: 'json'}),
    dataType: 'json',
    type: 'GET',
    success: function(data) {
      window.userFriendships = data;
    }
  })

  $("#add-friendship").click(function(event) {
    event.preventDefault();
    var addFriendshipButton = $(this);

    $.ajax({
      url: Routes.user_friendships_path({user_friendship: { friend_id: addFriendshipButton.data('friendId') }}),
      dataType: 'json',
      type: 'POST',
      success: function(e) {
        addFriendshipButton.hide();
        $('#friend-status').html("<a href='#' class='btn btn-success'>Friendship Requested</a>");
      }
    });
  });
});