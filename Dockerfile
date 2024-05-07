FROM alpine:latest as base

ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Alabama.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Alaska.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Arizona.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Arkansas.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/California.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Colorado.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Connecticut.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Delaware.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/DistrictofColumbia.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Florida.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Georgia.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Hawaii.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Idaho.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Illinois.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Indiana.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Iowa.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Kansas.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Kentucky.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Louisiana.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Maine.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Maryland.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Massachusetts.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Michigan.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Minnesota.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Mississippi.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Missouri.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Montana.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Nebraska.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Nevada.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/NewHampshire.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/NewJersey.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/NewMexico.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/NewYork.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/NorthCarolina.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/NorthDakota.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Ohio.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Oklahoma.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Oregon.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Pennsylvania.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/RhodeIsland.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/SouthCarolina.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/SouthDakota.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Tennessee.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Texas.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Utah.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Vermont.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Virginia.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Washington.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/WestVirginia.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Wisconsin.geojson.zip /tmp/
ADD https://usbuildingdata.blob.core.windows.net/usbuildings-v2/Wyoming.geojson.zip /tmp/

WORKDIR /tmp/
RUN find ./ -name "*.zip" -exec unzip {} \;
RUN find ./ -name "*.zip" -exec rm {} \;

FROM klokantech/tippecanoe as mbtiles
COPY --from=base /tmp /tmp
WORKDIR /tmp/
RUN find ./ -name "*.geojson" -exec tippecanoe -o {}.mbtiles -l {} -z 14 {} \;
RUN find ./ -name "*.geojson" -exec rm {} \;
RUN tile-join -o Buildings.mbtiles $(ls *.geojson.mbtiles)
RUN find ./ -name "*.geojson.mbtiles" -exec rm {} \;

FROM consbio/mbtileserver:0.9.0
COPY --from=mbtiles /tmp /srv/tiles
EXPOSE 8000
ENTRYPOINT ["/mbtileserver"]
CMD ["--dir", "/srv/tiles", "--verbose"]