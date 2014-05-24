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

  self.boltzmann = (params) ->
    EiSystem = self.energyLevels(params)
    T = params.temperature
    energyParticle = 0
    entropyParticle = 0
    numParticles = params.numParticles

    [p, pSum] = self.partition(T, EiSystem)

    for item, idx in p
      item[0] /= pSum
      if item[0] > 0
        entropyParticle += -item[0] * Math.log(item[0])
        energyParticle  += (item[0] * EiSystem.energyLevels[idx])

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

  self.partition = (T, system) ->
    p = []
    pSum = 0
    if T is 0
      p.push([1, 0])
      pSum = 1
      p.push [0, level] for level in system.energyLevels
    else
      for level, idx in system.energyLevels
        p.push([
          system.degeneracy[idx] * Math.exp(-level / T),
          level
        ])
        pSum += p[idx][0]

    [p, pSum]

  self.newEdiff = (T, system) ->
    [p, pSum] = self.partition(T, system)

    energyParticle = 0

    for item, idx in p
      item[0] /= pSum
      energyParticle += (item[0] * system.energyLevels[idx])

    return system.energyTotal - ( (energyParticle * 8.3145 * system.numParticles) / 1000)

  self.newT = (T, system) ->
    Ta = 1.5 * T;
    Tb = 0.5 * T;
    Tc = (Ta + Tb) /2;
    fa = self.newEdiff(Tb, system);
    fb = self.newEdiff(Ta, system);
    fc = self.newEdiff(Tc, system);

    unless fa > 0 and fb < 0
      throw "bug"

    counter = 0
    maxIt = 1000;

    while Math.abs(fc) > 0.000001
      counter++
      if fc > 0
        Tb = Tc
      else
        Ta = Tc
      Tc = (Ta + Tb) / 2

      fc = self.newEdiff(Tc, system)

      throw "timeout" if counter is maxIt

    return Math.round(Tc)

  self
])
