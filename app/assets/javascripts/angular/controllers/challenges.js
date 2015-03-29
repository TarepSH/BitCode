
angular.module('bitCodeApp')
  .controller('ChallengesCtrl', ["$scope", "$location", "$http", "notificationService", "challenges", function ($scope, $location, $http, notificationService, challenges) {
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
            notificationService.success("\n" + data.message);

            if ($scope.challenges.indexOf($scope.selectedChallenge) == $scope.challenges.length-1) {
              new PNotify({
                title: 'مبارك!، لقد انهيت هذا الفصل بنجاح',
                text: 'انتقل إلى الى صفحة الفصول؟',
                icon: 'glyphicon glyphicon-question-sign',
                hide: false,
                confirm: {
                  confirm: true,
                  buttons: [{
                    text: 'نعم',
                    addClass: 'btn-primary',
                    click: function(notice) {
                      location.href = "/courses/" + course_id + "/chapters";
                    }
                  }, {
                    text: 'لا',
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
                }
              });
            }
          }
          else {
            notificationService.error("\nYour asnwer is incorrect, "+data.message);
          }
        });
    }

    $scope.aceLoaded = function(_editor) {
      // Options
      _editor.setReadOnly(false);
    };
  }]);