angular.module('ui.flot', ['bm.colour'])
.directive('chart', ['Colour', (Colour) ->
  restrict: 'C'
  link: (scope, elem, attrs) ->
    update = (val) ->
      return unless val
      opts = scope.$eval(attrs.chartOptions)
      system = scope.$eval(attrs.chartData)
      params = scope.$eval(attrs.chartParams)
      barSize = switch params.eLevelType.value
        when "equidistant" then system.energyLevelMainDiff / 2
        when "sublevel" then system.energyLevelSubDiff / 2

      ticks = 10
      tickLth = 0
      options = {
        series: {
          bars: {show: true, fill: 0.7, fillColor: "#" + Colour.colorAt(system.temperature) }
        },
        grid: {
          hoverable: true,
          show: true},
        yaxis: {
          min: 0,
          max: opts.ymax,
          ticks: ticks,
          tickLength: tickLth
        },
        xaxis: {
          min: 0,
          max: opts.xmax,
          tickLength: 0
        },
        bars: {
          horizontal: true,
          barWidth: barSize,
          lineWidth: 1
        },
        tooltip: true,
        tooltipOpts: {
          content: "population at E-level %y.0 is %x.2",
          shifts: {
              x: -60,
              y: 25
          }
        }
      }
      p = if opts.relative
        pCopy = angular.copy(system.probability)
        normalization = pCopy[0][0]
        el[0] /= normalization for el, idx in pCopy when el[0] > 0
        pCopy
      else
        system.probability

      $.plot(elem, [data: p], options)

    scope.$watch attrs.chartData, update
    scope.$watch attrs.chartOptions, update, true

    elem.show()
])

