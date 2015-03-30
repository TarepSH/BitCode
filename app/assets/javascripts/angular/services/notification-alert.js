
angular.module('bitCodeApp')
  .service('notificationAlert', ['notificationService', function(notificationService){
    return {
      confirm: function (title, text, buttons, type) {
        notificationService.notify({
          title: "\n" + title,
          text: "\n" + text,
          hide: false,
          confirm: {
            confirm: true,
            buttons: [{
              text: buttons[0]["text"],
              addClass: 'btn-primary',
              click: function(notice) {
                location.href = buttons[0]["href"];
              }
            }, {
              text: buttons[1]["text"],
              click: function(notice) {
                notice.remove();
              }
            }]
          },
          buttons: {
            closer: false,
            sticker: false
          },
          history: {
            history: false
          },
          type: type
        });
      }
    };
  }])