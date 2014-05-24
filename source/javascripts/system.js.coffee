angular.module('bm.system', ['bm.distribution'])
.service('System', [
  '$rootScope'
  'Distribution'
  ($rootScope, Distribution) ->
    systems = {}

    class System
      options:
        eLevelTypes: [
          {name: "Equidistant", value: 'equidistant'}
          {name: "Sublevels", value: 'sublevels'}
          {name: "Rotational", value: 'rotational'}
        ]

      constructor: ->
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

    findOrCreate: (name) ->
      systems[name] ?= new System(name)
      return systems[name]

    all: systems
])
.controller('SystemCtrl', [
  '$attrs'
  '$scope',
  'System'
  ($attrs, $scope, System) ->
    $scope.system = System.findOrCreate($attrs['systemName'])

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
      $scope.total = 0
      $scope.total += s.result.entropyTotal for name, s of System.all

    $scope.$on 'system.update', setTotal

])