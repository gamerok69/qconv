# Using Yandex Maps API #

https://qconv.googlecode.com/svn/trunk/etc/ymapsapi.html

```
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Test Maps API</title>
  <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
  <script src="http://api-maps.yandex.ru/1.1/?lang=ru_RU" type="text/javascript"></script>
  <!--<script src="http://api-maps.yandex.ru/1.1/index.xml?key=ANpUFEkBAAAAf7jmJwMAHGZHrcKNDsbEqEVjEUtCmufxQMwAAAAAAAAAAAAvVrubVT4btztbduoIgTLAeFILaQ==" type="text/javascript"></script>-->
</head>
<body>
  <textarea id="txtAddressFrom" rows="1" cols="45">Гродно, Клецкова, 40</textarea><input type="button" onclick="GetLocation(1)" value="Get Location" /><br>
  <textarea id="txtAddressMid" rows="1" cols="45">Гродно, Индурское шоссе, 8</textarea><input type="button" onclick="GetLocation(2)" value="Get Location" /><br>
  <textarea id="txtAddressTo" rows="1" cols="45">Гродно, Космонавтов, 68</textarea><input type="button" onclick="GetLocation(3)" value="Get Location" /><br>
  <br />
  <input type="button" onclick="GetLocation()" value="Get Location" />
  <input type="button" onclick="CreateRoute()" value="Route" />
  <script type="text/javascript">
    <!--
    function GetLocation(numPoint) {
      var addressFrom = document.getElementById("txtAddressFrom").value;
      var addressMid = document.getElementById("txtAddressMid").value;
      var addressTo = document.getElementById("txtAddressTo").value;
      var address;
      address = addressFrom;
      if (numPoint == 2) {
        address = addressMid;
      } else if (numPoint == 3) {
        address = addressTo;
      }

      var mapY = new YMaps.Map(document.getElementById("yandexMap"));
      mapY.setCenter(new YMaps.GeoPoint(23.84, 53.64), 15);
      var geocoder = new YMaps.Geocoder(address);
      YMaps.Events.observe(geocoder, geocoder.Events.Load, function () {
          if (this.length()) {
              mapY.addOverlay(this.get(0));
              mapY.panTo(this.get(0).getGeoPoint())
              var latitude = this.get(0).getGeoPoint().getLat();
              var longitude = this.get(0).getGeoPoint().getLng();
              //alert(address + "- Найдено :" + this.length()+ "(" + latitude.toFixed(2) +", "+ longitude.toFixed(2) +")");
              var infoContainer = document.getElementById("info");
              infoContainer.innerHTML = address + "- Найдено :" + this.length()+ "(" + latitude.toFixed(4) +", "+ longitude.toFixed(4) +")";
          } else {
              alert("Ничего не найдено"); 
          }
      });
    };

    function CreateRoute() {
      var addressFrom = document.getElementById("txtAddressFrom").value;
      var addressMid = document.getElementById("txtAddressMid").value;
      var addressTo = document.getElementById("txtAddressTo").value;
      var mapY = new YMaps.Map(document.getElementById("yandexMap"));
      mapY.setCenter(new YMaps.GeoPoint(23.84, 53.64), 15);
      var router = new YMaps.Router([
                addressFrom,
                addressMid,
                addressTo], [1], {viewAutoApply: 1});

      YMaps.Events.observe(router, router.Events.Success, function() {
            router.getWayPoint(0).setIconContent('Точка отправления');
            router.getWayPoint(1).setIconContent('Точка прибытия');
            //router.getViaPoint(0).setIconContent('Точка остановки');
            mapY.addOverlay(router);
            var routeDistance = router.getDistance()/1000;
            var routeDuration = router.getDuration()/60;
            var infoContainer = document.getElementById("info");
            infoContainer.innerHTML = "Маршрут из " + addressFrom + " в "+ addressTo + " построен!"
              + "<br> Длина: " + routeDistance.toFixed(1) + " км."
              + "<br> Время: " + routeDuration.toFixed(0) + " мин.";
            alert("Done!");
      });

      YMaps.Events.observe(mapY, mapY.Events.Click, function() {
        alert("Маршрут из " + addressFrom + " в "+ addressToLast + " построен!");
      });
    };
    //-->

    function CreateRoute1() {
      var addressFrom = document.getElementById("txtAddressFrom").value;
      var addressTo1 = document.getElementById("txtAddressTo1").value;
      var addressToLast = document.getElementById("txtAddressToLast").value;
      var mapY = new YMaps.Map(document.getElementById("yandexMap"));
      mapY.setCenter(new YMaps.GeoPoint(23.84, 53.64), 15);
      YMaps.route([addressFrom, addressToLast], {
          multiRoute: true
      }).done(function (route) {
          route.options.set("mapStateAutoApply", true);
          mapY.geoObjects.add(route);
      }, function (err) {
          throw err;
      }, this);
    }
  </script>
        
<div id="yandexMap" style="width:500px;height:380px;"></div>
<div id="info"></div>
        
</body>
</html>
```

# Details #

Add your content here.  Format your content with:
  * Text in **bold** or _italic_
  * Headings, paragraphs, and lists
  * Automatic links to other wiki pages