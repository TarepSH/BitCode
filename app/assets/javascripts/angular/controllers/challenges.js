
angular.module('bitCodeApp')
  .controller('ChallengesCtrl',
  ["$scope", "$location", "$http", "notificationService", "notificationAlert", "challenges",
  function ($scope, $location, $http, notificationService, notificationAlert, challenges) {
    $scope.code = "<html>\n    <h1>مرحبا بالعالم</h1>\n</html>";
    $scope.code_type = "html";
    $scope.challenges =  [];

    $scope.styles_result = [];

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

    $scope.getHint = function (challenge) {
      if (challenge.hints_number > 0) {
        var lastHintId = 0;
        if (!challenge.queriedHints) challenge.queriedHints = [];
        if (challenge.queriedHints.length > 0)
          lastHintId = challenge.queriedHints[$scope.challenge.queriedHints.length-1].id;
        $http.get('/courses/'+course_id+'/chapters/'+chapter_id+'/challenges/'+challenge.id+'/get_next_hint.json',
          {hint_id: lastHintId}).then(function (res) {
            var data = res.data;
            if (data) {
              challenge.hints_number -= 1;
              challenge.queriedHints.push(data);
            }
          });
      }
    }

    $scope.getFinalCodeFor = function (selectedChallenge) {
      if ($scope.selectedChallenge) {
        var finalCode = ""
        for (var i=0; i < $scope.selectedChallenge.tabs.length; i++) {
          if ($scope.selectedChallenge.tabs[i].language_name == 'css') {
            finalCode += "\n\n<style>" + $scope.selectedChallenge.tabs[i].starter_code + "</style>";
          }
          else {
            finalCode += "\n\n" + $scope.selectedChallenge.tabs[i].starter_code;
          }
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
      data["challenge"]["styles"] = $scope.styles_result

      $http.post('/courses/'+course_id+'/chapters/'+chapter_id+'/challenges/'+$scope.selectedChallenge.id+'/check_validation.json',
        data).then(function (res) {
          var data = res.data;
          if (data.success) {
            notificationService.success("\n" + data.message);
            var selectChallengeArrayId = $scope.challenges.indexOf($scope.selectedChallenge);

            if (data.next_chapter_id != 0) {
              if (data.next_chapter_id == null) {
                notificationAlert.confirm(
                  "تهانينا",
                  "تهانينا، لقد انهيت هذه الدورة بنجاح!",
                  [
                    {
                      text: 'استمرار',
                      href: "/courses"
                    },
                    {
                      text: 'بقاء'
                    }
                  ],
                  'success'
                )
              }
              else {
                notificationAlert.confirm(
                  "مبارك!، لقد انهيت هذا الفصل بنجاح",
                  "انتقل إلى الى صفحة الفصول؟",
                  [
                    {
                      text: 'نعم',
                      href: "/courses/" + course_id + "/chapters/" + data.next_chapter_id
                    },
                    {
                      text: 'لا'
                    }
                  ],
                  'success'
                )
              }
            }
            else {
              $scope.selectedChallenge = $scope.challenges[selectChallengeArrayId+1];
            }
          }
          else {
            notificationService.error("\nاجابتك غير صحيحة, "+data.message);
          }
        });
    }

    $scope.aceLoaded = function(_editor) {
      // Options
      _editor.setReadOnly(false);
    };
  }]);