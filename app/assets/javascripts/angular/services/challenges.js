'use strict';

angular.module('bitCodeApp')
  .factory('challenges', ['$resource', function($resource) {
    return $resource('/courses/:course_id/chapters/:chapter_id/challenges/:id.json', {
      id: '@id',
      course_id: '@course_id',
      chapter_id: '@chapter_id'
    });
  }])