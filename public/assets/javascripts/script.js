app = angular.module('ngBlog', ['ngResource', 'ngRoute'])

app.config(function($routeProvider) {
  $routeProvider
    .when('/posts/new',
      {
        templateUrl: '/assets/templates/posts/form.html',
        controller: 'postFormCtrl',
        controllerAs: 'ctrl',
        reloadOnSearch: false
      }
    )
});

app.factory('Post', function($resource, $q) {
  var resource = $resource('posts/:id/:action.json',
    {id: '@id', action: '@action'}, {
        update: {method:'PUT'}
    });

  return resource;
});

app.config(function($locationProvider) { $locationProvider.hashPrefix('!')})

app.controller('postFormCtrl', function($scope, Post) {
  Post.get({id: 'new'}, function(post) {
    $scope.post = post
  })
})
