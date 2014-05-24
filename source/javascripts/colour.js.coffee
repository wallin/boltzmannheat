angular.module('bm.colour', [])
.service('Colour', [->
  colourMap = new Rainbow()
  colour1 = "#0FDBFF";
  colour2 = "#0FFF1B";
  colour3 = "#FFEB0F";
  colour4 = "#FF170F";
  minTemp = 0;
  maxTemp = 500;
  colourMap.setSpectrum(colour1, colour3, colour4);
  colourMap.setNumberRange(minTemp, maxTemp);

  colourMap
])