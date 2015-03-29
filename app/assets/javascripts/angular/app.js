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
  .config(['notificationServiceProvider', function(notificationServiceProvider) {

    notificationServiceProvider
      .setStack('top_left', 'stack-topleft', {
        dir1: 'down',
        dir2: 'right'
      })
      .setDefaultStack('top_left');

  }])