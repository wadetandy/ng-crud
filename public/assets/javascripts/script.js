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

app.config(function($locationProvider) { $locationProvider.hashPrefix('!')})

app.controller('postFormCtrl', function($scope) {
  // ... todo ...
})
