function $$(e){return document.getElementById(e)}
function $$$(e){return document.createElement(e)}
var cc=$$$("canvas");
var wgld = window.WebGLRenderingContext?1+(cc.getContext("webgl")?2:cc.getContext("experimental-webgl")?1:0):0;
requestAnimationFrame=function(q){window.setTimeout(q,1e3/5)}
var h=document.getElementsByTagName("head")[0];
var s=$$$("script");
s.type="text/javascript";
s.src="js/scene.js";
h.appendChild(s);
