# Get LatLng by Address and show it on the map #
```
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Test Maps API</title>
  <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
  <script src="http://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script>
</head>
<body>
  <textarea id="txtAddress" rows="3" cols="45"></textarea>
  <br />
  <input type="button" onclick="GetLocation()" value="Get Location" />
  <script type="text/javascript">
    <!--
    function GetLocation() {
      var geocoder = new google.maps.Geocoder();
      var address = document.getElementById("txtAddress").value;
      geocoder.geocode({ 'address': address }, function (results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        var latitude = results[0].geometry.location.lat();
        var longitude = results[0].geometry.location.lng();
        //alert("Latitude: " + latitude + "\nLongitude: " + longitude);
        var mapProp = {
          center:new google.maps.LatLng(latitude,longitude),
          zoom:17,
          mapTypeId:google.maps.MapTypeId.ROADMAP
        };
        var mapG=new google.maps.Map(document.getElementById("googleMap"),mapProp);
        var mapY=new ymaps.Map("yandexMap", {
          center: [latitude, longitude],
          zoom: 17
        });
      } else {
        alert("Request failed.")
      }
    });
    };
    //-->
  </script>
	
<div id="googleMap" style="width:500px;height:380px;"></div>
<div id="yandexMap" style="width:500px;height:380px;"></div>
	
</body>
</html>
```

# Details #

Googls API is not high detailed as Yandex API for Hrodna.