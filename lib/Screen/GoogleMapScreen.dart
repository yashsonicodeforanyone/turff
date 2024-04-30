import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:turfapp/Screen/BookingScreen.dart';
import '../MyConstants/ShImageConstants.dart';
import '../MyModel/AllTurfModels.dart';

class MyMapScreen extends StatefulWidget {
  List<TurfModel> list_turf = [];
  String cutomer_id;
  String current_latitude;
  String current_longitude;

  MyMapScreen({
    Key? key,
    required this.list_turf,
    required this.cutomer_id,
    required this.current_latitude,
    required this.current_longitude,
  });

  @override
  State<MyMapScreen> createState() => MyMapScreenState();
}

class MyMapScreenState extends State<MyMapScreen> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 150.0;

  LatLng? _latLng;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.72151681203537, 75.8421168155543),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(22.66215, 75.9035),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Marker> _marker = [];
  final List<Marker> _list = const [
    Marker(
        markerId: MarkerId("marker_1"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(22.7507104, 75.8954989)),
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 80.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(25.42796133580664, 80.885749655962),
        infoWindow: InfoWindow(
          title: 'Location 1',
        )),
    Marker(
        markerId: MarkerId('3'),
        position: LatLng(20.42796133580664, 73.885749655962),
        infoWindow: InfoWindow(
          title: 'Location 2',
        )),
  ];

  _buildPageView(List<String> images) {
    return Container(
      height: _boxHeight,
      child: PageView.builder(
          itemCount: images.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                images[index],
                height: 500,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildCircleIndicator(int length) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

//1
  void _showModalBottomSheet(context, TurfModel turfModel) {
    var width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.only(top: 0, right: 0, left: 0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => LArgerImageScreen(imageUrl:  hotelslist[index].img),
                          // )

                          // );
                        },
                        child: Stack(
                          children: <Widget>[
                            _buildPageView(turfModel.images),
                            _buildCircleIndicator(turfModel.images.length),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width * 0.85,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "" + turfModel.turfName,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyMapScreen(list_turf: list_turf,)));
                                            },
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.green,
                                              size: 20,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.green,
                                                size:
                                                    15, // You can adjust the size according to your needs
                                              ),
                                            ),
                                            Container(
                                                width: width * 0.5,
                                                child: Text(
                                                  "" +
                                                      turfModel.address +
                                                      " | " +
                                                      turfModel.distance
                                                          .toStringAsFixed(2) +
                                                      " K.M",
                                                  style: TextStyle(
                                                      color: Colors.black38,
                                                      fontSize: 15),
                                                )),
                                            //Text(" | "+list_turf[index].distance.toStringAsFixed(2)+" K.M",style: TextStyle(color: Colors.black38,fontSize: 15),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .screen_rotation_alt_sharp,
                                                    size: 18,
                                                  ),
                                                  Text(turfModel.squarefit +
                                                      " sq. ft.")
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.85,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            turfModel.sportType
                                                    .contains("baseball")
                                                ? Icon(
                                                    Icons.sports_baseball,
                                                    color: Colors.black,
                                                  )
                                                : Icon(
                                                    Icons.sports_baseball,
                                                    color: Colors.blueGrey,
                                                  ),
                                            turfModel.sportType
                                                    .contains("cricket")
                                                ? Icon(Icons.sports_cricket)
                                                : Icon(
                                                    Icons.sports_cricket,
                                                    color: Colors.blueGrey,
                                                  ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            turfModel.facilities!
                                                    .contains("shelter")
                                                ? Icon(
                                                    Icons.night_shelter_rounded,
                                                    color: Colors.green,
                                                  )
                                                : Container(),
                                            turfModel.facilities!
                                                    .contains("food")
                                                ? Icon(
                                                    Icons.fastfood,
                                                    color: Colors.green,
                                                  )
                                                : Container(),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // InkWell(
                            //
                            //   onTap: (){
                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>MyMapScreen()));
                            //   },
                            //     child: Icon(Icons.location_on,color: Colors.green,size: 35,))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingScreen(
                                        turf_id: turfModel.id,
                                        turfName: turfModel.turfName,
                                        customer_id: widget.cutomer_id,
                                        current_latitude:
                                            widget.current_latitude,
                                        current_longitude:
                                            widget.current_longitude,
                                      )));
                        },
                        child: Center(
                          child: Container(
                            width: width * 0.7,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "Book Now",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Set<Marker> _setMarkers() {
    // Create a set to hold the markers
    Set<Marker> markers = Set();

    // Add markers to the set

    if (widget.list_turf.isNotEmpty) {
      for (int i = 0; i < widget.list_turf.length; i++) {
        markers.add(Marker(
            //2
            onTap: () {
              _showModalBottomSheet(context, widget.list_turf[i]);
            },
            markerId: MarkerId('$i'),
            position: LatLng(double.parse(widget.list_turf[i].latitude),
                double.parse(widget.list_turf[i].longitude)),
            infoWindow: InfoWindow(
              title: widget.list_turf[i].turfName,
            )));
      }
    }

    //
    // markers.add(  Marker(
    //   onTap:(){ _showModalBottomSheet(context);},
    // markerId: MarkerId('1'),
    // position: LatLng(22.733594633810732, 75.84995674689509),
    // infoWindow: InfoWindow(
    // title: 'My Position',
    // )
    // ));
    //
    // markers.add(Marker(
    //     onTap:(){ _showModalBottomSheet(context);},
    // markerId: MarkerId('2'),
    // position: LatLng(22.721239718037836, 75.84190223883715),
    // infoWindow: InfoWindow(
    // title: 'Location 1',
    // )
    // ));
    //
    // markers.add( Marker(
    //     onTap:(){ _showModalBottomSheet(context);},
    // markerId: MarkerId('3'),
    // position: LatLng(22.716806137764163, 75.84919784722001),
    // infoWindow: InfoWindow(
    // title: 'Location 2',
    // )
    // ));

    // Return the set of markers

    return markers;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          circles: circles,
          // markers: <Marker>{
          //   _setMarker()
          // },

          // markers: _setMarker(),
          markers: _setMarkers(),

          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: const Text('To the lake!'),
        //   icon: const Icon(Icons.directions_boat),
        // ),
      ),
    );
  }

  Set<Circle> circles = Set.from([
    Circle(
        strokeWidth: 1,
        strokeColor: Colors.blue,
        circleId: CircleId("Cicle_1"),
        center: LatLng(22.72151681203537, 75.8421168155543),
        radius: 4000)
  ]);

  _setMarker() {
    // return _marker;

    return Marker(
        markerId: MarkerId("marker_1"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(22.7507104, 75.8954989));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    _latLng = LatLng(_locationData.latitude!, _locationData.longitude!);

    _kGooglePlex = CameraPosition(
      target: _latLng!,
      zoom: 14.4746,
    );
    setState(() {});
//3
//     _showModalBottomSheet(context,widget.list_turf[0]);
  }
}
