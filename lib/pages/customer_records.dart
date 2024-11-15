// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
import 'dart:async';
// import 'dart:ffi';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_sms/flutter_native_sms.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:direct_flutter_sms/direct_flutter_sms.dart';
// import 'package:another_telephony/telephony.dart';
// import 'package:another_telephony/telephony.dart';
// import 'package:flutter_sms/flutter_sms.dart';

// import 'package:sms_advanced/sms_advanced.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:gym_app/custom_widgets/card.dart';
// import 'package:gym_app/custom_widgets/card2.dart';
// import 'package:gym_app/custom_widgets/cardV3.dart';
import 'package:gym_app/custom_widgets/cardStful.dart';
import 'package:gym_app/database_helper/database_helper.dart';
import 'package:gym_app/pages/enroll_page.dart';
import 'package:gym_app/style.dart';
import 'package:gym_app/custom_widgets/snack_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class CustomerRecords extends StatefulWidget {
  const CustomerRecords({super.key});

  @override
  State<CustomerRecords> createState() => _CustomerRecords();
}

class _CustomerRecords extends State<CustomerRecords> {
  // final _ussdPhoneCallSmsPlugin = UssdPhoneCallSms();
  // final Telephony telephony = Telephony.instance;
  FlutterNativeSms sms = FlutterNativeSms();
  List<Map<String, dynamic>> customerDataList = [];

  bool isLoading = true;
  bool activeFilter = false;
  bool expiredFilter = false;
  bool dueFilter = false;
  bool toggleOpacity = false;
  bool toggleDeleteContainer = false;
  String deleteName = "";
  int? deleteId;
  bool toggleMessageContainer = false;
  String messageName = "";
  String messageNumber = "";
  TextEditingController searchInput = TextEditingController();
  String filter = "All";

  bool messageCheckBox = true;
  bool whatsappCheckBox = false;
  TextEditingController messageText = TextEditingController();

  Timer? searchTimer;
  double? customerCardWidth;
  bool multiCardSelect = false;
  List<int> multiSelectedIds = [];
  bool selectAllCheckBox = false;
  int numberOfCardsSelected = 0;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  int totalCardsInCurrentPage = 0;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    // double deviceHeight = MediaQuery.of(context).size.height;
    totalCardsInCurrentPage = 0; //this is must for the select all functions
    if (multiCardSelect) {
      customerCardWidth = deviceWidth / 3 - 96;
    } else {
      //why 48 why not 40 what is causing overflow?
      customerCardWidth = deviceWidth / 3 - 48;
    }
    return Stack(children: [
      Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customers",
              style:
                  style3().copyWith(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchInput,
                        style: style3().copyWith(fontSize: 18),
                        cursorColor: lightgreen,
                        cursorHeight: 26,
                        onChanged: (value) {
                          rebuildAfterTypingStops();
                        },
                        decoration: textfieldstyle1(Icons.search_outlined,
                                "Search Customer", Colors.white)
                            .copyWith(
                                suffix: IconButton(
                          onPressed: () {
                            searchInput.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.grey[800],
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              activeFilter = !activeFilter;
                              expiredFilter = false;
                              dueFilter = false;
                              multiSelectedIds.clear();
                              multiCardSelect = false;
                              selectAllCheckBox = false;
                              filter = activeFilter ? "Active" : "All";
                              numberOfCardsSelected = 0;
                              // totalCardsInCurrentPage = 0;
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: activeFilter
                                    ? Color.fromARGB(255, 23, 55, 83)
                                    : Colors.grey[800]),
                            child: Text(
                              "Active",
                              style: style4().copyWith(
                                  fontSize: 16,
                                  color: activeFilter
                                      ? Colors.white
                                      : Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                activeFilter = false;
                                expiredFilter = !expiredFilter;
                                dueFilter = false;
                                multiSelectedIds.clear();
                                multiCardSelect = false;
                                selectAllCheckBox = false;
                                numberOfCardsSelected = 0;
                                // totalCardsInCurrentPage = 0;
                                filter = expiredFilter ? "Expired" : "All";
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: expiredFilter
                                      ? Color.fromARGB(255, 23, 55, 83)
                                      : Colors.grey[800]),
                              child: Text(
                                "Expired",
                                style: style4().copyWith(
                                    fontSize: 16,
                                    color: expiredFilter
                                        ? Colors.white
                                        : Colors.grey),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                activeFilter = false;
                                expiredFilter = false;
                                dueFilter = !dueFilter;
                                //clearing all the multicard select ids
                                multiSelectedIds.clear();
                                //setting the multi select feature to false
                                multiCardSelect = false;
                                selectAllCheckBox = false;
                                numberOfCardsSelected = 0;
                                // totalCardsInCurrentPage = 0;
                                filter = dueFilter ? "Due" : "All";
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: dueFilter
                                    ? Color.fromARGB(255, 23, 55, 83)
                                    : Colors.grey[800],
                              ),
                              child: Text(
                                "Due",
                                style: style4().copyWith(
                                    fontSize: 16,
                                    color:
                                        dueFilter ? Colors.white : Colors.grey),
                              ))
                        ],
                      ),
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            if (multiCardSelect)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            showMultiDeleteContiner();
                          },
                          icon: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.white,
                          )),
                      if (expiredFilter) //diaplay the message button only when the expired filter is selected
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.message_outlined,
                              color: Colors.white,
                            ))
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Select all",
                        style: style4().copyWith(fontSize: 16),
                      ),
                      Checkbox(
                        value: selectAllCheckBox,
                        onChanged: (value) {
                          selectAllCheckBox = !selectAllCheckBox;
                          multiSelectedIds.clear();
                          numberOfCardsSelected = 0;
                          if (!selectAllCheckBox) {
                            multiCardSelect = false;
                          }
                          setState(() {});
                        },
                        side: BorderSide(color: Colors.grey.shade400, width: 1),
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            Expanded(
              flex: 10,
              child: Container(
                // color: Colors.amber,
                child: (customerDataList.isNotEmpty && !isLoading)
                    ? GridView.builder(
                        //only for gridview
                        //Delete the grid delegate for listview
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          mainAxisSpacing: 1, // Spacing between rows
                          crossAxisSpacing: 10, // Spacing between columns
                          childAspectRatio: 4.5, // Aspect ratio of each item
                        ),
                        itemBuilder: (context, index) {
                          Map<String, dynamic> currentCustomer =
                              customerDataList[index];
                          bool filterCurrentCustomer = filterCustomer(
                                  filter,
                                  currentCustomer["status"],
                                  currentCustomer["dueAmount"]) &&
                              searchCustomer(currentCustomer["fullName"],
                                  currentCustomer["phoneNumber"]);
                          Widget displayWidget;
                          // bool currentCheckBoxValue;
                          // if (!multiCardSelect) {
                          //   currentCheckBoxValue = false;
                          // }
                          if (filterCurrentCustomer) {
                            ++totalCardsInCurrentPage;
                            displayWidget = Column(
                              children: [
                                CustomerCard(
                                    id: currentCustomer["id"],
                                    fullName: currentCustomer["fullName"],
                                    phoneNumber: currentCustomer["phoneNumber"],
                                    emailId: currentCustomer["emailId"],
                                    membership: currentCustomer["membership"],
                                    paidAmount: currentCustomer["paidAmount"],
                                    dueAmount: currentCustomer["dueAmount"],
                                    paymentDate: currentCustomer["paymentDate"],
                                    duedate: currentCustomer["dueDate"],
                                    paymentMode: currentCustomer["paymentMode"],
                                    status: currentCustomer["status"],
                                    cardWidth: customerCardWidth,
                                    multiCardSelect: multiCardSelect,
                                    // checkBoxValue: currentCheckBoxValue,
                                    selectAll: selectAllCheckBox,
                                    onDelete: showDeleteContainer,
                                    onEdit: editCustomer,
                                    onMessage: showMessageContainer,
                                    turnOnMultiCardSelectFunc:
                                        turnOnMultiCardSelectFunc,
                                    addIdToSelectedIdList: addIdToSelectedIds,
                                    removeIdFromSelectedIdList:
                                        removeIdFromSelectedIds,
                                    turnOffSelectAllCheckBox:
                                        turnOffSelectAllCheckBox),
                                SizedBox(
                                  height: 4,
                                )
                              ],
                            );
                          } else {
                            displayWidget = SizedBox
                                .shrink(); // Returns a zero-sized widget for hidden items
                          }
                          return displayWidget;
                        },
                        itemCount: customerDataList.length,
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
      Visibility(
          visible: toggleOpacity,
          child: InkWell(
            onTap: () {
              toggleOpacity = false;
              toggleDeleteContainer = false;
              toggleMessageContainer = false;
              setState(() {});
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          )),
      Visibility(
        visible: toggleDeleteContainer,
        child: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            padding: const EdgeInsets.all(12),
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 60, 60, 60),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delete Confirmation",
                  style:
                      style1(fsize: 26).copyWith(fontWeight: FontWeight.bold),
                ),
                multiCardSelect
                    ? Text(
                        "Delete ${multiSelectedIds.length} record(s)? This action cannot be undone.",
                        style: style1().copyWith(fontSize: 18),
                      )
                    : Text(
                        "Delete $deleteName's record? This action cannot be undone.",
                        style: style1().copyWith(fontSize: 18),
                      ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          toggleDeleteContainer = false;
                          toggleOpacity = false;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 97, 127, 128),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: style3().copyWith(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (multiCardSelect) {
                            await deleteMultipleCustomers();
                            multiSelectedIds.clear();
                            multiCardSelect = false;
                            selectAllCheckBox = false;
                            numberOfCardsSelected = 0;
                          } else {
                            await deleteCustomer(deleteId!);
                          }
                          //  ScaffoldMessenger.of(context).showSnackBar(
                          // customSnackBar("Customer deleted"));
                          toggleDeleteContainer = false;
                          toggleOpacity = false;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 90, 95),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              "Delete",
                              style: style3().copyWith(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      //message container
      Visibility(
        visible: toggleMessageContainer,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 340,
            ),
            child: Container(
              // height: 200,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 60, 60, 60),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Message",
                      style: style1(fsize: 26)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "To: $messageName ($messageNumber)",
                    style: style1()
                        .copyWith(fontSize: 18, color: Colors.grey[400]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    // height: 90,
                    child: TextField(
                      controller: messageText,
                      // enabled: true,
                      keyboardType: TextInputType.multiline,
                      // minLines: 8,
                      maxLines: null,
                      cursorColor: lightGrey,
                      decoration: textfieldstyle2(
                          Icons.message_outlined, "Message", lightGrey),
                      style: style3(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: messageCheckBox,
                            onChanged: (value) {
                              messageCheckBox = !messageCheckBox;
                              setState(() {});
                            },
                            side: BorderSide(
                                color: Colors.grey.shade400, width: 2),
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                          ),
                          Icon(
                            Icons.sms_outlined,
                            size: 30,
                            color: Colors.blue[600],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: whatsappCheckBox,
                            onChanged: (value) {
                              whatsappCheckBox = !whatsappCheckBox;
                              setState(() {});
                            },
                            side: BorderSide(
                                color: Colors.grey.shade400, width: 2),
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                          ),
                          FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 30,
                            color: Colors.green,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            toggleMessageContainer = false;
                            toggleOpacity = false;
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 97, 127, 128),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: style3().copyWith(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            toggleMessageContainer = false;
                            toggleOpacity = false;
                            sendMessage(messageText.text, messageNumber);
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade400,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                "Send",
                                style: style3().copyWith(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }

  bool filterCustomer(String filter, String customerStatus, String dueAmount) {
    if (filter == "All") {
      return true;
    }
    if (filter == "Due") {
      if (int.parse(dueAmount) > 0) {
        return true;
      } else {
        return false;
      }
    }
    if (filter == customerStatus) {
      return true;
    } else {
      return false;
    }
  }

  void rebuildAfterTypingStops() {
    if (searchTimer?.isActive ?? false) searchTimer!.cancel();
    searchTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  bool searchCustomer(String fullName, String phoneNumber) {
    fullName = fullName.toLowerCase();
    if (searchInput.text.trim().isEmpty) {
      return true;
    } else {
      if (fullName.contains(searchInput.text.toLowerCase().trim()) ||
          phoneNumber.contains(searchInput.text.trim())) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> loadData() async {
    customerDataList.addAll(await DatabaseHelper.instance.quearyAll());
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteCustomer(int selectedId) async {
    // ignore: unused_local_variable
    int numberOfRowsEffected;
    setState(() {
      customerDataList.clear();
      isLoading = true;
    });
    numberOfRowsEffected = await DatabaseHelper.instance.delete(selectedId);
    await loadData();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar("Customer deleted"));
    }
  }

  void showDeleteContainer(int selectedId, String selectedName) {
    toggleOpacity = true;
    toggleDeleteContainer = true;
    deleteName = selectedName;
    deleteId = selectedId;
    setState(() {});
  }

  void editCustomer(int selectedId) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EnrollPage(editCustomer: true, editCustomerid: selectedId)));
    setState(() {
      customerDataList.clear();
      isLoading = true;
    });
    loadData();
  }

  void showMessageContainer(String currentPhoneNumber, String currentName,
      bool activeStatus, String dueAmount, String currentDate) {
    toggleOpacity = true;
    toggleMessageContainer = true;
    messageName = currentName;
    messageNumber = "+91$currentPhoneNumber";
    messageText.text =
        cookMessage(currentName, activeStatus, dueAmount, currentDate);
    setState(() {});
  }

  void sendMessage(String typedMessage, String phoneNumber) async {
    if (messageCheckBox) {
      var status = await Permission.sms.status;
      if (status.isDenied ||
          status.isRestricted ||
          status.isPermanentlyDenied) {
        // Request the permission if it’s not granted
        status = await Permission.sms.request();
      } else {
        // print("SMS permission is already granted.");
        try {
          var result = await sms.send(
            phone: phoneNumber,
            smsBody: typedMessage,
            sim: '0',
            reportByToast: false,
          );
          if (kDebugMode) {
            print("\n\n\n\n\n\n");
            print("result: $result");
            print("\n\n\n\n\n\n");
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(customSnackBar("Failed to send sms"));
          }
        }
      }
    }
    if (whatsappCheckBox) {
      //send whatsapp message
      final Uri whatsappUri = Uri.parse(
          "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(typedMessage)}");
      try {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (mounted) {
          // which checks whether the widget is still in the widget tree before trying to show the SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar("Failed to open Whatsapp"),
          );
        }
      }
      whatsappCheckBox = false;
    }
  }

  String cookMessage(String currentName, bool activeStatus, String dueAmount,
      String currentDate) {
    String cookedMessage = "";
    bool isDue = (int.parse(dueAmount) == 0 ? false : true);
    //set max characters to 160
    if (!activeStatus && isDue) {
      cookedMessage =
          "Hi $currentName, your membership has expired on $currentDate.\nKindly renew\nDue Amount: ₹$dueAmount.\nIgnore if paid.\nThank you!";
    } else if (!activeStatus) {
      cookedMessage =
          "Hi $currentName, your membership has expired on $currentDate.\nKindly renew to keep up the momentum. Thank you!";
    } else {
      cookedMessage =
          "Hi $currentName,Due Amount: ₹$dueAmount.Ignore if paid.Thank you!";
    }
    return cookedMessage;
  }

  void turnOnMultiCardSelectFunc() {
    multiCardSelect = true;
    if (kDebugMode) {
      print("multicardselect:$multiCardSelect");
    }

    setState(() {});
  }

//we need to find a way to replace the 4 with total number of cards in the page
//one way is to set totalCardsInPage=0 in every setstate function
  void addIdToSelectedIds(int currentId) {
    if (numberOfCardsSelected < totalCardsInCurrentPage) {
      ++numberOfCardsSelected;
      multiSelectedIds.add(currentId);
      if (numberOfCardsSelected >= 1 &&
          numberOfCardsSelected == totalCardsInCurrentPage &&
          !selectAllCheckBox) {
        selectAllCheckBox = true;
        // multiSelectedIds.clear();
        // numberOfCardsSelected = 0;
        setState(() {});
      }
    }
    if (kDebugMode) {
      print(multiSelectedIds);
      print(numberOfCardsSelected);
    }
  }

  void removeIdFromSelectedIds(int currentId) {
    multiSelectedIds.remove(currentId);
    --numberOfCardsSelected;
    if (multiSelectedIds.isEmpty) {
      multiCardSelect = false;
      numberOfCardsSelected = 0;
      setState(() {});
    }
    if (kDebugMode) {
      print(multiSelectedIds);
      print(numberOfCardsSelected);
    }
  }

  void turnOffSelectAllCheckBox() {
    selectAllCheckBox = false;
    setState(() {});
  }

  void showMultiDeleteContiner() {
    toggleOpacity = true;
    toggleDeleteContainer = true;
    setState(() {});
  }

  Future<void> deleteMultipleCustomers() async {
    // print(multiSelectedIds);
    // ignore: unused_local_variable
    int totalNumberOfRowsEffected = 0;
    setState(() {
      customerDataList.clear();
      isLoading = true;
    });
    int numberOfIds = multiSelectedIds.length;
    for (int i = 0; i < numberOfIds; i++) {
      // int noOfRowsaffected;
      try {
        await DatabaseHelper.instance.delete(multiSelectedIds[i]);
      } catch (e) {
        if (kDebugMode) print(e);
      }
      ++totalNumberOfRowsEffected;
    }
    if (kDebugMode) {
      print("total rows affected: $totalNumberOfRowsEffected");
    }
    await loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar("$totalNumberOfRowsEffected Customer(s) deleted"));
    }
  }
}
