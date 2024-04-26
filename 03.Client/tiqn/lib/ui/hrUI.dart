import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/main.dart';
import 'package:tiqn/ui/attLogUI.dart';
import 'package:tiqn/ui/employeeUI.dart';
import 'package:tiqn/ui/otRegisterUI.dart';
import 'package:tiqn/ui/shiftRegisterUI.dart';

class HRUI extends StatefulWidget {
  const HRUI({super.key});

  @override
  State<HRUI> createState() => _HRUIState();
}

class _HRUIState extends State<HRUI>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 4, vsync: this);
    final department = jsonDecode(gValue.departmentJson);
    Future.delayed(Duration(milliseconds: 300)).then((value) => getHrData());
    super.initState();
  }

  Future<void> getHrData() async {
    gValue.shifts = await gValue.mongoDb.getShifts();
    gValue.shiftRegisters = await gValue.mongoDb.getShiftRegister();
    gValue.otRegisters = await gValue.mongoDb.getOTRegisterByRangeDate(
        DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
          hour: 0,
          minute: 0,
        )),
        DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
          hour: 23,
          minute: 59,
        )));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //calling super.build is required by the mixin.
    return DefaultTabController(
      initialIndex: 2,
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            flexibleSpace: TabBar(
                unselectedLabelColor: Colors.black,
                dividerHeight: 1,
                controller: tabController,
                indicatorColor: Colors.orange,
                indicatorWeight: 5,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.blueAccent,
                    ),
                    text: "Employees",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.fingerprint,
                      color: Colors.greenAccent,
                    ),
                    text: "Attendance Logs",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.timelapse,
                      color: Colors.tealAccent,
                    ),
                    text: "Shift Register",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.work,
                      color: Colors.orangeAccent,
                    ),
                    text: "OT Register",
                  ),
                ]),
          ),
          body: TabBarView(
            controller: tabController,
            children: const [
              EmployeeUI(),
              AttLogUI(),
              ShiftRegisterUI(), OtRegisterUI()
              // AttReportUI(),
            ],
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
