// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gym_app/style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

//make active status or expired status, text=white, active background=green, expired background=red
Slidable customerCard3({
  int? id,
  String? fullName,
  String? phoneNumber,
  String? emailId,
  int? membership,
  String? paidAmount,
  String? dueAmount,
  String? paymentDate,
  String? duedate,
  String? paymentMode,
  String? status,
  double? cardWidth,
  bool? multiCardSelect,
  required Function(int id, String fullName) onDelete,
  required Function(int id) onEdit,
  required Function(String phoneNumber, String fullName, bool activeStatus,
          String dueAmount, String duedate)
      onMessage,
  required Function() turnOnMultiCardSelectFunc,
}) {
  int dueAmountInteger = int.parse(dueAmount!);
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.parse(duedate!);
  Duration difference = endDate.difference(startDate);
  int differenceInDays = (difference.inHours / 24.0).ceil();
  bool currentCardCheckBox = false;
  return Slidable(
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      extentRatio: (status == "Expired" || dueAmountInteger > 0) ? 0.4 : (0.2),
      children: [
        if (status == "Expired" || dueAmountInteger > 0)
          SlidableAction(
            //message
            padding: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(10),
            onPressed: (context) {
              bool activeStatus = (status == "Active" ? true : false);
              onMessage(phoneNumber!, fullName!, activeStatus, dueAmount,
                  "${endDate.day}/${endDate.month}/${endDate.year}");
            },
            backgroundColor: Colors.indigo.shade400,
            foregroundColor: Colors.white,
            icon: Icons.message_outlined,
          ),
        const SizedBox(
          width: 5,
        ),
        SlidableAction(
          //delete
          // An action can be bigger than the others.
          onPressed: (context) {
            onDelete(id!, fullName!);
          },
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          icon: Icons.delete_outline_outlined,
        ),
      ],
    ),
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // onLongPress: () {
      //   onDelete(id!, fullName);
      // },
      onTap: () {
        onEdit(id!);
      },
      onLongPress: () {
        currentCardCheckBox = true;
        turnOnMultiCardSelectFunc();
      },
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            shadowColor: Colors.black,
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 60, 60, 60),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 72, //72
              width: cardWidth, //400
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //photo container
                      decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10)),
                      height: 50,
                      width: 50,
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white70,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            //why the two expanded works??
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  fullName!,
                                  style: style4(),
                                ),
                              ),
                              Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // borderRadius: BorderRadius.circular(10),
                                    color: status == "Active"
                                        ? Colors.tealAccent[700]
                                        : Colors.red.shade400),
                                // child: Padding(
                                //   padding: const EdgeInsets.all(2),
                                //   child: Center(
                                //     child: Text(
                                //       " $status ",
                                //       style: style4().copyWith(
                                //           fontWeight: FontWeight.normal,
                                //           fontSize: 16),
                                //     ),
                                //   ),
                                // ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              differenceInDays > 0
                                  ? Text(
                                      "$differenceInDays Day(s) left | Due: ₹$dueAmountInteger",
                                      style: style3()
                                          .copyWith(color: Colors.grey[400]),
                                    )
                                  : Text("Expired | Due: ₹$dueAmountInteger",
                                      style: style3()
                                          .copyWith(color: Colors.grey[400])),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (multiCardSelect!)
            Checkbox(
              value: currentCardCheckBox,
              onChanged: (value) {
                currentCardCheckBox = !currentCardCheckBox;
              },
              side: BorderSide(color: Colors.grey.shade400, width: 1),
              activeColor: Colors.blue,
              checkColor: Colors.white,
            ),
        ],
      ),
    ),
  );
}
