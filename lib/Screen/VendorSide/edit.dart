import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  int slectedStep = 2; // Initial step
  int selectedIndex = 0;
  List<String> selectFacilities = [];

  void handleTap(String sportType) {
    setState(() {
      selectedIndex = sportType == "baseball" ? 1 : 2;
    });
  }

  void handleTapFacilities(String facility) {
    setState(() {
      if (selectFacilities.contains(facility)) {
        selectFacilities.remove(facility);
      } else {
        selectFacilities.add(facility);
      }
    });
  }

  void _validateAndProceed() {
    if (slectedStep == 2) {
      if (selectedIndex == 0) {
        _showErrorDialog("Please select a sport type.");
        return;
      }
    } else if (slectedStep == 3) {
      if (selectFacilities.isEmpty) {
        _showErrorDialog("Please select at least one facility.");
        return;
      }
    }

    // Proceed to next step or do something else
    setState(() {
      slectedStep++;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final verticalmargin20 = SizedBox(height: 20);

    return Scaffold(
      appBar: AppBar(
        title: Text("Step Form"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: slectedStep == 2 ? true : false,
            child: Container(
              height: height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Select Sport Type",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  verticalmargin20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          handleTap("baseball");
                        },
                        child: Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  Icon(
                                    selectedIndex == 1 ? Icons.check_circle : Icons.circle_outlined,
                                    color: selectedIndex == 1 ? Colors.green : Colors.black12,
                                  )
                                ],
                              ),
                              Icon(Icons.sports_baseball, size: 50, color: selectedIndex == 1 ? Colors.green : Colors.black12),
                              Text(
                                "Baseball",
                                style: TextStyle(fontSize: 20, color: selectedIndex == 1 ? Colors.green : Colors.black12),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black12, width: 1),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          handleTap("cricket");
                        },
                        child: Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  Icon(
                                    selectedIndex == 2 ? Icons.check_circle : Icons.circle_outlined,
                                    color: selectedIndex == 2 ? Colors.green : Colors.black12,
                                  )
                                ],
                              ),
                              Icon(Icons.sports_cricket, size: 50, color: selectedIndex == 2 ? Colors.green : Colors.black12),
                              Text(
                                "Cricket",
                                style: TextStyle(fontSize: 20, color: selectedIndex == 2 ? Colors.green : Colors.black12),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black12, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: slectedStep == 3 ? true : false,
            child: Container(
              height: height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Select Facilities",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  verticalmargin20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          handleTapFacilities("shelter");
                        },
                        child: Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  Icon(
                                    selectFacilities.contains("shelter") ? Icons.check_circle : Icons.circle_outlined,
                                    color: selectFacilities.contains("shelter") ? Colors.green : Colors.black12,
                                  )
                                ],
                              ),
                              Icon(Icons.night_shelter_rounded, size: 50, color: selectFacilities.contains("shelter") ? Colors.green : Colors.black12),
                              Text(
                                "Shelter",
                                style: TextStyle(fontSize: 20, color: selectFacilities.contains("shelter") ? Colors.green : Colors.black12),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black12, width: 1),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          handleTapFacilities("food");
                        },
                        child: Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  Icon(
                                    selectFacilities.contains("food") ? Icons.check_circle : Icons.circle_outlined,
                                    color: selectFacilities.contains("food") ? Colors.green : Colors.black12,
                                  )
                                ],
                              ),
                              Icon(Icons.fastfood, size: 50, color: selectFacilities.contains("food") ? Colors.green : Colors.black12),
                              Text(
                                "Food",
                                style: TextStyle(fontSize: 20, color: selectFacilities.contains("food") ? Colors.green : Colors.black12),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black12, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _validateAndProceed,
            child: Text("Next"),
          ),
        ],
      ),
    );
  }
}
