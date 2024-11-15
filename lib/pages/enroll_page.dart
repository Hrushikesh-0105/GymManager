// import 'package:flutter/cupertino.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_app/custom_widgets/snack_bar.dart';
// import 'package:flutter/widgets.dart';
// import 'package:gym_app/customer_records.dart';
import 'package:gym_app/database_helper/database_helper.dart';

import 'package:gym_app/style.dart';
import 'package:flutter/services.dart';

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
      home: const EnrollPage(editCustomer: false, editCustomerid: -1)));
}

class EnrollPage extends StatefulWidget {
  final bool editCustomer;
  final int editCustomerid;
  const EnrollPage(
      {super.key, required this.editCustomer, required this.editCustomerid});

  @override
  State<EnrollPage> createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  int? membership;
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController paidAmount = TextEditingController();
  TextEditingController dueAmount = TextEditingController();
  TextEditingController paymentDateDisplay = TextEditingController();
  DateTime? paymentDate;
  TextEditingController dueDateDisplay = TextEditingController();
  DateTime? dueDate;
  String paymentMode = "Cash";

  // textfield outline colors
  Color fullNameColor = lightGrey;
  Color phoneNumberColor = lightGrey;
  Color paidAmountColor = lightGrey;
  Color dueAmountColor = lightGrey;
  Color membershipColor = lightGrey;
  Color paymentDateColor = lightGrey;
  Color dueDateColor = lightGrey;

  String pageName = "Enroll";

  @override
  void initState() {
    if (widget.editCustomer) {
      getCustomerInfo();
    }
    super.initState();
  }

  @override
  void dispose() {
    fullName.dispose();
    phoneNumber.dispose();
    emailId.dispose();
    paidAmount.dispose();
    dueAmount.dispose();
    paymentDateDisplay.dispose();
    dueDateDisplay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
          title: Container(
            // color: Colors.black,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              "POWER FITNESS",
              style: headlineLarge(),
            ),
          ),
        ),
        body: Container(
            // color: Colors.purple[100],
            margin: const EdgeInsets.fromLTRB(28, 20, 28, 0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  pageName,
                  style: style1()
                      .copyWith(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible: !widget.editCustomer,
                  child: Text(
                    "Please Enter the Following Details",
                    style: style1().copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        controller: fullName,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        decoration: textfieldstyle1(
                            Icons.person_outlined, "Full Name", fullNameColor),
                        style: style3(),
                        cursorColor: const Color.fromARGB(255, 15, 154, 173),
                        onChanged: (value) {
                          fullNameColor =
                              (value.isEmpty) ? Colors.red : lightGrey;
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      TextField(
                        controller: phoneNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ], // this restricts keypad to enter only digits

                        decoration: textfieldstyle1(Icons.call_outlined,
                            "Mobile Number", phoneNumberColor),
                        style: style3(),
                        cursorColor: const Color.fromARGB(255, 15, 154, 173),
                        onChanged: (value) {
                          phoneNumberColor = (checkPhoneNumberLength())
                              ? lightGrey
                              : Colors.red;
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextField(
                        controller: emailId,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textfieldstyle1(
                            Icons.email_outlined, "Email Id", lightGrey),
                        style: style3(),
                        cursorColor: const Color.fromARGB(255, 15, 154, 173),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      DropdownButtonFormField(
                        value: membership,
                        items: [1, 3, 6, 12].map((int month) {
                          return DropdownMenuItem<int>(
                              value: month,
                              child: Row(
                                children: [
                                  Text(
                                    "$month Month",
                                    style: style3(),
                                  ),
                                  Text(
                                    " | ${month * 30} Days",
                                    style:
                                        style3().copyWith(color: Colors.grey),
                                  )
                                ],
                              ));
                        }).toList(),
                        //map() function passes each element of the list to another function which returns a widget, each widget makes up a new list
                        onChanged: (months) {
                          membership = months!;
                          membershipColor =
                              (membership == null) ? Colors.red : lightGrey;
                          setState(() {});
                        },
                        decoration:
                            textfieldstyle1(Icons.dehaze, "", membershipColor),
                        dropdownColor: Colors.grey[800],
                        hint: Text("Membership", style: style2()),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: paidAmount,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: textfieldstyle1(
                                  Icons.currency_rupee_outlined,
                                  "Paid Amount",
                                  paidAmountColor),
                              style: style3(),
                              cursorColor:
                                  const Color.fromARGB(255, 15, 154, 173),
                              onChanged: (value) {
                                paidAmountColor =
                                    (value.isEmpty) ? Colors.red : lightGrey;
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: dueAmount,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: textfieldstyle1(
                                  Icons.currency_rupee_outlined,
                                  "Due Amount",
                                  dueAmountColor),
                              style: style3(),
                              cursorColor:
                                  const Color.fromARGB(255, 15, 154, 173),
                              onChanged: (value) {
                                dueAmountColor =
                                    (value.isEmpty) ? Colors.red : lightGrey;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      // do date setting and other things from here
                      TextField(
                        controller: paymentDateDisplay,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2030));
                          if (pickedDate != null) {
                            paymentDateDisplay.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            paymentDate = pickedDate;
                            if (membership != null) {
                              setDueDate(pickedDate, membership!);
                            }
                          }
                          paymentDateColor =
                              (paymentDate == null) ? Colors.red : lightGrey;
                          setState(() {});
                        },
                        decoration: textfieldstyle1(Icons.edit_calendar_rounded,
                            "Payment Date", paymentDateColor),
                        style: style3(),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      TextField(
                        controller: dueDateDisplay,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2030));
                          if (pickedDate != null) {
                            dueDateDisplay.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            dueDate = pickedDate;
                          }
                          dueDateColor =
                              (dueDate == null) ? Colors.red : lightGrey;
                          setState(() {});
                        },
                        decoration: textfieldstyle1(
                            Icons.free_cancellation_outlined,
                            "Due Date",
                            dueDateColor),
                        style: style3(),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                  value: "Cash",
                                  groupValue: paymentMode,
                                  activeColor:
                                      const Color.fromARGB(255, 15, 154, 173),
                                  onChanged: (value) {
                                    paymentMode = value!;
                                    setState(() {});
                                  }),
                              InkWell(
                                onTap: () {
                                  paymentMode = "Cash";
                                  setState(() {});
                                },
                                child: Text(
                                  "Cash",
                                  style: radioButtonStyle(),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: "UPI",
                                  groupValue: paymentMode,
                                  activeColor:
                                      const Color.fromARGB(255, 15, 154, 173),
                                  onChanged: (value) {
                                    paymentMode = value!;
                                    setState(() {});
                                  }),
                              InkWell(
                                onTap: () {
                                  paymentMode = "UPI";
                                  setState(() {});
                                },
                                child: Text(
                                  "UPI",
                                  style: radioButtonStyle(),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: "Card",
                                  groupValue: paymentMode,
                                  activeColor:
                                      const Color.fromARGB(255, 15, 154, 173),
                                  onChanged: (value) {
                                    paymentMode = value!;
                                    setState(() {});
                                  }),
                              InkWell(
                                onTap: () {
                                  paymentMode = "Card";
                                  setState(() {});
                                },
                                child: Text(
                                  "Card",
                                  style: radioButtonStyle(),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          clearEntry();
                          setState(() {});
                        },
                        child: Container(
                          height: 44,
                          // width: 80,
                          decoration: BoxDecoration(
                              //color: Colors.red[600],
                              color: const Color.fromARGB(255, 60, 60, 60),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              "Clear",
                              style: style4().copyWith(fontSize: 24),
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
                          if (checkAllTextFields()) {
                            if (widget.editCustomer) {
                              await update();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  customSnackBar("Customer details updated"));
                            } else {
                              await save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  customSnackBar("Customer details saved"));
                            }

                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar("Fill the required fields"));
                          }
                        },
                        child: Container(
                          height: 44,
                          // width: 80,
                          decoration: saveButtonStyle(),
                          child: Center(
                            child: Text(
                              "Save",
                              style: style4().copyWith(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            )));
  }

  bool checkAllTextFields() {
    fullNameColor = (fullName.text.isEmpty) ? Colors.red : lightGrey;
    phoneNumberColor = (phoneNumber.text.length != 10) ? Colors.red : lightGrey;
    membershipColor = (membership == null) ? Colors.red : lightGrey;
    paidAmountColor = (paidAmount.text.isEmpty) ? Colors.red : lightGrey;
    // dueAmountColor = (dueAmount.text.isEmpty) ? Colors.red : lightGrey;
    paymentDateColor = (paymentDate == null) ? Colors.red : lightGrey;
    dueDateColor = (dueDate == null) ? Colors.red : lightGrey;
    if (dueAmount.text.isEmpty) {
      dueAmount.text = "0";
    }

    setState(() {});
    if (fullName.text.isEmpty ||
        phoneNumber.text.length != 10 ||
        membership == null ||
        paidAmount.text.isEmpty ||
        dueAmount.text.isEmpty ||
        paymentDate == null ||
        dueDate == null) {
      return false;
    }
    return true;
  }

  void clearEntry() {
    fullName.clear();
    phoneNumber.clear();
    emailId.clear();
    membership = null;
    paidAmount.clear();
    dueAmount.clear();
    paymentDateDisplay.clear();
    dueDateDisplay.clear();
    paymentDate = null;
    dueDate = null;
    paymentMode = "Cash";
  }

  Future<void> save() async {
    String currentStatus = setStatus();
    // ignore: unused_local_variable
    int id = await DatabaseHelper.instance.insert({
      DatabaseHelper.columnFullName: fullName.text,
      DatabaseHelper.columnPhoneNumber: phoneNumber.text,
      DatabaseHelper.columnEmailId: emailId.text,
      DatabaseHelper.columnMembership: membership,
      DatabaseHelper.columnPaidAmount: paidAmount.text,
      DatabaseHelper.columnDueAmount: dueAmount.text,
      DatabaseHelper.columnPaymentDate: paymentDate.toString(),
      DatabaseHelper.columnDueDate: dueDate.toString(),
      DatabaseHelper.columnPaymentMode: paymentMode,
      DatabaseHelper.columnStatus: currentStatus,
    });
  }

  Future<void> getCustomerInfo() async {
    Map<String, dynamic> result =
        await DatabaseHelper.instance.getCustomerById(widget.editCustomerid);
    if (result.isNotEmpty) {
      fullName.text = result["fullName"];
      phoneNumber.text = result["phoneNumber"];
      emailId.text = result["emailId"];
      membership = result["membership"];
      paidAmount.text = "${result["paidAmount"]}";
      dueAmount.text = "${result["dueAmount"]}";
      paymentDate = DateTime.parse(result["paymentDate"]);
      if (paymentDate != null) {
        paymentDateDisplay.text =
            "${paymentDate!.day}/${paymentDate!.month}/${paymentDate!.year}";
        // print(paymentDate!.year - 2000);
      }
      dueDate = DateTime.parse(result["dueDate"]);
      if (dueDate != null) {
        dueDateDisplay.text =
            "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}";
      }
      paymentMode = result["paymentMode"];
      pageName = "Edit Customer";
      // print(result);
      setState(() {});
    }
  }

  Future<void> update() async {
    String currentStatus = setStatus();

    // ignore: unused_local_variable
    int noOfRowsEffected = await DatabaseHelper.instance.update({
      DatabaseHelper.columnId: widget.editCustomerid,
      DatabaseHelper.columnFullName: fullName.text.trim(),
      DatabaseHelper.columnPhoneNumber: phoneNumber.text.trim(),
      DatabaseHelper.columnEmailId: emailId.text.trim(),
      DatabaseHelper.columnMembership: membership,
      DatabaseHelper.columnPaidAmount: paidAmount.text,
      DatabaseHelper.columnDueAmount: dueAmount.text,
      DatabaseHelper.columnPaymentDate: paymentDate.toString(),
      DatabaseHelper.columnDueDate: dueDate.toString(),
      DatabaseHelper.columnPaymentMode: paymentMode,
      DatabaseHelper.columnStatus: currentStatus,
    });
    // print(noOfRowsEffected);
  }

  void setDueDate(DateTime pickedDate, int membership) {
    Map<int, int> daysCalander = {
      1: 31,
      2: 28,
      3: 31,
      4: 30,
      5: 31,
      6: 30,
      7: 31,
      8: 31,
      9: 30,
      10: 31,
      11: 30,
      12: 31
    };
    int noOfDaysLeft = membership * 30;

    int dueDay = pickedDate.day;
    int dueMonth = pickedDate.month;
    int dueYear = pickedDate.year;

    while (noOfDaysLeft != 0) {
      if ((dueYear % 4 == 0 && dueYear % 100 != 0) || dueYear % 400 == 0) {
        daysCalander[2] = 29;
      } else {
        daysCalander[2] = 28;
      }
      dueDay = dueDay + noOfDaysLeft;
      if (dueDay > daysCalander[dueMonth]!) {
        noOfDaysLeft = dueDay - daysCalander[dueMonth]!;
        dueDay = 0;
        ++dueMonth;
        if (dueMonth > 12) {
          dueMonth = 1;
          ++dueYear;
        }
      } else {
        noOfDaysLeft = 0;
      }
    }
    // print("$dueDay/$dueMonth/$dueYear");
    dueDate = DateTime(dueYear, dueMonth, dueDay);
    dueDateDisplay.text = "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}";
    // print(dueDate);
  }

  String setStatus() {
    DateTime currentDate = DateTime.now();
    if (dueDate!.isBefore(currentDate)) {
      return "Expired";
    }
    return "Active";
  }

  bool checkPhoneNumberLength() {
    if (phoneNumber.text.length == 10) {
      return true;
    } else {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(customSnackBar("Enter 10 digit phone number"));
      return false;
    }
  }
}
