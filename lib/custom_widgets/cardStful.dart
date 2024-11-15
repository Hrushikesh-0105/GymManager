// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gym_app/style.dart';

// Convert the customerCard3 function into a StatefulWidget
class CustomerCard extends StatefulWidget {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? emailId;
  final int? membership;
  final String? paidAmount;
  final String? dueAmount;
  final String? paymentDate;
  final String? duedate;
  final String? paymentMode;
  final String? status;
  final double? cardWidth;
  final bool? multiCardSelect;
  // final bool? checkBoxValue;
  final bool? selectAll;
  final Function(int id, String fullName) onDelete;
  final Function(int id) onEdit;
  final Function(String phoneNumber, String fullName, bool activeStatus,
      String dueAmount, String duedate) onMessage;
  final Function() turnOnMultiCardSelectFunc;
  final Function(int currentId) addIdToSelectedIdList;
  final Function(int currentId) removeIdFromSelectedIdList;
  final Function() turnOffSelectAllCheckBox;
  const CustomerCard({
    super.key,
    this.id,
    this.fullName,
    this.phoneNumber,
    this.emailId,
    this.membership,
    this.paidAmount,
    this.dueAmount,
    this.paymentDate,
    this.duedate,
    this.paymentMode,
    this.status,
    this.cardWidth,
    this.multiCardSelect,
    this.selectAll,
    required this.onDelete,
    required this.onEdit,
    required this.onMessage,
    required this.turnOnMultiCardSelectFunc,
    required this.addIdToSelectedIdList,
    required this.removeIdFromSelectedIdList,
    required this.turnOffSelectAllCheckBox,
  });

  @override
  CustomerCardState createState() => CustomerCardState();
}

class CustomerCardState extends State<CustomerCard> {
  bool currentCheckBoxValue = false;
  @override
  Widget build(BuildContext context) {
    int dueAmountInteger = int.parse(widget.dueAmount!);
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.parse(widget.duedate!);
    Duration difference = endDate.difference(startDate);
    int differenceInDays = (difference.inHours / 24.0).ceil();
    if (!widget.multiCardSelect!) {
      currentCheckBoxValue = false;
    }
    if (widget.multiCardSelect! && widget.selectAll!) {
      currentCheckBoxValue = true;
      widget.addIdToSelectedIdList(widget.id!);
      // setState(() {});
    }
    return Slidable(
      enabled: !(widget.multiCardSelect!),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio:
            (widget.status == "Expired" || dueAmountInteger > 0) ? 0.4 : (0.2),
        children: [
          if (widget.status == "Expired" || dueAmountInteger > 0)
            SlidableAction(
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(10),
              onPressed: (context) {
                bool activeStatus = (widget.status == "Active");
                widget.onMessage(
                  widget.phoneNumber!,
                  widget.fullName!,
                  activeStatus,
                  widget.dueAmount!,
                  "${endDate.day}/${endDate.month}/${endDate.year}",
                );
              },
              backgroundColor: Colors.indigo.shade400,
              foregroundColor: Colors.white,
              icon: Icons.message_outlined,
            ),
          const SizedBox(width: 5),
          SlidableAction(
            onPressed: (context) {
              widget.onDelete(widget.id!, widget.fullName!);
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
        onTap: () {
          if (!widget.multiCardSelect!) {
            widget.onEdit(widget.id!);
          }
        },
        onLongPress: () {
          widget.turnOnMultiCardSelectFunc();
          widget.addIdToSelectedIdList(widget.id!);
          currentCheckBoxValue = true;
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              shadowColor: Colors.black,
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 60, 60, 60),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 72,
                width: widget.cardWidth,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.fullName!,
                                    style: style4(),
                                  ),
                                ),
                                Container(
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.status == "Active"
                                        ? Colors.tealAccent[700]
                                        : Colors.red.shade400,
                                  ),
                                ),
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
                                    : Text(
                                        "Expired | Due: ₹$dueAmountInteger",
                                        style: style3()
                                            .copyWith(color: Colors.grey[400]),
                                      ),
                                // Checkbox(value: (true), onChanged: (value) {})
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.multiCardSelect!)
              Checkbox(
                value: currentCheckBoxValue,
                onChanged: (value) {
                  setState(() {
                    currentCheckBoxValue = !currentCheckBoxValue;
                    if (currentCheckBoxValue) {
                      widget.addIdToSelectedIdList(widget.id!);
                    } else {
                      widget.removeIdFromSelectedIdList(widget.id!);
                      widget.turnOffSelectAllCheckBox();
                    }
                  });
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
}
