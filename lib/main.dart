// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:gym_app/pages/home.dart';
import 'package:gym_app/pages/splashScreen.dart';
import 'package:gym_app/style.dart';
import 'package:gym_app/pages/customer_records.dart';
import 'package:gym_app/database_helper/database_helper.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontFamily: "poppins",
          fontSize: 40,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontFamily: "poppins",
          fontSize: 32,
        ),
      )),
      home: const SplashScreen()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> customerDataList = [];
  int? members;
  int? active;
  int? expired;

  PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  @override
  void initState() {
    checkExpiredCustomers();
    super.initState();
  }

  var pages = [const myHome(), const CustomerRecords()];
//grey color 60,60,60
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var maxwidth = MediaQuery.of(context).size.width;
    var maxheight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          title: Container(
            // color: Colors.black,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("POWER FITNESS", style: headlineLarge()),
          ),
          centerTitle: true,
        ),
        //learn more about page view
        body: PageView(
          controller: pageController,
          children: [myHome(), CustomerRecords()],
          onPageChanged: (value) {
            currentPage = value;
            setState(() {});
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          height: 6.25 * maxheight / 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromARGB(255, 60, 60, 60)),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (currentPage != 0) {
                      setState(() {
                        currentPage = 0;
                        pageController.animateToPage(currentPage,
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.linear);
                      });
                    }
                  },
                  child: Container(
                      height: maxheight / 16,
                      decoration: currentPage == 0
                          ? bottomNavBarSelected()
                          : bottomNavBarNotSelected(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 28,
                          ),
                          Text(
                            "Home",
                            style: style1().copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (currentPage != 1) {
                      setState(() {
                        currentPage = 1;
                        pageController.animateToPage(currentPage,
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.linear);
                      });
                    }
                  },
                  child: Container(
                      height: maxheight / 16,
                      decoration: currentPage == 1
                          ? bottomNavBarSelected()
                          : bottomNavBarNotSelected(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28,
                          ),
                          Text(
                            "Search",
                            style: style1().copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> checkExpiredCustomers() async {
    members = 0;
    active = 0;
    expired = 0;
    DateTime currentDate = DateTime.now();
    List<Map<String, dynamic>> localCustomerDataList = [];
    localCustomerDataList.addAll(await DatabaseHelper.instance.quearyAll());

    int noOfCustomers = localCustomerDataList.length;
    members = noOfCustomers;
    for (int i = 0; i < noOfCustomers; i++) {
      Map<String, dynamic> currentCustomerMap = localCustomerDataList[
          i]; // this is immutable, cant make changes to it, only we can read
      Map<String, dynamic> mutableCustomerMap = Map.from(currentCustomerMap);
      DateTime currentDueDate = DateTime.parse(currentCustomerMap["dueDate"]);
      if (currentDueDate.isBefore(currentDate)) {
        mutableCustomerMap["status"] = "Expired";
        expired = expired! + 1;
      } else {
        mutableCustomerMap["status"] = "Active";
      }
      active = members! - expired!;
      await DatabaseHelper.instance.update(mutableCustomerMap);
      setState(() {});
    }
  }
}
