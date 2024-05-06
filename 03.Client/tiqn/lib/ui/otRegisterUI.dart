import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/gValue.dart';
import 'package:tiqn/main.dart';
import 'package:tiqn/tools/myfile.dart';

class OtRegisterUI extends StatefulWidget {
  const OtRegisterUI({super.key});

  @override
  State<OtRegisterUI> createState() => _OtRegisterUIState();
}

class _OtRegisterUIState extends State<OtRegisterUI>
    with AutomaticKeepAliveClientMixin {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridMode plutoGridMode = PlutoGridMode.normal;
  late PlutoGridStateManager stateManager;
  bool firstBuild = true;
  String newOrEdit = '';
  int rowIdChanged = 0, colIdChange = 0, countOt = 0;
  Map<String, dynamic> rowChangedJson = {};
  late DateTime timeBegin;
  late DateTime timeEnd;
  @override
  void initState() {
    // TODO: implement initState
    columns = getColumns();
    rows = getRows(gValue.otRegisters);
    Timer.periodic(const Duration(seconds: 2), (_) => refreshData());
    timeBegin = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
      hour: 0,
      minute: 1,
    ));
    timeEnd = DateTime.now().appliedFromTimeOfDay(const TimeOfDay(
      hour: 23,
      minute: 59,
    ));
    super.initState();
  }

  bool checkDiff(List<OtRegister> oldList, List<OtRegister> newList) {
    bool diff = false;
    if (newList.isEmpty) {
      return false;
    } else if (oldList.length != newList.length) {
      print('checkDiff OtRegister : TRUE : Diff length');
      diff = true;
    } else {
      for (int i = 0; i < oldList.length; i++) {
        if (oldList[i] != newList[i]) {
          diff = true;
          print('checkDiff OtRegister: TRUE : Diff element');
          break;
        }
      }
    }
    return diff;
  }

  Future<void> refreshData() async {
    List<OtRegister> newList =
        await gValue.mongoDb.getOTRegisterByRangeDate(timeBegin, timeEnd);
    if (checkDiff(gValue.otRegisters, newList)) {
      print(
          'OtRegisterUI Data changed : ${gValue.otRegisters.length} => ${newList.length} records');
      gValue.otRegisters = newList;
      setState(() {
        if ((!firstBuild)) {
          var rows = getRows(gValue.otRegisters);
          stateManager.removeRows(stateManager.rows);
          stateManager.appendRows(rows);
          countOt = gValue.otRegisters
              .map((e) => e.empId)
              .toList()
              .toSet()
              .toList()
              .length;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 200,
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  height: 250,
                  child: SfDateRangePicker(
                    showTodayButton: true,
                    minDate: DateTime.now().subtract(const Duration(days: 31)),
                    maxDate: DateTime.now(),
                    backgroundColor: Colors.blue[100],
                    todayHighlightColor: Colors.green,
                    selectionColor: Colors.orangeAccent,
                    headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: Colors.blue[200],
                    ),
                    onSelectionChanged: onSelectionChangedDate,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedDate: DateTime.now(),
                  ),
                ),
                const Divider(),
                Text('OT employees: $countOt'),
                const Divider(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      newOrEdit = 'new';
                      rowIdChanged = 0;
                      stateManager.scroll.vertical?.resetScroll();
                      stateManager.prependNewRows();
                    });
                  },
                  icon: const Icon(
                    Icons.add_box,
                    color: Colors.greenAccent,
                  ),
                  label: const Text('Add one record'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    gValue.mongoDb
                        .insertOtRegisters(await MyFile.readExcelOtRegister());
                    List<Text> logs = [];
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
                              dialogType:
                                  gValue.logs.toString().contains("ERROR")
                                      ? DialogType.warning
                                      : DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Import OT Result',
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
                  label: const Text('Import from excel'),
                ),
                TextButton.icon(
                  onPressed: () {
                    MyFile.createExcelOtRegisters(gValue.otRegisters,
                        'OT Registers ${DateFormat('dd-MMM-yyyy hhmmss').format(DateTime.now())}');
                  },
                  icon: const Icon(
                    Icons.download,
                    color: Colors.blueAccent,
                  ),
                  label: const Text('Export all to excel'),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
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
              onChanged: (event) {
                print('onChanged : $event');

                setState(() {
                  if (newOrEdit == '') newOrEdit = 'edit';
                  rowIdChanged = event.rowIdx;
                  colIdChange = event.columnIdx;
                  rowChangedJson = stateManager.currentRow!.toJson();
                  print(
                      '=>>> rowIdChanged: $rowIdChanged     colIdChange: $colIdChange  rowChangedJson: $rowChangedJson ');

                  if (colIdChange == 2) {
                    var empId =
                        rowChangedJson['empId'].split('   ')[0]; // 3 spaces
                    stateManager.currentRow?.cells['empId']?.value = empId;
                    var name = rowChangedJson['empId'].split('   ')[1];
                    stateManager.currentRow?.cells['name']?.value = name;
                  }
                });
              },
              onLoaded: (PlutoGridOnLoadedEvent event) {
                print('onLoaded');
                firstBuild = false;
                stateManager = event.stateManager;
                stateManager.setShowColumnFilter(true);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PlutoColumn> getColumns() {
    List<PlutoColumn> columns = [];
    columns = [
      PlutoColumn(
          title: 'From Date',
          field: 'fromDate',
          width: 200,
          type: PlutoColumnType.date(
              format: "dd-MMM-yyyy", defaultValue: DateTime.now()),
          renderer: (rendererContext) {
            return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                  setState(() {
                    newOrEdit = '';
                  });
                  if (row['objectId'].toString().isEmpty ||
                      row['objectId'] == null) {
                    rendererContext.stateManager
                        .removeRows([rendererContext.row]);
                  } else {
                    AwesomeDialog(
                            context: context,
                            body: Column(
                              children: [
                                Text(
                                  'Delete ?\nFROM ${row['fromDate']} TO ${row['toDate']}\nEmployee ID: ${row['empId']}\nName: ${row['name']}\nTime: ${row['fromTime']} to ${row['toTime']}',
                                  style: style,
                                ),
                              ],
                            ),
                            width: 800,
                            dialogType: DialogType.question,
                            animType: AnimType.rightSlide,
                            enableEnterKey: true,
                            showCloseIcon: true,
                            btnOkOnPress: () async {
                              gValue.mongoDb.deleteOneOtRegister(
                                  row['objectId'].toString().substring(10, 34));
                              rendererContext.stateManager
                                  .removeRows([rendererContext.row]);
                            },
                            closeIcon: const Icon(Icons.close))
                        .show();
                  }
                },
                iconSize: 18,
                color: Colors.red,
                padding: const EdgeInsets.all(0),
              ),
              Expanded(
                child: Text(
                  rendererContext.row.cells[rendererContext.column.field]!.value
                      .toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              newOrEdit != '' && rendererContext.rowIdx == rowIdChanged
                  ? IconButton(
                      onPressed: () {
                        var currentOtRegister = <String, dynamic>{
                          'fromDate': DateFormat('dd-MMM-yyyy')
                              .parseUtc(stateManager
                                  .currentRow?.cells['fromDate']?.value)
                              .add(const Duration(
                                  hours: 23, minutes: 59, seconds: 59)),
                          'toDate': DateFormat('dd-MMM-yyyy')
                              .parseUtc(stateManager
                                  .currentRow?.cells['toDate']?.value)
                              .add(const Duration(
                                  hours: 23, minutes: 59, seconds: 59)),
                          'empId':
                              stateManager.currentRow?.cells['empId']?.value,
                          'name': stateManager.currentRow?.cells['name']?.value,
                          'fromTime':
                              stateManager.currentRow?.cells['fromTime']?.value,
                          'toTime':
                              stateManager.currentRow?.cells['toTime']?.value,
                        };
                        var key, value;
                        switch (colIdChange) {
                          case 0:
                            key = 'fromDate';
                            value = currentOtRegister['fromDate'];
                            break;
                          case 1:
                            key = 'toDate';
                            value = currentOtRegister['toDate'];
                            break;
                          case 2:
                            key = 'empId';
                            value = currentOtRegister['empId'];
                            break;
                          case 3:
                            key = 'name';
                            value = currentOtRegister['name'];
                            break;
                          case 4:
                            key = 'fromTime';
                            value = currentOtRegister['fromTime'];
                            break;
                          case 5:
                            key = 'toTime';
                            value = currentOtRegister['toTime'];
                            break;
                          default:
                        }
                        newOrEdit == 'edit'
                            ? {
                                gValue.mongoDb.updateOneOtRegisterByObjectId(
                                    rowChangedJson['objectId']
                                        .toString()
                                        .substring(10, 34),
                                    key,
                                    value)
                              }
                            : {
                                checkNewOtRegisterEditBeforeImport(
                                    currentOtRegister)
                              };
                        setState(() {
                          newOrEdit = '';
                        });
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.green,
                      ),
                    )
                  : Container(),
            ]);
          }),
      PlutoColumn(
        width: 120,
        title: 'To Date',
        field: 'toDate',
        sort: PlutoColumnSort.descending,
        type: PlutoColumnType.date(
            format: "dd-MMM-yyyy",
            defaultValue: DateTime.now().add(const Duration(days: 31))),
      ),
      PlutoColumn(
        title: 'Employee ID',
        field: 'empId',
        type: PlutoColumnType.select(gValue.employeeIdNames,
            enableColumnFilter: true),
      ),
      PlutoColumn(
        enableEditingMode: false,
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 110,
        title: 'Time Begin',
        field: 'fromTime',
        type: PlutoColumnType.text(defaultValue: '17:00'),
      ),
      PlutoColumn(
        width: 110,
        title: 'Time End',
        field: 'toTime',
        type: PlutoColumnType.text(defaultValue: '19:00'),
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

  List<PlutoRow> getRows(List<OtRegister> data) {
    List<PlutoRow> rows = [];
    for (var element in data.reversed) {
      rows.add(
        PlutoRow(
          cells: {
            'fromDate': PlutoCell(value: element.fromDate),
            'toDate': PlutoCell(value: element.toDate),
            'empId': PlutoCell(value: element.empId),
            'name': PlutoCell(value: element.name),
            'fromTime': PlutoCell(value: element.fromTime),
            'toTime': PlutoCell(value: element.toTime),
            'objectId': PlutoCell(value: element.objectId),
          },
        ),
      );
    }
    return rows;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  checkNewOtRegisterEditBeforeImport(Map<String, dynamic> newOtRegisterMap) {
    for (var currentOtRegister in gValue.otRegisters) {
      if (currentOtRegister.toDate.isAfter(newOtRegisterMap['fromDate']) &&
          currentOtRegister.empId == newOtRegisterMap['empId']) {
        gValue.mongoDb.updateOneOtRegisterByObjectId(
            currentOtRegister.objectId.substring(10, 34),
            'toDate',
            newOtRegisterMap['fromDate'].subtract(const Duration(days: 1)));
      }
      gValue.mongoDb.addOneOtRegisterFromMap(newOtRegisterMap);
    }
  }

  void onSelectionChangedDate(DateRangePickerSelectionChangedArgs args) {
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
  }
}
