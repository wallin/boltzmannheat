angular.module('Boltzmann')
.config([
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->
    $stateProvider
    .state 'introduction',
      url: '/introduction'
      templateUrl: 'introduction.html'
    .state 'lab',
      url: '/lab'
      templateUrl: 'lab.html'

    $urlRouterProvider.otherwise '/lab'
])