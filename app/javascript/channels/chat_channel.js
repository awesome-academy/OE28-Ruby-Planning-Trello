import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  var board_id = $("#board-id").val();

  consumer.subscriptions.create({channel: "ChatChannel", board_id: board_id }, {
    connected() {

    },
    disconnected() {

    },
    received(data) {
      $('#messages-wrapper').append(data.content.chat_html);
      $('html, body').animate({ scrollTop: $('#messages-wrapper').scrollTop() }, 500);
      $('#message-input').val('');
    }
  });
})
