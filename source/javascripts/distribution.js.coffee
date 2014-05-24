angular.module('bm.distribution', [])
.service('Distribution', [->
  self = {}
  self.energyLevels = (params) ->
    nElevels     = 10000
    energyLevels = new Array(nElevels)
    degeneracy   = new Array(nElevels)
    elev         = new Array(nElevels)
    dE = params.eDist
    dESub = params.subEDist
    switch params.eLevelType.value
      when 'equidistant'
        dESub = 0
        for idx in [0..nElevels]
          energyLevels[idx] = idx * dE
          degeneracy[idx] = 1

      when 'sublevels'
        countI = 0
        for i in [0..nElevels] by params.numSubLevels
          for j in [0..params.numSubLevels]
            energyLevels[i+j] = (countI * dE) + (j * dESub)
            degeneracy[i+j] = 1
            elev[i+j] = i * dE
          countI++

      when 'rotational'
        throw "TODO!"

    return {
      energyLevels,
      degeneracy,
      energyLevelMainDiff: dE,
      energyLevelSubDiff: dESub
    }

  self.boltzmann = (params, opts = {}) ->
    EiSystem = self.energyLevels(params)
    p = []
    pSum = 0
    T = params.temperature
    energyParticle = 0
    entropyParticle = 0
    numParticles = params.numParticles

    if T is 0
      p.push([1, 0])
      pSum = 1
      p.push [0, level] for level in EiSystem.energyLevels
    else
      for level, idx in EiSystem.energyLevels
        p.push([
          EiSystem.degeneracy[idx] * Math.exp(-EiSystem.energyLevels[idx] / T),
          level
        ])
        pSum += p[idx][0]

    for item, idx in p
      item[0] /= pSum
      if item[0] > 0
        entropyParticle += -item[0] * Math.log(item[0])
        energyParticle  += (item[0] * EiSystem.energyLevels[idx])

    if opts.plotRel
      normalization = p[0][0]
      item[0] /= normalization for item in p when item[0] > 0

    CONST = 8.3145
    return angular.extend({}, EiSystem, {
      probability: p
      partitionFun: pSum
      numParticles: numParticles
      energyParticle: energyParticle
      energyTotal: (energyParticle * CONST * numParticles) / 1000
      energyMolar: energyParticle * CONST / 1000
      entropyParticle: entropyParticle
      entropyTotal: entropyParticle * CONST * numParticles
      entropyMolar: entropyParticle * CONST
      temperature: T
    })

  self
])
