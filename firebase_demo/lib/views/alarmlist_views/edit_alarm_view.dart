import 'package:flutter/material.dart';
import '../../services/alarm_service.dart';
import '../../services/userlist_service.dart';

import '../../models/alarm_model.dart';
import '../../models/repeatfrequency_model.dart';
import '../../models/priority_model.dart';
import '../../models/userlist_model.dart';

import '../alarmlist_views/edit_alarmdetail_view.dart';
import '../alarmlist_views/update_select_userlist_view.dart';

class AlarmEditView extends StatefulWidget {
  final AlarmModel alarm;
  const AlarmEditView({super.key, required this.alarm});

  @override
  AlarmEditViewState createState() => AlarmEditViewState();
}

class AlarmEditViewState extends State<AlarmEditView> {
  final AlarmService _alarmService = AlarmService();
  final UserlistService _userlistService = UserlistService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  RepeatFrequency _selectedRepeat = RepeatFrequency.none;
  DateTime? _selectedRepeatEndDate;
  Priority _selectedPriority = Priority.none;
  UserListModel? _selectedUserList;

  @override
  void initState() {
    super.initState();
    _initializeAlarmData();
  }

  void _initializeAlarmData() async {
    _titleController.text = widget.alarm.title;
    _memoController.text = widget.alarm.memo;
    _locationController.text = widget.alarm.location ?? "";
    _selectedDate = widget.alarm.date;
    _selectedTime = widget.alarm.time != null
        ? TimeOfDay.fromDateTime(widget.alarm.time!)
        : null;
    _selectedRepeat = widget.alarm.repeatFrequency;
    _selectedRepeatEndDate = widget.alarm.repeatEndDate;
    _selectedPriority = widget.alarm.priority;

    _selectedUserList = await _userlistService.getUserListById(widget.alarm.userListId);
    
    if (mounted) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
        centerTitle: true,
        title: Text(
          "미리 알림 수정",
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
              _updateAlarm();
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
                            initialRepeat: _selectedRepeat,
                            initialRepeatEndDate: _selectedRepeatEndDate,
                            initialPriority: _selectedPriority,
                            initialLocation: _locationController.text,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _selectedDate = result['date'];
                          _selectedTime = result['time'];
                          _selectedRepeat = result['repeat'];
                          _selectedRepeatEndDate = result['repeatEndDate'];
                          _selectedPriority = result['priority'];
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
                      radius: 20,
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

    if (_selectedRepeat == RepeatFrequency.none) {
      formattedDateTime += "";
    } else {
      formattedDateTime += "반복: ${_selectedRepeat.title}\n";
    }

    if (_selectedRepeatEndDate != null) {
      formattedDateTime += "반복 종료: ${_selectedRepeatEndDate!.year}.${_selectedRepeatEndDate!.month}.${_selectedRepeatEndDate!.day}\n";
    } else {
      formattedDateTime += "";
    }

    if (_selectedPriority == Priority.none) {
      formattedDateTime += "";
    } else {
      formattedDateTime += "우선순위: ${_selectedPriority.title}\n";
    }

    return formattedDateTime.trim();
  }

  void _updateAlarm() async {
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
    if (_selectedTime != null && _selectedDate != null) {
      finalTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
         _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }
    DateTime? endTime;
    if (_selectedRepeatEndDate != null) {
      endTime = DateTime(
        _selectedRepeatEndDate!.year,
        _selectedRepeatEndDate!.month,
        _selectedRepeatEndDate!.day,
      );
    }

    AlarmModel editAlarm = AlarmModel(
      id: widget.alarm.id,
      title: _titleController.text,
      memo: _memoController.text,
      isCompleted: widget.alarm.isCompleted,
      date: finalDate,
      time: finalTime,
      priority: _selectedPriority,
      repeatFrequency: _selectedRepeat,
      repeatEndDate: endTime,
      createdAt: widget.alarm.createdAt,
      location: _locationController.text.isEmpty ? null : _locationController.text,
      userListId: _selectedUserList!.id,
    );

    await _alarmService.updateAlarm(editAlarm);
    
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