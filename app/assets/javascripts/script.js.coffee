app = angular.module 'ngBlog', ['ngResource', 'ngRoute']

app.config ($routeProvider) ->
  $routeProvider
    .when('/posts',
      {
        templateUrl: '/assets/templates/posts/index.html'
        controller: 'postsCtrl'
        controllerAs: 'ctrl'
        reloadOnSearch: false
      }
    )
    .when('/posts/new',
      {
        templateUrl: '/assets/templates/posts/form.html'
        controller: 'postFormCtrl'
        controllerAs: 'ctrl'
        reloadOnSearch: false
      }
    )
    .when('/posts/:postId',
      {
        templateUrl: '/assets/templates/posts/show.html'
        controller: 'postDetailsCtrl'
        controllerAs: 'ctrl'
        reloadOnSearch: false
      }
    )
    .when('/posts/:postId/edit',
      {
        templateUrl: '/assets/templates/posts/form.html'
        controller: 'postFormCtrl'
        controllerAs: 'ctrl'
        reloadOnSearch: false
      }
    )
    .otherwise({redirectTo: '/posts'})

app.config ($locationProvider) ->
  $locationProvider.hashPrefix('!')

app.factory 'Post', ($resource, $q) ->
  resource = $resource('posts/:id/:action.json',
    {id: '@id', action: '@action'}, {update: {method:'PUT'}}

  resource::saveOrUpdate = ->
    method = '$save'
    method = '$update' if @id
    @[method]()

  resource

class PostDetailsController
  constructor: (@scope, @routeParams, @Post) ->
    @Post.get id: @routeParams.postId, (post) =>
      @scope.post = post

app.controller('postFormCtrl', function($scope, $routeParams, $location, Post) {
  var ctrl = this;
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
    $scope.post.saveOrUpdate().then(function(post) {
      if (id == 'new') {
        $location.path("/posts/" + post.id)
      }
    });
  }
})

app.controller('postsCtrl', function($scope, Post) {
  var ctrl = this;

  this.init = function() {
    ctrl.refreshPosts();
  }

  this.refreshPosts = function() {
    Post.query(function(posts) {
      $scope.posts = posts;
    });
  }

  this.destroy = function(post) {
    post.$delete().then(function() {
      ctrl.refreshPosts()
    })
  }

  ctrl.init();
});

