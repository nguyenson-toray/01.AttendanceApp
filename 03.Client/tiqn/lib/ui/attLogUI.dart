import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/gValue.dart';
import 'package:intl/intl.dart';
import 'package:tiqn/main.dart';
import 'package:tiqn/tools/myFunction.dart';
import 'package:tiqn/tools/myfile.dart';
import 'package:toastification/toastification.dart';

class AttLogUI extends StatefulWidget {
  const AttLogUI({super.key});

  @override
  State<AttLogUI> createState() => _AttLogUIState();
}

class _AttLogUIState extends State<AttLogUI>
    with AutomaticKeepAliveClientMixin {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  late DateTime timeBegin;
  late DateTime timeEnd;
  late DateTime dateAddRecord;
  var listOfEmpIdPresent = [];
  late final PlutoGridStateManager stateManager;
  bool firstBuild = true, isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    timeBegin = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
      hour: 0,
      minute: 0,
    ));
    timeEnd = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
      hour: 23,
      minute: 59,
    ));
    dateAddRecord = timeBegin;
    Timer.periodic(
        const Duration(seconds: 1), (_) => refreshData(timeBegin, timeEnd));
    columns = getColumns();
    super.initState();
  }

  Future<void> refreshData(DateTime timeBegin, DateTime timeEnd) async {
    List<AttLog> newList = await gValue.mongoDb.getAttLogs(timeBegin, timeEnd);
    if (newList.isEmpty) {
      return;
    } else if (gValue.attLogs.length != newList.length) {
      print('refreshData AttLog => changed => ${newList.length}');

      if (!firstBuild) {
        setState(() {
          gValue.attLogs = newList;
          rows = getRows(gValue.attLogs);
          stateManager.removeRows(stateManager.rows);
          stateManager.appendRows(rows);
          MyFuntion.calculateAttendanceStatus();
        });
        isLoading = false;
      }
    }
  }

  // Stream<List<AttLog>> getAttLogs(DateTime timeBegin, DateTime timeEnd) async* {
  //   final url = Uri.parse(
  //       '${gValue.flaskServer}/attLogs/${DateFormat('yyyyMMdd').format(timeBegin)}/${DateFormat('yyyyMMdd').format(timeEnd)}');
  //   while (true) {
  //     await Future.delayed(Duration(seconds: 1));
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body) as List<dynamic>;
  //       yield data.map((post) => AttLog.fromMap(post)).toList();
  //     } else {
  //       // Handle error
  //       throw Exception('Failed to load AttLog');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 230,
              width: 500,
              child: SfDateRangePicker(
                enableMultiView: true,
                // monthViewSettings: DateRangePickerMonthViewSettings(
                //     showWeekNumber: false, firstDayOfWeek: 1, weekendDays: [7]),
                view: DateRangePickerView.month,
                showTodayButton: true,
                // minDate: DateTime.now().subtract(Duration(days: 31)),
                maxDate: DateTime.now(),
                backgroundColor: Colors.blue[100],
                todayHighlightColor: Colors.green,
                selectionColor: Colors.orangeAccent,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: Colors.blue[200],
                ),
                onSelectionChanged: onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange:
                    PickerDateRange(DateTime.now(), DateTime.now()),
              ),
            ),

            // const Divider(
            //   indent: 8.0,
            //   endIndent: 8.0,
            //   color: Colors.black12,
            // ),
            Row(children: [
              TextButton.icon(
                onPressed: () {
                  if (isLoading) {
                    toastification.show(
                      backgroundColor: Colors.orange,
                      alignment: Alignment.center,
                      context: context,
                      title: const Text('Data not yet loaded, try again!'),
                      autoCloseDuration: const Duration(seconds: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x07000000),
                          blurRadius: 16,
                          offset: Offset(0, 16),
                          spreadRadius: 0,
                        )
                      ],
                    );
                  } else {
                    List<Employee> absents = [];
                    for (var empId in gValue.employeeIdAbsents) {
                      absents.add(gValue.employees
                          .firstWhere((element) => element.empId == empId));
                    }
                    MyFile.createExcelEmployee(absents, true, "Absents");
                  }
                },
                icon: const Icon(
                  Icons.supervised_user_circle,
                  color: Colors.orangeAccent,
                ),
                label: const Text('Export absent list'),
              ),
              TextButton.icon(
                onPressed: () async {
                  List<OtRegister> otRegisterAll =
                      await gValue.mongoDb.getOTRegisterAll();
                  if (isLoading) {
                    toastification.show(
                      backgroundColor: Colors.orange,
                      alignment: Alignment.center,
                      context: context,
                      title: const Text('Data not yet loaded, try again!'),
                      autoCloseDuration: const Duration(seconds: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x07000000),
                          blurRadius: 16,
                          offset: Offset(0, 16),
                          spreadRadius: 0,
                        )
                      ],
                    );
                  } else {
                    MyFile.createExcelTimeSheet(
                        MyFuntion.createTimeSheets(
                            gValue.employees,
                            gValue.shifts,
                            gValue.shiftRegisters,
                            otRegisterAll,
                            gValue.attLogs,
                            timeBegin,
                            timeEnd),
                        'Timesheets from ${DateFormat('dd-MMM-yyyy').format(timeBegin)} to ${DateFormat('dd-MMM-yyyy').format(timeEnd)} ${DateFormat('hhmmss').format(DateTime.now())}');
                  }
                },
                icon: const Icon(
                  Icons.timelapse,
                  color: Colors.blueAccent,
                ),
                label: const Text('Export timesheets'),
              ),
            ]),

            const Divider(
              indent: 8.0,
              endIndent: 8.0,
              color: Colors.black12,
            ),
            Row(children: [
              TextButton.icon(
                onPressed: () {
                  late SingleValueDropDownController dropDownController =
                      SingleValueDropDownController();
                  List<String> empIds = [];
                  for (var emp in gValue.employees) {
                    if (emp.workStatus == 'Working') {
                      empIds.add(emp.empId ?? "TIQN-9999");
                    }
                  }
                  empIds.toSet().toList();
                  List<DropDownValueModel> dropDownValueModels = [];
                  List<DropDownValueModel> dropDownValueModelsHour = [];
                  List<DropDownValueModel> dropDownValueModelsMinute = [];
                  for (var element in gValue.employees) {
                    dropDownValueModels.add(DropDownValueModel(
                        value: '${element.empId}',
                        name: '${element.empId} ${element.name}'));
                  }
                  List<int> hours = [for (var i = 0; i <= 23; i++) i];
                  var minutes = [0, 10, 20, 30, 40, 50];
                  String empId = '', empName = '';
                  for (var element in hours) {
                    dropDownValueModelsHour.add(DropDownValueModel(
                        name: element < 10
                            ? '0$element'
                            : element < 10
                                ? '0$element'
                                : '$element',
                        value: element));
                  }
                  for (var element in minutes) {
                    dropDownValueModelsMinute.add(DropDownValueModel(
                        name: element < 10
                            ? '0$element'
                            : element < 10
                                ? '0$element'
                                : '$element',
                        value: element));
                  }
                  int hour = 8, minute = 0;
                  AwesomeDialog(
                          padding: const EdgeInsets.all(10),
                          context: context,
                          body: SizedBox(
                            width: 500,
                            height: 450,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Employee : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: DropDownTextField(
                                        dropdownColor: Colors.white,
                                        listTextStyle: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        readOnly: false,
                                        controller: dropDownController,
                                        clearOption: true,
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        clearIconProperty: IconProperty(
                                            color: Colors.redAccent),
                                        searchDecoration: const InputDecoration(
                                            hintText:
                                                "Enter employee ID or name"),
                                        dropDownList: dropDownValueModels,
                                        onChanged: (val) {
                                          empId = val.value;
                                          empName = val.name
                                              .toString()
                                              .replaceAll('$empId ', '');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SfDateRangePicker(
                                  showTodayButton: true,
                                  minDate: DateTime.now()
                                      .subtract(const Duration(days: 31)),
                                  maxDate: DateTime.now(),
                                  backgroundColor: Colors.blue[100],
                                  todayHighlightColor: Colors.green,
                                  selectionColor: Colors.orangeAccent,
                                  headerStyle: DateRangePickerHeaderStyle(
                                    backgroundColor: Colors.blue[200],
                                  ),
                                  onSelectionChanged:
                                      onSelectionChangedAddRecord,
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                  initialSelectedDate: DateTime.now(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Time",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text('Hour : '),
                                    SizedBox(
                                      width: 100,
                                      child: DropDownTextField(
                                        initialValue: '08',
                                        dropdownColor: Colors.white,
                                        listTextStyle: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        readOnly: false,
                                        clearOption: true,
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        clearIconProperty: IconProperty(
                                            color: Colors.redAccent),
                                        searchDecoration: const InputDecoration(
                                            hintText: "Hour"),
                                        dropDownList: dropDownValueModelsHour,
                                        onChanged: (val) {
                                          hour = val.value;
                                        },
                                      ),
                                    ),
                                    const Text("Minute :"),
                                    SizedBox(
                                      width: 130,
                                      child: DropDownTextField(
                                        initialValue: '00',
                                        dropdownColor: Colors.white,
                                        listTextStyle: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        readOnly: false,
                                        clearOption: true,
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        clearIconProperty: IconProperty(
                                            color: Colors.redAccent),
                                        searchDecoration: const InputDecoration(
                                            hintText: "Minute"),
                                        dropDownList: dropDownValueModelsMinute,
                                        onChanged: (val) {
                                          minute = val.value;
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          width: 500,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Add attendance record ?',
                          enableEnterKey: true,
                          showCloseIcon: true,
                          btnOkOnPress: () {
                            if (empName.isNotEmpty) {
                              var time = dateAddRecord.appliedFromTimeOfDay(
                                  TimeOfDay(hour: hour, minute: minute));
                              int finger = gValue.employees
                                  .where((element) =>
                                      element.empId == empId.trim())
                                  .first
                                  .attFingerId!;
                              AttLog attLog = AttLog(
                                  objectId: '',
                                  attFingerId: finger,
                                  empId: empId,
                                  name: empName,
                                  machineNo: 1,
                                  timestamp: time);
                              gValue.mongoDb.insertAttLogs([attLog]);
                            }
                          },
                          closeIcon: const Icon(Icons.close))
                      .show();
                },
                icon: const Icon(
                  Icons.add_box,
                  color: Colors.greenAccent,
                ),
                label: const Text('Add record'),
              ),
              TextButton.icon(
                onPressed: () {
                  print('(gValue.attLogs : ${gValue.attLogs.length}');
                  MyFile.createExcelAttLog(gValue.attLogs,
                      'Attendance logs from ${DateFormat('dd-MMM-yyyy').format(timeBegin)} to ${DateFormat('dd-MMM-yyyy').format(timeEnd)}');
                },
                icon: const Icon(
                  Icons.download,
                  color: Colors.blueAccent,
                ),
                label: const Text('Export records'),
              ),
              TextButton.icon(
                onPressed: () async {
                  List<Text> logs = [];
                  gValue.mongoDb.insertAttLogs(await MyFile.readExcelAttLog());
                  for (var log in gValue.logs) {
                    logs.add(Text(
                      log,
                      style: TextStyle(
                          color: log.contains("ERROR")
                              ? Colors.red
                              : Colors.black),
                    ));
                  }
                  if (gValue.logs.isNotEmpty) {
                    AwesomeDialog(
                            context: context,
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: logs,
                            ),
                            width: 800,
                            dialogType: gValue.logs.toString().contains("ERROR")
                                ? DialogType.warning
                                : DialogType.info,
                            animType: AnimType.rightSlide,
                            title: 'Import attendance record result',
                            desc: gValue.logs.toString(),
                            enableEnterKey: true,
                            showCloseIcon: true,
                            closeIcon: const Icon(Icons.close))
                        .show();
                  }
                },
                icon: const Icon(
                  Icons.upload,
                  color: Colors.orangeAccent,
                ),
                label: const Text('Import records'),
              ),
            ]),

            // Text(
            //     'Total Enrolled : ${gValue.enrolled}  -  Total Working Normal : ${gValue.workingNormal}\nMaternity leave : ${gValue.maternityLeave}\nPresent : ${gValue.present}\nAbsent : ${gValue.absent}'),

            timeBegin.day == timeEnd.day
                ? chartPresent(
                    gValue.employeeIdPresents.length,
                    gValue.employeeIdMaternityLeaves.length,
                    gValue.employeeIdPresents.length,
                    gValue.employeeIdAbsents.length)
                : Container(),
          ],
        ),
        Expanded(
            child: PlutoGrid(
          mode: PlutoGridMode.normal,
          configuration: const PlutoGridConfiguration(
            enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
            scrollbar: PlutoGridScrollbarConfig(
              scrollbarThickness: 8,
              scrollbarThicknessWhileDragging: 20,
              isAlwaysShown: true,
            ),
            style: PlutoGridStyleConfig(
              rowColor: Colors.white,
              enableGridBorderShadow: true,
            ),
            columnFilter: PlutoGridColumnFilterConfig(),
          ),
          columns: columns,
          rows: rows,
          onChanged: (PlutoGridOnChangedEvent event) {
            print('onChanged  :$event');
          },
          onRowDoubleTap: (event) {
            print('onRowDoubleTap');
          },
          onLoaded: (PlutoGridOnLoadedEvent event) {
            print('onLoaded');
            firstBuild = false;
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
            // context.read<AttLog>().summaryAll(results);
            print('rows lenght : ${rows.length}');
          },
          onSelected: (event) {
            print('onSelected  :$event');
          },
          onSorted: (event) {
            print('onSorted  :$event');
          },
        ))
      ],
    )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  List<PlutoColumn> getColumns() {
    List<PlutoColumn> columns;
    columns = [
      // PlutoColumn(
      //     width: 250,
      //     title: 'ObjectId',
      //     field: 'objectId',
      //     type: PlutoColumnType.text(),
      //     renderer: (rendererContext) {
      //       return Row(
      //         children: [
      //           Expanded(
      //             child: Text(
      //               rendererContext
      //                   .row.cells[rendererContext.column.field]!.value
      //                   .toString(),
      //               maxLines: 1,
      //               overflow: TextOverflow.ellipsis,
      //               textAlign: TextAlign.left,
      //             ),
      //           ),
      //           IconButton(
      //             icon: const Icon(
      //               Icons.remove_circle_outlined,
      //             ),
      //             onPressed: () {
      //               String objectId = '';
      //               String deletedEmpId = '';
      //               String deletedEmpName = '';
      //               DateTime timeStamp = DateTime.now();

      //               var row = rendererContext.row.toJson();
      //               row.forEach((key, value) {
      //                 if (key == 'employeeId') {
      //                   objectId = row['objectId'].toString();
      //                   deletedEmpId = value;
      //                   deletedEmpName = row['name'];
      //                   timeStamp = DateTime.parse(row['timeStamp'].toString());
      //                 }
      //               });

      //               AwesomeDialog(
      //                       context: context,
      //                       body: Text(
      //                           'Delete record: $objectId \n$deletedEmpId\n$deletedEmpName\nTime: $timeStamp',
      //                           style: const TextStyle(
      //                               color: Colors.redAccent,
      //                               fontSize: 18,
      //                               fontWeight: FontWeight.bold)),
      //                       width: 800,
      //                       dialogType: DialogType.question,
      //                       animType: AnimType.rightSlide,
      //                       // title: 'Import Employee Result',
      //                       enableEnterKey: true,
      //                       showCloseIcon: true,
      //                       btnOkOnPress: () {
      //                         gValue.realmService.deleteAttLog(objectId);
      //                         rendererContext.stateManager
      //                             .removeRows([rendererContext.row]);
      //                       },
      //                       closeIcon: const Icon(Icons.close))
      //                   .show();
      //             },
      //             iconSize: 18,
      //             color: Colors.red,
      //             padding: const EdgeInsets.all(0),
      //           ),
      //         ],
      //       );
      //     }),
      PlutoColumn(
          title: 'Finger ID',
          field: 'attFingerId',
          type: PlutoColumnType.number(),
          width: 120,
          renderer: (rendererContext) {
            return Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outlined,
                  ),
                  onPressed: () {
                    var row = rendererContext.row.toJson();
                    print(row);
                    var style = const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold);

                    String objectId = '';
                    String deletedEmpId = '';
                    String deletedEmpName = '';
                    DateTime timeStamp = DateTime.now();
                    row.forEach((key, value) {
                      if (key == 'employeeId') {
                        objectId = row['objectId'].toString();
                        deletedEmpId = value;
                        deletedEmpName = row['name'];
                        timeStamp = DateTime.parse(row['timeStamp'].toString());
                      }
                    });

                    AwesomeDialog(
                            context: context,
                            body: Text(
                              'Delete ?\n${row['empId']}  ${row['name']}\nTime: ${row['timeStamp']}',
                              style: style,
                            ),
                            width: 800,
                            dialogType: DialogType.question,
                            animType: AnimType.rightSlide,
                            // title: 'Import Employee Result',
                            enableEnterKey: true,
                            showCloseIcon: true,
                            btnOkOnPress: () {
                              gValue.mongoDb.deleteOneAttLog(
                                  row['objectId'].toString().substring(10, 34));
                              rendererContext.stateManager
                                  .removeRows([rendererContext.row]);
                            },
                            closeIcon: const Icon(Icons.close))
                        .show();
                  },
                  iconSize: 18,
                  color: Colors.red,
                  padding: const EdgeInsets.all(0),
                ),
                Expanded(
                  child: Text(
                    rendererContext
                        .row.cells[rendererContext.column.field]!.value
                        .toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            );
          }),
      PlutoColumn(
          title: 'Employee ID',
          field: 'empId',
          type: PlutoColumnType.text(),
          width: 150),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Time',
        field: 'timeStamp',
        type: PlutoColumnType.text(),
        // type: PlutoColumnType.time(
        //     defaultValue:
        //         timeEnd.appliedFromTimeOfDay(TimeOfDay(hour: 8, minute: 0))),
      ),
      PlutoColumn(
        title: 'Machine',
        field: 'machineNo',
        width: 100,
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        width: 350,
        title: 'objectId',
        field: 'objectId',
        type: PlutoColumnType.text(),
        hide: !gValue.showObjectId,
      )
    ];
    return columns;
  }

  List<PlutoRow> getRows(List<AttLog> data) {
    List<PlutoRow> rows = [];
    for (var log in data.reversed) {
      rows.add(
        PlutoRow(
          cells: {
            'attFingerId': PlutoCell(value: log.attFingerId),
            'empId': PlutoCell(value: log.empId),
            'name': PlutoCell(value: log.name),
            'timeStamp': PlutoCell(
                value:
                    DateFormat("dd-MMM-yyyy HH:mm:ss").format(log.timestamp)),
            'machineNo': PlutoCell(value: log.machineNo),
            'objectId': PlutoCell(value: log.objectId),
          },
        ),
      );
    }
    print(' ******** getRows(List<AttLog> data) ==>>>>> ${rows.length}');
    return rows;
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    isLoading = true;
    setState(() {
      if (args.value is PickerDateRange) {
        timeBegin = args.value.startDate;
        timeEnd = args.value.endDate ?? args.value.startDate;
      } else if (args.value is DateTime) {
        timeBegin = args.value;
        timeEnd = args.value;
      }
      timeBegin = timeBegin.appliedFromTimeOfDay(const TimeOfDay(
        hour: 0,
        minute: 1,
      ));
      timeEnd = timeEnd.appliedFromTimeOfDay(const TimeOfDay(
        hour: 23,
        minute: 59,
      ));
    });
    // print(
    //     'onSelectionChanged : timeBegin: $timeBegin       timeEnd: $timeEnd ');
  }

  void onSelectionChangedAddRecord(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        dateAddRecord = args.value.startDate;
        dateAddRecord = args.value.endDate ?? args.value.startDate;
      } else if (args.value is DateTime) {
        dateAddRecord = args.value;
        dateAddRecord = args.value;
      }
      dateAddRecord = dateAddRecord.appliedFromTimeOfDay(const TimeOfDay(
        hour: 23,
        minute: 59,
      ));
    });
    print('onSelectionChangedAddRecord : dateAddRecord: $dateAddRecord  ');
  }

  chartPresent(int workingNormal, int maternityLeave, int present, int absent) {
    final List<ChartPresent> chartData = [
      // ChartPresent('Total enrolled', gValue.enrolled.toDouble(), Colors.blue),
      // ChartPresent('Total working normal', gValue.workingNormal.toDouble(),
      //     Colors.purple),
      ChartPresent(
          'Maternity leave', maternityLeave.toDouble(), Colors.purpleAccent),
      ChartPresent('Present', present.toDouble(), Colors.green[400]),
      ChartPresent('Absent', absent.toDouble(), Colors.orange),
    ];
    return SizedBox(
      width: 500,
      height: 250,
      child: SfCircularChart(
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
                widget: Container(
                    child: Text('Enrolled\n    ${gValue.enrolled}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))))
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: const Legend(
              position: LegendPosition.bottom,
              // height: '50%',
              overflowMode: LegendItemOverflowMode.wrap,
              isVisible: true,
              textStyle: TextStyle(fontSize: 15)),
          series: <CircularSeries<ChartPresent, String>>[
            DoughnutSeries<ChartPresent, String>(
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: chartData,
              xValueMapper: (ChartPresent data, _) => data.x,
              yValueMapper: (ChartPresent data, _) => data.y,
              pointColorMapper: (ChartPresent data, _) => data.color,
            )
          ]),
    );
  }
}

class ChartPresent {
  ChartPresent(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
