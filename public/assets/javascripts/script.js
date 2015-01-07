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
    .when('/posts/:postId',
      {
        templateUrl: '/assets/templates/posts/show.html',
        controller: 'postDetailsCtrl',
        controllerAs: 'ctrl',
        reloadOnSearch: false
      }
    )
    .when('/posts/:postId/edit',
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

app.controller('postDetailsCtrl', function($scope, $routeParams, Post) {
  var ctrl = this;

  Post.get({id: $routeParams.postId}, function(post) {
    $scope.post = post
  })
})

app.controller('postFormCtrl', function($scope, $location, $routeParams, Post) {
  var id;

  if ($routeParams.postId) {
    id = $routeParams.postId
  } else {
    id = 'new'
  }

  Post.get({id: id}, function(post) {
    $scope.post = post
  })

  this.saveOrUpdate = function() {
    method = '$save';

    if ($scope.post.id) { method = '$update' }

    $scope.post[method]().then(function(post) {
      if (id == 'new') {
        $location.path("/posts/" + post.id)
      }
    });
  }
})
