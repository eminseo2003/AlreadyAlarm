import 'package:flutter/material.dart';
import '../services/alarm_service.dart';
import '../services/userlist_service.dart';

import '../models/alarm_model.dart';
import '../models/repeatfrequency_model.dart';
import '../models/priority_model.dart';
import '../models/userlist_model.dart';

import 'add_alarm_view.dart';
import 'edit_userlist_view.dart';

class AlarmListView extends StatefulWidget {
  final UserListModel userList;

  const AlarmListView({super.key, required this.userList});

  

  @override
  AlarmListViewState createState() => AlarmListViewState();
}

class AlarmListViewState extends State<AlarmListView> {
  final AlarmService _alarmService = AlarmService();
  final UserlistService _userlistService = UserlistService();
  late SortOption _selectedSortOption;
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    _selectedSortOption = widget.userList.sortOption;
  }

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditUserListView(userList: widget.userList),
          ),
        ).then((editUserList) {
          if (editUserList != null && editUserList is UserListModel) {
            setState(() {
              widget.userList.name = editUserList.name;
              widget.userList.color = editUserList.color;
            });
          }
        });
        break;
      case 1:
        break;
      case 2:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("정렬 방식"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: SortOption.values.map((option) => 
                RadioListTile<SortOption>(
                  title: Text(option.key),
                  value: option,
                  groupValue: _selectedSortOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedSortOption = value!;
                    });
                    
                    _userlistService.updateSortOption(widget.userList.id, value?.key ?? "수동");
                    Navigator.pop(context);
                  },
                ),
              ).toList(),
            ),
          ),
        );
        break;
      case 3:
        setState(() {
          _showCompleted = !_showCompleted;
        });
        break;
      case 4:
        _showDeleteConfirmation(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          _buildPopupMenu(),
        ],
      ),
      body: StreamBuilder<List<AlarmModel>>(
        stream: _userlistService.getAlarmsForUserList(widget.userList.id),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("데이터 로딩 중 오류 발생!"),
                  Text("오류 내용: ${snapshot.error}"),
                ],
              ),
            );
          }


          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator()); 
          }
          final alarms = snapshot.data!;
          final filteredAlarms = _showCompleted
              ? alarms
              : alarms.where((alarm) => !alarm.isCompleted).toList();

          if (filteredAlarms.isEmpty) {
            return const Center(child: Text("등록된 알람이 없습니다."));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                  widget.userList.name,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: widget.userList.colorValue,
                  ),
                  textAlign: TextAlign.left,
                ),
                )
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAlarms.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // 여백 추가
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
                            activeColor: widget.userList.colorValue,// 체크 시 색상
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
                                          color: widget.userList.colorValue,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAlarmView()),
                );
              },
              child: const Icon(Icons.add),
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
        _buildMenuItem(0, "목록 정보 보기", Icons.info),
        _buildMenuItem(1, "미리 알림 선택", Icons.check_circle),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("다음으로 정렬"),
                  SizedBox(width: 10),
                  Text(widget.userList.sortOption.key, style: TextStyle(color: Colors.grey)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0, top: 5),
                child: Icon(Icons.swap_vert, color: Colors.black54),
              ),
            ],
          ),
        ),
        _buildMenuItem(3, _showCompleted ? "완료된 항목 숨기기" : "완료된 항목 보기", Icons.remove_red_eye),
        _buildMenuItem(4, "목록 삭제", Icons.delete, color: Colors.red),
      ],
    );
  }
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text("목록 삭제"),
        content: Text("이 목록을 삭제하시겠습니까?\n모든 알람도 함께 삭제됩니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("취소"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _userlistService.deleteUserList(widget.userList.id);
              Navigator.pop(context);// 뒤로가기가 안돼
            },
            child: Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
