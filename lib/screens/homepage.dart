import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:indiacovid/Api/covid_api.dart';
import 'package:indiacovid/models/covid.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Covid covid;
  Statewise statewise;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    _getResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID19",style: TextStyle(fontSize: 25,letterSpacing: 4),),
        leading: Icon(Icons.whatshot,color: Colors.red,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),

        ),
        elevation: 0,
        centerTitle: true,
        titleSpacing: 5,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _getResult,
        child: covid != null
            ? ListView(
                children: covid.statewise.map((s) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ExpansionTile(
                      backgroundColor: Colors.black45,
                      leading: Icon(Icons.keyboard_arrow_down),
                      title: Text(
                        s.state.toUpperCase(),
                        style: TextStyle(fontSize: 20, color: Colors.white70,fontWeight: FontWeight.w600),
                      ),
                      trailing: Text(
                        s.confirmed,
                        style: TextStyle(fontSize: 20, color: Colors.redAccent),
                      ),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("ACTIVE",style: TextStyle(color: Colors.blue),),
                            Text(s.active)
                          ],
                        ),
                        Container(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("DEATH",style: TextStyle(color: Colors.orange[500]),),
                            Text(s.deaths)
                          ],
                        ),
                        Container(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("RECOVERED",style: TextStyle(color: Colors.green[500]),),
                            Text(s.recovered)
                          ],
                        ),
                        Container(height: 20,)
                      ],

                    ),
                  ),
                );
              }).toList())
            : Center(child: Container(child: Lottie.asset('assets/data.json'),width: 200,height: 200,),),
      ),
    );
  }

  void _getResult() async {
    var response = await http.get(apiURL);

    var body = response.body;

    var decodeJson = jsonDecode(body);

    covid = Covid.fromJson(decodeJson);

    setState(() {

    });
    _refreshController.loadComplete();
//    print(body);
  }
}

/*
Row(
//            children: <Widget>[
////              Column(
////                children: <Widget>[
////                  Image(
////                    image: AssetImage("assets/virus.png"),
////                  ),
////                  Text(statewise.confirmed),
////                ],
////              ),
////              Column(
////                children: <Widget>[
////                  Image(
////                    image: AssetImage("assets/virus.png"),
////                  ),
////                  Text(statewise.confirmed),
////                ],
////              ),
////              Column(
////                children: <Widget>[
////                  Image(
////                    image: AssetImage("assets/virus.png"),
////                  ),
////                  Text(statewise.confirmed),
////                ],
////              ),
////              Column(
////                children: <Widget>[
////                  Image(
////                    image: AssetImage("assets/virus.png"),
////                  ),
////                  Text(statewise.confirmed),
////                ],
////              ),
//            ],
//          ),
 */
