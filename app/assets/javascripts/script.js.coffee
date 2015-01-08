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
  resource = $resource 'posts/:id/:action.json',
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

app.controller 'postDetailsCtrl', ['$scope', '$routeParams', 'Post', PostDetailsController]

class PostFormController
  constructor: (@scope, @routeParams, @location, @Post) ->
    @id = @routeParams.postId || 'new'

    @Post.get id: @id, (post) =>
      @scope.post = post

  saveOrUpdate: =>
    @scope.post.saveOrUpdate().then (post) =>
      @location.path("/posts/#{post.id}") if @id == 'new'


class PostsController
  constructor: (@scope, @Post) ->
    @init()

  init: =>
    @refreshPosts()

  refreshPosts: =>
    @Post.query (posts) =>
      @scope.posts = posts

  destroy: =>
    @post.$delete().then =>
      @refreshPosts()

app.controller 'postsCtrl', ['$scope', 'Post', PostsController]
