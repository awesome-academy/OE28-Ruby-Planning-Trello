$(document).on('turbolinks:load', function() {
  $('.chat-member').click(function(){
    let item = this.id;
    let receiver_id = $('#'+item).data('user');
    let board_id = $('#'+item).data('board');

    $.ajax({
      url: '/messages/new',
      type: 'get',
      data: {
        'user_id': receiver_id,
        'board_id': board_id
      }
    });
  });
});
