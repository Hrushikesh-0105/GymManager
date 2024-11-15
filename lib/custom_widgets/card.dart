import 'package:flutter/material.dart';
import 'package:gym_app/style.dart';

//make active status or expired status, text=white, active background=green, expired background=red
Visibility customerCard(
    {int? id,
    String? fullName,
    String? phoneNumber,
    String? emailId,
    int? membership,
    int? paidAmount,
    int? dueAmount,
    String? paymentDate,
    String? duedate,
    String? paymentMode,
    String? status,
    required bool visibility,
    required Function(int id, String fullName) onDelete,
    required Function(int id) onEdit}) {
  return Visibility(
    visible: visibility,
    child: Card(
      shadowColor: Colors.black,
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 180,
        width: 400,
        child: Column(
          children: [
            Expanded(
                flex: 10,
                child: Container(
                    decoration: UpperCard(),
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text(
                                  "Name: ",
                                  style: CardTextBlack(),
                                ),
                                Text("$fullName", style: CardTextBlue())
                              ]),
                              Text(
                                "$id",
                                style: CardTextBlue(),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Mobile: ",
                                style: CardTextBlack(),
                              ),
                              Text(
                                "$phoneNumber",
                                style: CardTextBlue(),
                              ),
                              Text(
                                " | ",
                                style: CardTextgrey(),
                              ),
                              Text(
                                "Plan: ",
                                style: CardTextBlack(),
                              ),
                              Text(
                                "$membership Month",
                                style: CardTextBlue(),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Amount Paid: ",
                                style: CardTextBlack(),
                              ),
                              Text(
                                "₹$paidAmount",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 2, 128, 144),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " | ",
                                style: CardTextgrey(),
                              ),
                              Text(
                                "Due: ",
                                style: CardTextBlack(),
                              ),
                              Text(
                                "₹$dueAmount",
                                style: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " | ",
                                style: CardTextgrey(),
                              ),
                              Text(
                                "Mode: ",
                                style: CardTextBlack(),
                              ),
                              Text(
                                "$paymentMode",
                                style: CardTextBlue(),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Payment Date: ",
                                style: CardTextBlack(),
                              ),
                              Text(
                                "$paymentDate",
                                style: CardTextBlue(),
                              ),
                              Text(
                                " | ",
                                style: CardTextgrey(),
                              ),
                              Text(
                                "Due Date: ",
                                style: CardTextBlack(),
                              ),
                              Text(
                                "$duedate",
                                style: CardTextBlue(),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ))),
            Expanded(
                flex: 3,
                child: Container(
                  decoration: LowerCard(status!),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            if (id != null && fullName != null) {
                              onDelete(id, fullName);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Center(
                          child: Text(
                            status,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(
                            Icons.mode_edit_outline_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            if (id != null) {
                              onEdit(id);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    ),
  );
}
