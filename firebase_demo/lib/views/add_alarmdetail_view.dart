import 'package:flutter/material.dart';
import '../models/repeatfrequency_model.dart';
import '../models/priority_model.dart';

class AddAlarmDetailView extends StatefulWidget {
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final RepeatFrequency initialRepeat;
  final DateTime? initialRepeatEndDate;
  final Priority initialPriority;
  final String initialLocation;

  const AddAlarmDetailView({
    super.key,
    this.initialDate,
    this.initialTime,
    this.initialRepeat = RepeatFrequency.none,
    this.initialRepeatEndDate,
    this.initialPriority = Priority.none,
    this.initialLocation = "",
  });

  @override
  AddAlarmDetailViewState createState() => AddAlarmDetailViewState();
}

class AddAlarmDetailViewState extends State<AddAlarmDetailView> {
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  RepeatFrequency _selectedRepeat = RepeatFrequency.none;
  DateTime? _selectedRepeatEndDate;
  Priority _selectedPriority = Priority.none;

  bool _isDateEnabled = false;
  bool _isTimeEnabled = false;
  bool _isRepeatEnabled = false;
  bool _isLocationEnabled = false;
  bool _isEndDateEnabled = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialTime;
    _selectedRepeat = widget.initialRepeat;
    _selectedPriority = widget.initialPriority;
    _locationController.text = widget.initialLocation;
  }
  void _saveAndReturn() {
    Navigator.pop(context, {
      'date': _isDateEnabled ? _selectedDate : null,
      'time': _isTimeEnabled ? _selectedTime : null,
      'repeat': _selectedRepeat,
      'repeatEndDate': _isEndDateEnabled ? _selectedRepeatEndDate : null,
      'priority': _selectedPriority,
      'location': _isLocationEnabled ? _locationController.text : null,
    });
  }

  String formatDate(DateTime date) {
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 '0' 추가
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
        title: const Text('세부사항'),
        actions: [
          TextButton(
            onPressed: _saveAndReturn,
            child: Text("추가", style: TextStyle(color: Colors.blue, fontSize: 18)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.calendar_today, color: Colors.white),
                      ),
                      title: Text("날짜", style: TextStyle(color: Colors.black)),
                      trailing: Switch(value: _isDateEnabled, onChanged: (val) => setState(() => _isDateEnabled = val)),
                    ),
                    if (_isDateEnabled)
                      ListTile(
                        title: Text(_selectedDate != null
                            ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
                            : "선택하세요", style: TextStyle(color: Colors.grey)),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _selectedDate = picked);
                        },
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.access_time, color: Colors.white),
                        ),
                        title: Text("시간", style: TextStyle(color: Colors.black)),
                        trailing: Switch(
                          value: _isTimeEnabled,
                          onChanged: (val) {
                            setState(() {
                              _isTimeEnabled = val;
                              
                              if (val && !_isDateEnabled) {
                                _isDateEnabled = true;
                                _selectedDate = DateTime.now();
                              }
                            });
                          },
                        ),                      
                      ),
                      if (_isTimeEnabled)
                        _buildSelectableTile(
                          subtitle: _selectedTime != null
                              ? "${_selectedTime!.hour}:${_selectedTime!.minute}"
                              : "선택하세요",
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime ?? TimeOfDay.now(),
                            );
                            if (picked != null) setState(() => _selectedTime = picked);
                          },
                        ),
                        
                    ],
                  ),
                ),
              ),
              //반복주기 설정
              if (_isDateEnabled)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.autorenew, color: Colors.white),
                          ),
                          title: Text("반복", style: TextStyle(color: Colors.black)),
                          trailing: Switch(value: _isRepeatEnabled, onChanged: (val) => setState(() => _isRepeatEnabled = val)),
                        ),
                        if (_isRepeatEnabled)
                          _buildSelectableTile(
                            subtitle: _selectedRepeat.toString().split('.').last,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("반복 설정"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: RepeatFrequency.values.map((freq) => 
                                      RadioListTile<RepeatFrequency>(
                                        title: Text(freq.toString().split('.').last),
                                        value: freq,
                                        groupValue: _selectedRepeat,
                                        onChanged: (value) {
                                          setState(() => _selectedRepeat = value!);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        if (_isRepeatEnabled)
                        ListTile(
                      title: Text("반복 종료", style: TextStyle(color: Colors.black)),
                      trailing: Switch(value: _isEndDateEnabled, onChanged: (val) => setState(() => _isEndDateEnabled = val)),
                    ),
                    if (_isEndDateEnabled)
                      ListTile(
                        title: Text(_selectedRepeatEndDate != null
                            ? "${_selectedRepeatEndDate!.year}-${_selectedRepeatEndDate!.month}-${_selectedRepeatEndDate!.day}"
                            : "선택하세요", style: TextStyle(color: Colors.grey)),
                        trailing: Row(
                              mainAxisSize: MainAxisSize.min, // 최소 크기로 맞춰서 오른쪽 끝에 배치
                              children: [
                                Text(_selectedRepeatEndDate != null
                            ? "${_selectedRepeatEndDate!.year}-${_selectedRepeatEndDate!.month}-${_selectedRepeatEndDate!.day}"
                            : "선택하세요", style: TextStyle(color: Colors.grey)),
                                SizedBox(width: 8), // 숫자와 아이콘 사이 간격 추가
                                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              ],
                            ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedRepeatEndDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _selectedRepeatEndDate = picked);
                        },
                      ),
                      ],
                    ),
                  ),
                ),

              // 위치 선택
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.location_on, color: Colors.white),
                        ),
                        title: Text("위치", style: TextStyle(color: Colors.black)),
                        trailing: Switch(value: _isLocationEnabled, onChanged: (val) => setState(() => _isLocationEnabled = val)),
                      ),
                      if (_isLocationEnabled)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _locationController,
                            decoration: InputDecoration(labelText: "위치 입력"),
                          ),
                        )
                    ],
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
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.priority_high, color: Colors.white),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("우선순위", style: TextStyle(color: Colors.black)),
                          SizedBox(width: 8),
                          Text(
                            _selectedPriority.name,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      onTap: () {
                        // 선택 다이얼로그 띄우기 (옵션 설정)
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("우선순위 설정"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: Priority.values.map((priority) {
                                return RadioListTile(
                                  title: Text(priority.toString().split('.').last),
                                  value: priority,
                                  groupValue: _selectedPriority,
                                  onChanged: (value) {
                                    setState(() => _selectedPriority = value as Priority);
                                    Navigator.pop(context);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 선택할 수 있는 항목 (날짜, 시간 선택 시)
  Widget _buildSelectableTile({required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      title: Text(subtitle, style: TextStyle(color: Colors.grey)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}