import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:majorproject/views/CreateOrderView.dart';
import 'package:majorproject/views/IndividualOrderView.dart';
import 'package:majorproject/views/UserOrdersView.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String lat="";
  String long="";
bool isLoading=false;
  void redirectToURL({required String query}) async {
    setState(() {
      isLoading = true;
      showDialog(context: context, builder: (context){
        return Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        );
      });


    });
    Position position = await determinePosition();
    setState(() {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      isLoading = false;
      Navigator.of(context).pop();
    });

    var url = Uri.parse(
        "https://www.google.com/maps/search/$query/@$lat,$long,15.25z?entry=ttu");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Facilities Near You",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                )),
            Container(
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: serviceNames.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ServiceCard(
                        callback: () {
                          redirectToURL(query: serviceNames[index]);
                        },
                        serviceTitle: serviceNames[index],
                        serviceImage: serviceImage[index],
                      ),
                    );
                  }),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Services For You",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                )),
            Container(
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CategoryNames.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ServiceCard(
                        callback: () {
                          if(index==0){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                              return CreateOrderView();
                            }));

                          }else{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                              return UserOrdersView();
                            }));
                          }
                        },
                        serviceTitle: CategoryNames[index],
                        serviceImage: CategoryImage[index],
                      ),
                    );
                  }),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Text("More Features Coming Soon...",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                )),
            Hero(
              tag: 'lol',
              child: OpenContainer(closedBuilder: (_,openContainer)=>Container(child: Text("Lol"),), openBuilder: (_,__)=>SizedBox(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Hero(tag: 'lol', child: Text("Llol")),
                      Text("Lo,SD")
                    ],
                  ),
                ),
              )),
            )


          ],
        ),
      ),
    );
  }
}
class ServiceCard extends StatelessWidget {
  final VoidCallback callback;
  final String serviceTitle;
  final String serviceImage;
  const ServiceCard({
    super.key,
    required this.serviceTitle,
    required this.serviceImage,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(8),
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(serviceImage), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
            color: whiteColor,
          ),
          child: Text(
            serviceTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
