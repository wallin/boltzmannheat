(function(){angular.module("Boltzmann").config(["$stateProvider","$urlRouterProvider",function(t,l){return t.state("introduction",{url:"/introduction",templateUrl:"introduction.html"}).state("lab",{url:"/lab",templateUrl:"lab.html"}),l.otherwise("/lab")}])}).call(this);