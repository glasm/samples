<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8"/>
	<title>gis</title>
	<meta name="description" content="" />

  <style>
	<!--
		html, body { height:100%; overflow:hidden; }
		body { margin:0; }
    #over { position:absolute; left:0; top:0; width:100%; height:100%; z-index:9999; pointer-events:none; }
    #menu { position:absolute; left:20px; top:100%; margin-top:-120px}
    #menu div { float:left; }
    .rshad { -webkit-border-radius:6px; -moz-border-radius:6px; border-radius:6px; -webkit-box-shadow:1px 1px 4px rgba(0, 0, 0, 0.4); -moz-box-shadow:1px 1px 4px rgba(0, 0, 0, 0.4); box-shadow:1px 1px 4px rgba(0, 0, 0, 0.4); }
    .buildbut { background:url(build.png); margin:8px; width:80px; height:80px; cursor:pointer; border:2px solid #0088c0 }
    .bbd { background-position:0 80px; border:2px solid gray }
    .none { display:none }
    #submenu div { background:url(submenu.png); margin:20px 0 0 4px; width:64px; height:64px; cursor:pointer; border:1px solid red }
    #controls { margin:-230px 0 20px -90px; width:50px; }
    .cbut { background:url(controls.png); margin:0 0 4px 4px; width:50px; height:50px; cursor:pointer; border:1px solid gray }
    .cbutpos { background-position:50px 50px }
    .cbutrot { background-position:50px 100px }
    .cbutscl { background-position:50px 150px }
	-->
	</style>
  
  <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.css" />
  
  <script src="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.js"></script>
  <script src="three.js"></script>
  <script src="objloader.js"></script>
  <script type="text/javascript">
  
    function $$(e){return document.getElementById(e);}
  
    var vp = {
      sW: window.innerWidth,
      sH: window.innerHeight,
      build: false
    }
    
    var objlst = ["1","complex","building3","building2"];
    var cobj = -1;
    var sel;
    var mlst = [];
    var map;
      
    function init() {
    
      map = L.map('map', {inertia:false,zoomAnimationThreshold:0}).setView([58.540326337979,31.3152100544], 18);
      L.tileLayer('http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png', {
        maxZoom: 18,
        attribution: 'qwe'
      }).addTo(map);
    
      vp.cam = new THREE.OrthographicCamera( -vp.sW/2, vp.sW/2, vp.sH/2, -vp.sH/2, 100, 50000 );
      vp.cam.position.y = 25000;
      vp.cam.rotation.x = -1.57079;
      vp.scn = new THREE.Scene();
      vp.dummy = new THREE.Object3D();
      vp.scn.add( vp.dummy );
      vp.view = new THREE.WebGLRenderer({antialias:true});
      vp.view.setSize( vp.sW, vp.sH );
      vp.view.setClearColor( 0, 0 );
           
      var light = new THREE.PointLight(0xffffff, 1);
      light.position.set(15000, 15000, 15000);
      vp.cam.add(light);
      
      var ambientLight = new THREE.AmbientLight(0xffffff);
      vp.scn.add(ambientLight);

			vp.redraw = function() {
        
				if(vp.sW != window.innerWidth || vp.sH != window.innerHeight) {
          vp.sW = window.innerWidth;
          vp.sH = window.innerHeight;
          vp.cam.left = -vp.sW/2;
          vp.cam.right = vp.sW/2;
          vp.cam.top = vp.sH/2;
          vp.cam.bottom = -vp.sH/2;
          vp.cam.updateProjectionMatrix();
          vp.view.setSize(vp.sW, vp.sH);
        }
				
        if(sel)
          sel.rotation.y = new Date().getTime() * 0.0002;
        
        var zm = 1/(1<<(18-map.getZoom()));
        for(i=0;i<mlst.length;i++) {
          c1 = map.latLngToContainerPoint(mlst[i].p,map.getZoom());
          mlst[i].m.position.x = c1.x - vp.sW/2;
          mlst[i].m.position.z = c1.y - vp.sH/2;
          mlst[i].m.scale.x = zm;
          mlst[i].m.scale.y = zm;
          mlst[i].m.scale.z = zm;
        }
        vp.view.render( vp.scn, vp.cam );
        
			}		
			vp.redraw();
      
      $$('over').appendChild( vp.view.domElement );

      map.addEventListener('zoomstart', vp.redraw);
      map.addEventListener('move', vp.redraw);
      
      setInterval( vp.redraw, 80 );
      
    }
    
    // искажение
    function skew(g, turn, scale) {

      scale = scale || 1;
    
      var m = new THREE.Matrix4().multiplyMatrices( new THREE.Matrix4().makeRotationY(turn), new THREE.Matrix4().makeScale(scale,scale,scale));    
      for(i=0;i<g.vertices.length;i++) {
        g.vertices[i].applyMatrix4(m);
        g.vertices[i].z -= g.vertices[i].y/1.4;
      }
      
      return g;
    
    }
        
    window.onload = function(e) {
      
      loadNextOBJ();
    
    }
    
    // очередь загрузки
    function loadNextOBJ() {
    
      cobj = -1;
      for(i=0;i<objlst.length;i++)
        if(typeof objlst[i] == 'string' || objlst[i] instanceof String) {
          cobj = i;
          var ldr = new THREE.OBJMTLLoader();
          ldr.load('data/'+objlst[i]+'.obj','data/'+objlst[i]+'.mtl', on_objloaded);
          return;
        }
      $$('menu').setAttribute('class',"");
      init();
      var ldr = new THREE.OBJMTLLoader();
      ldr.load('data/sel.obj','data/sel.mtl',function(obj){sel=obj;vp.scn.add(sel);mlst.push({m:sel,p:map.getCenter()});});    
      
    }
    
    // объект загружен
    function on_objloaded(obj) {
    
      $$('submenu').innerHTML += '<div class="rshad '+objlst[cobj]+'" style="background-position:'+(64*cobj)+'px 0" onmousedown="addObj('+cobj+');"></div>';
      objlst[cobj] = obj;
                  
      loadNextOBJ();

    }
    
    // добавление объекта
    function addObj(t,p) {
    
      if(t>=objlst.length||t<0)
        return;
      
      var obj = createRotSkewObject(t,-0.3);
      
/*      var obj = objlst[t].clone();
      
      for(i=0;i<obj.children.length;i++) {
        g = obj.children[i].geometry;
        for(j=0;j<g.vertices.length;j++) {
          
        }
      }
*/      
      vp.dummy.add( obj );
      mlst.push({m:obj,p:p || map.getCenter()});
      
      
      
      /*scale = scale || 1;
    
      var m = new THREE.Matrix4().multiplyMatrices( new THREE.Matrix4().makeRotationY(turn), new THREE.Matrix4().makeScale(scale,scale,scale));
      for(i=0;i<g.vertices.length;i++) {
        g.vertices[i].applyMatrix4(m);
        g.vertices[i].z -= g.vertices[i].y/1.4;
      }*/
      
      //return g;
      
      selectObj(mlst.length-1);
    
    }
    
    function createRotSkewObject(type,turn) {
    
      var obj = objlst[type].clone();
      
      var m = new THREE.Matrix4().makeRotationY(turn);
      for(i=0;i<obj.children.length;i++)
        with(obj.children[i].geometry)
          for(j=0;j<vertices.length;j++) {
            vertices[j].applyMatrix4(m);
            vertices[j].z -= vertices[j].y/1.4;
          }
      
      return obj;
    
    }
    
    function selectObj(n) {
    
      if(n>=mlst.length||n<0) {
        cobj = -1;
        $$('controls').setAttribute('class','none');
        return;
      }
    
      //document.getElementById('submenu').innerHTML += '<div class="rshad '+objlst[cobj]+'" style="background-position:'+(64*cobj)+'px 0" onmousedown="addObj('+cobj+');"></div>';
      //objlst[cobj] = obj;
      //loadNextOBJ();

    }
    
  </script>
	  
</head>
<body>

  <div id="map" style="width:100%;height:100%"></div>
  <div id="over"></div>
  <div id="menu" class="none">
    <div class="buildbut rshad bbd" onmousedown="vp.build=!vp.build;this.setAttribute('class','buildbut rshad'+(vp.build?'':' bbd'));$$('submenu').setAttribute('class',vp.build?'':'none');"></div>
    <div id="controls" class="none">
      <div class="cbut cbutdel rshad"></div>
      <div class="cbut cbutpos rshad"></div>
      <div class="cbut cbutrot rshad"></div>
      <div class="cbut cbutscl rshad"></div>
    </div>
    <div id="submenu" class="none"></div>
  </div>

</body>
</html>