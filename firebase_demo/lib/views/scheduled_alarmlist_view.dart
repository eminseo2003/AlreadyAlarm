import 'package:flutter/material.dart';
import '../services/alarm_service.dart';
import '../models/alarm_model.dart';

class ScheduledView extends StatelessWidget {
 final AlarmService _alarmService = AlarmService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("예정된 알람")),
      body: StreamBuilder<List<AlarmModel>>(
        stream: _alarmService.getScheduledAlarms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("오류 발생: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final alarms = snapshot.data!;
          if (alarms.isEmpty) {
            return Center(child: Text("오늘 일정이 없습니다."));
          }
          return ListView.builder(
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(alarms[index].title),
                subtitle: Text("메모: ${alarms[index].memo}"),
                trailing: alarms[index].isCompleted
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.radio_button_unchecked),
              );
            },
          );
        },
      ),
    );
  }
}

