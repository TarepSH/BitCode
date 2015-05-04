function showNotify (title, text, type) {
  type = type || 'info';
  if (type == 'notice') type = 'success';
  text = text.replace(/,,/g, '<br>');
  var stack_bar_bottom = {"dir1": "up", "dir2": "right", "spacing1": 0, "spacing2": 0};
  new PNotify({
    title: title,
    text: text,
    type: type,
    cornerclass: "",
    addclass: "stack-bar-bottom",
    width: "100%",
    stack: stack_bar_bottom
  });
}

$(document).ready(function () {
  $('body').on('click', '.ui-pnotify-closer', function (popup_closer) {
    $(popup_closer.currentTarget).closest('.ui-pnotify').remove();
  })
})