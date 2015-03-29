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
    'ui.ace',
    'jlareau.pnotify'
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
  .controller('ChallengesCtrl', ["$scope", "$location", "$http", "challenges", function ($scope, $location, $http, challenges) {
    $scope.code = "<html>\n    <h1>مرحبا بالعالم</h1>\n</html>";
    $scope.code_type = "html";
    $scope.challenges =  [];

    var path = $location.$$absUrl.split('courses')[1]
    var ids_array = path.split('/')
    var course_id = ids_array[1];
    var chapter_id = ids_array[3]

    challenges.query({course_id: course_id, chapter_id: chapter_id})
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

    $scope.checkValidate = function (token) {
      var data = {
        challenge: {},
        tabs: []
      };
      data[token["name"]] = token["value"];
      data["challenge"]["tabs"] = data["tabs"] = $scope.selectedChallenge.tabs;

      $http.post('/courses/'+course_id+'/chapters/'+chapter_id+'/challenges/'+$scope.selectedChallenge.id+'/check_validation.json',
        data).then(function (res) {
          var data = res.data;
          if (data.success) {
            alert("Your asnwer is correct");
          }
          else {
            alert("Your asnwer is incorrect, "+data.message);
          }
        });
    }

    $scope.aceLoaded = function(_editor) {
      // Options
      _editor.setReadOnly(false);
    };
  }]);