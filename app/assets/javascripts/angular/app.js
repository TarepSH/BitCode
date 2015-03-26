'use strict';

angular
  .module('bitCodeApp', [
    'ngAnimate',
    'ngResource',
    'ui.router',
    'ngTouch',
    'ui.bootstrap',
    'angular-loading-bar',
    'ui.bootstrap.tpls',
    'ui.ace'
  ], function($compileProvider) {
    // configure new 'compile' directive by passing a directive
    // factory function. The factory function injects the '$compile'
    $compileProvider.directive('compile', function($compile) {
      // directive factory creates a link function
      return function(scope, element, attrs) {
        scope.$watch(
          function(scope) {
             // watch the 'compile' expression for changes
            return scope.$eval(attrs.compile);
          },
          function(value) {
            // when the 'compile' expression changes
            // assign it into the current DOM
            element.html(value);

            // compile the new DOM and link it to the current
            // scope.
            // NOTE: we only compile .childNodes so that
            // we don't get into infinite loop compiling ourselves
            $compile(element.contents())(scope);
          }
        );
      };
    });
  })
  .controller('ChallengesCtrl', ["$scope", "$location", "challenges", function ($scope, $location, challenges) {
    $scope.code = "<html>\n    <h1>مرحبا بالعالم</h1>\n</html>";
    $scope.code_type = "html";
    $scope.challenges =  [];

    var path = $location.$$absUrl.split('courses')[1]
    var ids_array = path.split('/')

    challenges.query({course_id: ids_array[1], chapter_id: ids_array[3]})
      .$promise.then(function (data) {
        $scope.challenges = data;
        $scope.selectedChallenge = $scope.challenges[0];
      });

    $scope.selectChallenge = function (challenge) {
      $scope.selectedChallenge = challenge;
    }

    $scope.getFinalCodeFor = function (selectedChallenge) {
      if ($scope.selectedChallenge) {
        var finalCode = ""
        for (var i=0; i < $scope.selectedChallenge.tabs.length; i++) {
          finalCode += "\n\n" + $scope.selectedChallenge.tabs[i].starter_code;
        }
        return finalCode;
      }
      else {
        return "";
      }
    }

    $scope.aceLoaded = function(_editor) {
      // Options
      _editor.setReadOnly(false);
    };
  }]);