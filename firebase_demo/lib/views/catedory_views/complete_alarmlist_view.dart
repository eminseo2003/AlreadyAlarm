import 'package:flutter/material.dart';
import '../../services/alarm_service.dart';

import '../../models/alarm_model.dart';
import '../../models/repeatfrequency_model.dart';
import '../../models/priority_model.dart';

class CompletedView extends StatefulWidget {

  const CompletedView({super.key});

  @override
  CompletedViewState createState() => CompletedViewState();
}

class CompletedViewState extends State<CompletedView> {
  final AlarmService _alarmService = AlarmService();

  String _prioritySymbol(Priority priority) {
    switch (priority) {
      case Priority.none:
        return ""; 
      case Priority.low:
        return "!";
      case Priority.medium:
        return "!!";
      case Priority.high:
        return "!!!";
    }
  }
  void _handleMenuSelection(int value) {
    switch (value) {
      case 0:
        break;
    }
  }
  PopupMenuItem<int> _buildMenuItem(int value, String text, IconData icon, {Color color = Colors.black}) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(color: color)),
          Icon(icon, color: color),
        ],
      ),
    );
  }
  int _completedCount = 0;
  @override
  void initState() {
    super.initState();
    _fetchAlarmCounts();
  }
  Future<void> _fetchAlarmCounts() async {
    int completedCount = await _alarmService.getCompletedAlarmCount();

    setState(() {
      _completedCount = completedCount;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("완료"),
        backgroundColor: Colors.white,
        actions: [
          _buildPopupMenu(),
        ],
      ),
      body: StreamBuilder<List<AlarmModel>>(
        stream: _alarmService.getCompletedAlarms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("오류 발생: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final filteredAlarms = snapshot.data!;
          
          if (filteredAlarms.isEmpty) {
            return Center(child: Text("오늘 일정이 없습니다."));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "완료됨",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      
                      Row(
                        children: [
                          Text(
                            "${_completedCount}개 완료됨",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 65, 65, 65),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          //SizedBox(width: 2),
                          TextButton(
                            onPressed: () async {
                              await _alarmService.deleteAllCompletedAlarms(filteredAlarms);
                              setState(() {}); // UI 갱신
                            },
                            child: Text(
                              "지우기",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            )
                        ],
                      )
                      
                    ],
                  )
                )
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAlarms.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: filteredAlarms[index].isCompleted,
                            onChanged: (bool? newValue) async {
                              setState(() {
                                filteredAlarms[index].isCompleted = newValue ?? false;
                              });
                              await _alarmService.updateAlarmStatus(
                                filteredAlarms[index].id,
                                filteredAlarms[index].isCompleted,
                              );
                            },
                            activeColor: Colors.grey,
                            checkColor: Colors.white,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (filteredAlarms[index].priority != Priority.none) ...[
                                      Text(
                                        _prioritySymbol(filteredAlarms[index].priority),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                    
                                    Text(
                                      filteredAlarms[index].title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: filteredAlarms[index].isCompleted
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  filteredAlarms[index].memo,
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (filteredAlarms[index].date != null) ...[
                                      Text(
                                        "${filteredAlarms[index].date!.year}. ${filteredAlarms[index].date!.month}. ${filteredAlarms[index].date!.day}.",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                    if (filteredAlarms[index].time != null) ...[
                                      Text(
                                        "${filteredAlarms[index].time!.hour}:${filteredAlarms[index].time!.minute}",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                    if (filteredAlarms[index].repeatFrequency != RepeatFrequency.none) ...[
                                      Icon(
                                        Icons.autorenew,
                                        color: Colors.grey,
                                        size: 14,
                                      ),
                                      Text(
                                        filteredAlarms[index].repeatFrequency.title,
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                    if (filteredAlarms[index].location != null) ...[
                                      
                                      Text(
                                        "${filteredAlarms[index].location}",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ],
                                ),
                                
                                const Divider(),

                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),

              )
            ],
          );
        },
      ),
    );
  }
  Widget _buildPopupMenu() {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_horiz, color: Colors.black, size: 24),
      onSelected: (value) {
        setState(() {
          _handleMenuSelection(value);
        });
      },
      itemBuilder: (context) => [
        _buildMenuItem(0, "미리 알림 선택", Icons.check_circle),
      ],
    );
  }
}

