// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gym_app/style.dart';
import 'package:gym_app/database_helper/database_helper.dart';
import 'package:gym_app/pages/enroll_page.dart';

class myHome extends StatefulWidget {
  const myHome({super.key});

  @override
  State<myHome> createState() => _myHomeState();
}

class _myHomeState extends State<myHome> {
  List<Map<String, dynamic>> customerDataList = [];
  int? members;
  int? active;
  int? expired;
  int? currentMonthEarnings;

  int currentPage = 0;
  @override
  void initState() {
    UpdateDisplayData();
    // UpdateMonthlyEarnings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var maxwidth = MediaQuery.of(context).size.width;
    var maxheight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      // color: Colors.blueAccent,
      child: SizedBox(
        height: 84 * maxheight / 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back",
                    style: style1().copyWith(fontSize: 20),
                  ),
                  Text(
                    "Hrushikesh",
                    style: style1()
                        .copyWith(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                      Text(
                        "Admin",
                        style: style1().copyWith(fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: maxheight / 50,
                  ),
                  Container(
                      // color: Colors.cyan[400],
                      height: maxheight / 5,
                      width: maxwidth - 16,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 15, 154, 173),
                                Color.fromARGB(255, 123, 214, 92)
                                // Color.fromARGB(255, 101, 0, 252),
                                // Color.fromARGB(255, 0, 242, 255),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(maxwidth / 20,
                            maxheight / 25, maxwidth / 20, maxheight / 25),
                        // color: Colors.blue,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("₹ $currentMonthEarnings",
                                    style: style1().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40)),
                                Text(
                                  " Present Month Earnings",
                                  style: style1().copyWith(fontSize: 16),
                                )
                              ],
                            ),
                            // Image.asset("assets/images/d.png")
                          ],
                        ),
                      )),
                  SizedBox(
                    height: maxheight / 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: maxheight / 15,
                            width: maxwidth / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 60, 60, 60)),
                            child: Center(child: Text("$members")),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Members",
                            style: style1().copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: maxheight / 15,
                            width: maxwidth / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 60, 60, 60)),
                            child: Center(child: Text("$active")),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Active",
                            style: style1().copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: maxheight / 15,
                            width: maxwidth / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 60, 60, 60)),
                            child: Center(child: Text("$expired")),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Expired",
                            style: style1().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                // color: Colors.white,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                width: maxwidth - 40,
                height: maxheight / 5 * 1.5,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: bottomNavBarSelected()
                        .copyWith(borderRadius: BorderRadius.circular(50)),
                    height: maxheight / 14,
                    width: maxheight / 14,
                    child: Center(
                      child: IconButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EnrollPage(
                                        editCustomer: false,
                                        editCustomerid: -1)));
                            UpdateDisplayData();
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: maxheight / 20,
                          )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> UpdateDisplayData() async {
    members = 0;
    active = 0;
    expired = 0;
    currentMonthEarnings = 0;
    DateTime currentDate = DateTime.now();
    List<Map<String, dynamic>> localCustomerDataList = [];
    localCustomerDataList.addAll(await DatabaseHelper.instance.quearyAll());

    int noOfCustomers = localCustomerDataList.length;
    members = noOfCustomers;
    for (int i = 0; i < noOfCustomers; i++) {
      Map<String, dynamic> currentCustomerMap = localCustomerDataList[
          i]; // this is immutable, cant make changes to it, only we can read
      Map<String, dynamic> mutableCustomerMap = Map.from(currentCustomerMap);
      DateTime currentPaymentDate =
          DateTime.parse(currentCustomerMap["paymentDate"]);
      DateTime currentDueDate = DateTime.parse(currentCustomerMap["dueDate"]);
      if (currentDueDate.isBefore(currentDate)) {
        mutableCustomerMap["status"] = "Expired";
        expired = expired! + 1;
      } else {
        mutableCustomerMap["status"] = "Active";
      }
      if (currentPaymentDate.month == currentDate.month) {
        currentMonthEarnings =
            currentMonthEarnings! + int.parse(currentCustomerMap["paidAmount"]);
      }
      active = members! - expired!;
      await DatabaseHelper.instance.update(mutableCustomerMap);
      // print(currentMonthEarnings);
      setState(() {});
    }
  }
}
