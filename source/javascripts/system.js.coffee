angular.module('bm.system', ['bm.distribution'])
.service('System', [
  '$rootScope'
  'Distribution'
  ($rootScope, Distribution) ->
    systems = []

    class System
      options:
        eLevelTypes: [
          {name: "Equidistant", value: 'equidistant'}
          {name: "Sublevels", value: 'sublevels'}
          {name: "Rotational", value: 'rotational'}
        ]

      constructor: ->
        @name = "System #{"ABCD".charAt(systems.length)}"
        @params =
          numParticles: 1
          eLevelType: @options.eLevelTypes[0]
          eDist: 10
          numSubLevels: 5
          subEDist: 10
          temperature: 103
        @update()

      update: ->
        @result = Distribution.boltzmann(@params)
        $rootScope.$broadcast 'system.update'

    create: (params) ->
      system = new System()
      systems.push(system)
      return system

    all: systems
])
.controller('SystemCtrl', [
  '$scope',
  'System'
  ($scope, System) ->
    $scope.data = []

    $scope.system = System.create()

    $scope.plotOptions =
      relative: no
      eLevels: yes
      xmax: 1
      ymax: 200

    $scope.$watch 'system.params', (val) ->
      $scope.system.update()
    , true
])
.controller('HeatFlowCtrl', [
  '$scope'
  'System'
  ($scope, System) ->
    setTotal = (val)->
      $scope.total = System.all.reduce (prev, current) ->
        prev.result.entropyTotal + current.result.entropyTotal

    $scope.$on 'system.update', setTotal

])