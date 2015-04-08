
angular.module('bitCodeApp')
  .directive("resultIframe", function() {
    return {
      restrict: "A",
      scope: {
        code: "=",
        result: "="
      },
      link: function (scope, element, attrs) {
        var iframe = element[0];
        var ifremeDocument = iframe.contentWindow.document;

        scope.$watch('code', function() {
          var json_data = attrs.data;
          if (json_data == "") json_data = "{}";
          var data = angular.fromJson(json_data);
          ifremeDocument.body.innerHTML = scope.code;
          scope.result = []

          for (var tag in data) {
            // objects = angular.fromJson(data[i]);
            html_oject = $(ifremeDocument).find(tag);
            object_str = "{\"" + tag + "\":[]}";
            object_arr = data[tag];

            res_object = angular.fromJson(object_str)
            for (var j = 0; j<object_arr.length; j++) {
              attr_name = object_arr[j]
              attr_val = $(html_oject).css(object_arr[j])

              res_object[tag].push( angular.fromJson( "{\"" + attr_name + "\":\"" + attr_val + "\"}" ) );
            }

            scope.result.push(res_object)
          }
        });
      }
    }
  });