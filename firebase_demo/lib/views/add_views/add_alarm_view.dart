import 'package:flutter/material.dart';
import '../../services/alarm_service.dart';

import '../../models/alarm_model.dart';
import '../../models/repeatfrequency_model.dart';
import '../../models/priority_model.dart';
import '../../models/userlist_model.dart';

import 'add_alarmdetail_view.dart';
import 'select_userlist_view.dart';

class AddAlarmView extends StatefulWidget {
  const AddAlarmView({super.key});

  @override
  AddAlarmViewState createState() => AddAlarmViewState();
}

class AddAlarmViewState extends State<AddAlarmView> {
  final AlarmService _alarmService = AlarmService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  RepeatFrequency selectedRepeat = RepeatFrequency.none;
  DateTime? _selectedrepeatEndDate;
  Priority selectedPriority = Priority.none;
  UserListModel? _selectedUserList; 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
        centerTitle: true,
        title: Text(
          "새로운 미리 알림",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "취소",
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
          actions: [
            TextButton(
            onPressed: () {
              _saveAlarm();
            },
            child: Text(
              "저장",
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: "제목",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                            border: InputBorder.none,
                          ),
                        ),
                        Divider(height:0.5, color: Color.fromARGB(255, 226, 226, 226)),
                        TextField(
                          controller: _memoController,
                          decoration: InputDecoration(
                            hintText: "메모",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 80, top: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      "세부사항",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    subtitle: Text(
                      _buildFormattedDateTime(),
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () async {
                      final result = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAlarmDetailView(
                            initialDate: _selectedDate,
                            initialTime: _selectedTime,
                            initialRepeat: selectedRepeat,
                            initialRepeatEndDate: _selectedrepeatEndDate,
                            initialPriority: selectedPriority,
                            initialLocation: _locationController.text,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _selectedDate = result['date'];
                          _selectedTime = result['time'];
                          selectedRepeat = result['repeat'];
                          _selectedrepeatEndDate = result['repeatEndDate'];
                          selectedPriority = result['priority'];
                          _locationController.text = result['location'] ?? "";
                        });
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _selectedUserList?.colorValue ?? Colors.blue,
                      child: Icon(Icons.list, color: Colors.white),
                    ),
                    title: Text(
                      "목록",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedUserList?.name ?? "선택하세요",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                    onTap: () async {
                      final selectedList = await Navigator.push<UserListModel>(
                        context,
                        MaterialPageRoute(builder: (context) => SelectUserListView()),
                      );
                      if (selectedList != null) {
                        setState(() {
                          _selectedUserList = selectedList;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _buildFormattedDateTime() {
    String formattedDateTime = "";

    if (_selectedDate != null) {
      formattedDateTime += "날짜: ${_selectedDate!.year}.${_selectedDate!.month}.${_selectedDate!.day}\n";
    } else {
      formattedDateTime += "";
    }

    if (_selectedTime != null) {
      formattedDateTime += "시간: ${_selectedTime!.hour}:${_selectedTime!.minute}\n";
    } else {
      formattedDateTime += "";
    }

    if (_locationController.text.isEmpty) {
      formattedDateTime += "";
    } else {
      formattedDateTime += "위치: ${_locationController.text}\n";
    }

    if (selectedRepeat == RepeatFrequency.none) {
      formattedDateTime += "";
    } else {
      formattedDateTime += "반복: ${selectedRepeat.title}\n";
    }

    if (_selectedrepeatEndDate != null) {
      formattedDateTime += "반복 종료: ${_selectedrepeatEndDate!.year}.${_selectedrepeatEndDate!.month}.${_selectedrepeatEndDate!.day}\n";
    } else {
      formattedDateTime += "";
    }

    if (selectedPriority == Priority.none) {
      formattedDateTime += "";
    } else {
      formattedDateTime += "우선순위: ${selectedPriority.title}\n";
    }

    return formattedDateTime.trim();
  }

  void _saveAlarm() async {
    if (_titleController.text.isEmpty ||
      _memoController.text.isEmpty ||
      _selectedUserList == null) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("제목, 메모, 목록을 모두 입력해주세요.")),
    );
    return;
  }
    DateTime? finalDate;
    if (_selectedDate != null) {
      finalDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );
    }
    DateTime? finalTime;
    if (_selectedTime != null) {
      finalTime = DateTime(
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }
    DateTime? endTime;
    if (_selectedrepeatEndDate != null) {
      endTime = DateTime(
        _selectedrepeatEndDate!.year,
        _selectedrepeatEndDate!.month,
        _selectedrepeatEndDate!.day,
      );
    }

    AlarmModel newAlarm = AlarmModel(
      title: _titleController.text,
      memo: _memoController.text,
      isCompleted: false,
      date: finalDate,
      time: finalTime,
      priority: selectedPriority,
      repeatFrequency: selectedRepeat,
      repeatEndDate: endTime,
      location: _locationController.text.isEmpty ? null : _locationController.text,
      userListId: _selectedUserList!.id,
    );

    await _alarmService.addAlarm(newAlarm);
    
    if (!mounted) return;
    Navigator.pop(context);
  }
  

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}