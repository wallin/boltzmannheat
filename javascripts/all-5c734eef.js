function Rainbow(){function t(t){if(t.length<2)throw new Error("Rainbow must have two or more colours.");var i=(n-r)/(t.length-1),o=new ColourGradient;o.setGradient(t[0],t[1]),o.setNumberRange(r,r+i),e=[o];for(var u=1;u<t.length-1;u++){var s=new ColourGradient;s.setGradient(t[u],t[u+1]),s.setNumberRange(r+i*u,r+i*(u+1)),e[u]=s}return a=t,this}var e=null,r=0,n=100,a=["ff0000","ffff00","00ff00","0000ff"];t(a),this.setColors=this.setColours,this.setSpectrum=function(){return t(arguments),this},this.setSpectrumByArray=function(e){return t(e),this},this.colourAt=function(t){if(isNaN(t))throw new TypeError(t+" is not a number");if(1===e.length)return e[0].colourAt(t);var a=(n-r)/e.length,i=Math.min(Math.floor((Math.max(t,r)-r)/a),e.length-1);return e[i].colourAt(t)},this.colorAt=this.colourAt,this.setNumberRange=function(e,i){if(!(i>e))throw new RangeError("maxNumber ("+i+") is not greater than minNumber ("+e+")");return r=e,n=i,t(a),this}}function ColourGradient(){function t(t,e,r){var n=t;i>n&&(n=i),n>o&&(n=o);var a=o-i,u=parseInt(e,16),s=parseInt(r,16),l=(s-u)/a,f=Math.round(l*(n-i)+u);return formatHex(f.toString(16))}function e(t){var e=/^#?[0-9a-fA-F]{6}$/i;return e.test(t)}function r(t){if(e(t))return t.substring(t.length-6,t.length);for(var r=[["red","ff0000"],["lime","00ff00"],["blue","0000ff"],["yellow","ffff00"],["orange","ff8000"],["aqua","00ffff"],["fuchsia","ff00ff"],["white","ffffff"],["black","000000"],["gray","808080"],["grey","808080"],["silver","c0c0c0"],["maroon","800000"],["olive","808000"],["green","008000"],["teal","008080"],["navy","000080"],["purple","800080"]],n=0;n<r.length;n++)if(t.toLowerCase()===r[n][0])return r[n][1];throw new Error(t+" is not a valid colour.")}var n="ff0000",a="0000ff",i=0,o=100;this.setGradient=function(t,e){n=r(t),a=r(e)},this.setNumberRange=function(t,e){if(!(e>t))throw new RangeError("maxNumber ("+e+") is not greater than minNumber ("+t+")");i=t,o=e},this.colourAt=function(e){return t(e,n.substring(0,2),a.substring(0,2))+t(e,n.substring(2,4),a.substring(2,4))+t(e,n.substring(4,6),a.substring(4,6))},formatHex=function(t){return 1===t.length?"0"+t:t}}(function(){angular.module("Boltzmann",["ui.bootstrap","ui.flot","ui.router","bm.system"])}).call(this),function(){angular.module("ui.flot",["bm.colour"]).directive("chart",["Colour",function(t){return{restrict:"C",link:function(e,r,n){var a;return a=function(a){var i,o,u,s,l,f,c,h,m,g,p,v;if(a)return f=e.$eval(n.chartOptions),g=e.$eval(n.chartData),m=e.$eval(n.chartParams),i=function(){switch(m.eLevelType.value){case"equidistant":return g.energyLevelMainDiff/2;case"sublevel":return g.energyLevelSubDiff/2}}(),v=10,p=0,l={series:{bars:{show:!0,fill:.7,fillColor:"#"+t.colorAt(g.temperature)}},grid:{hoverable:!0,show:!0},yaxis:{min:0,max:f.ymax,ticks:v,tickLength:p},xaxis:{min:0,max:f.xmax,tickLength:0},bars:{horizontal:!0,barWidth:i,lineWidth:1},tooltip:!0,tooltipOpts:{content:"population at E-level %y.0 is %x.2",shifts:{x:-60,y:25}}},c=function(){var t,e;if(f.relative){for(h=angular.copy(g.probability),s=h[0][0],u=t=0,e=h.length;e>t;u=++t)o=h[u],o[0]>0&&(o[0]/=s);return h}return g.probability}(),$.plot(r,[{data:c}],l)},e.$watch(n.chartData,a),e.$watch(n.chartOptions,a,!0),r.show()}}}])}.call(this),function(){angular.module("bm.colour",[]).service("Colour",[function(){var t,e,r,n,a,i,o;return a=new Rainbow,t="#0FDBFF",e="#0FFF1B",r="#FFEB0F",n="#FF170F",o=0,i=500,a.setSpectrum(t,r,n),a.setNumberRange(o,i),a}])}.call(this),function(){angular.module("bm.distribution",[]).service("Distribution",[function(){var t;return t={},t.energyLevels=function(t){var e,r,n,a,i,o,u,s,l,f,c,h,m,g,p;switch(f=1e4,o=new Array(f),a=new Array(f),i=new Array(f),r=t.eDist,n=t.subEDist,t.eLevelType.value){case"equidistant":for(n=0,s=c=0;f>=0?f>=c:c>=f;s=f>=0?++c:--c)o[s]=s*r,a[s]=1;break;case"sublevels":for(e=0,u=h=0,g=t.numSubLevels;g>0?f>=h:h>=f;u=h+=g){for(l=m=0,p=t.numSubLevels;p>=0?p>=m:m>=p;l=p>=0?++m:--m)o[u+l]=e*r+l*n,a[u+l]=1,i[u+l]=u*r;e++}break;case"rotational":throw"TODO!"}return{energyLevels:o,degeneracy:a,energyLevelMainDiff:r,energyLevelSubDiff:n}},t.boltzmann=function(e){var r,n,a,i,o,u,s,l,f,c,h,m,g;for(n=t.energyLevels(e),a=e.temperature,i=0,o=0,l=e.numParticles,g=t.partition(a,n),f=g[0],c=g[1],u=h=0,m=f.length;m>h;u=++h)s=f[u],s[0]/=c,s[0]>0&&(o+=-s[0]*Math.log(s[0]),i+=s[0]*n.energyLevels[u]);return r=8.3145,angular.extend({},n,{probability:f,partitionFun:c,numParticles:l,energyParticle:i,energyTotal:i*r*l/1e3,energyMolar:i*r/1e3,entropyParticle:o,entropyTotal:o*r*l,entropyMolar:o*r,temperature:a})},t.partition=function(t,e){var r,n,a,i,o,u,s,l,f,c;if(a=[],i=0,0===t)for(a.push([1,0]),i=1,f=e.energyLevels,o=0,s=f.length;s>o;o++)n=f[o],a.push([0,n]);else for(c=e.energyLevels,r=u=0,l=c.length;l>u;r=++u)n=c[r],a.push([e.degeneracy[r]*Math.exp(-n/t),n]),i+=a[r][0];return[a,i]},t.newEdiff=function(e,r){var n,a,i,o,u,s,l,f;for(f=t.partition(e,r),o=f[0],u=f[1],n=0,a=s=0,l=o.length;l>s;a=++s)i=o[a],i[0]/=u,n+=i[0]*r.energyLevels[a];return r.energyTotal-8.3145*n*r.numParticles/1e3},t.newT=function(e,r){var n,a,i,o,u,s,l,f;if(n=1.5*e,a=.5*e,i=(n+a)/2,u=t.newEdiff(a,r),s=t.newEdiff(n,r),l=t.newEdiff(i,r),!(u>0&&0>s))throw"bug";for(o=0,f=1e3;Math.abs(l)>1e-6;)if(o++,l>0?a=i:n=i,i=(n+a)/2,l=t.newEdiff(i,r),o===f)throw"timeout";return Math.round(i)},t}])}.call(this),function(){angular.module("Boltzmann").config(["$stateProvider","$urlRouterProvider",function(t,e){return t.state("introduction",{url:"/introduction",templateUrl:"introduction.html"}).state("lab",{url:"/lab",templateUrl:"lab.html"}),e.otherwise("/lab")}])}.call(this),function(){angular.module("bm.system",["bm.distribution"]).service("System",["$rootScope","Distribution",function(t,e){var r,n;return n={},r=function(){function r(){this.params={numParticles:1,eLevelType:this.options.eLevelTypes[0],eDist:10,numSubLevels:5,subEDist:10,temperature:103},this.update()}return r.prototype.options={eLevelTypes:[{name:"Equidistant",value:"equidistant"},{name:"Sublevels",value:"sublevels"},{name:"Rotational",value:"rotational"}]},r.prototype.update=function(){return this.result=e.boltzmann(this.params),t.$broadcast("system.update")},r.prototype.addEnergy=function(t){var r;if(t+this.result.energyTotal<0)throw"Not enough energy to give";return this.result.energyTotal+=t,r=this.params.temperature+1e3*t/(8.3145*this.params.numParticles),r>0&&(this.params.temperature=r),this.params.temperature=e.newT(this.params.temperature,this.result),this.update()},r}(),{findOrCreate:function(t){return null==n[t]&&(n[t]=new r(t)),n[t]},all:n}}]).controller("SystemCtrl",["$attrs","$scope","System",function(t,e,r){return e.system=r.findOrCreate(t.systemName),e.plotOptions={relative:!1,eLevels:!0,xmax:1,ymax:200},e.$watch("system.params",function(){return e.system.update()},!0)}]).controller("HeatFlowCtrl",["$scope","System",function(t,e){var r;return r=function(){var r,n,a,i;t.total=0,a=e.all,i=[];for(r in a)n=a[r],i.push(t.total+=n.result.entropyTotal);return i},t.$on("system.update",r),t.amount=.05,t.transfer=function(r,n){var a,i;return a=e.all[r],i=e.all[n],a.addEnergy(-1*t.amount),i.addEnergy(t.amount)}}])}.call(this);