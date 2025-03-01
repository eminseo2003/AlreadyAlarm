import 'package:flutter/material.dart';
import '../../models/userlist_model.dart';
import '../../services/userlist_service.dart';

class SelectUserListView extends StatelessWidget {
  final UserlistService _userlistService = UserlistService();

  SelectUserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("목록 선택")),
      body: StreamBuilder<List<UserListModel>>(
        stream: _userlistService.getUserLists(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final lists = snapshot.data!;
          if (lists.isEmpty) {
            return const Center(child: Text("등록된 알람이 없습니다."));
          }
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final userList = lists[index];

              return ListTile(
                leading: CircleAvatar(backgroundColor: userList.colorValue, child: Icon(Icons.list, color: Colors.white)),
                title: Text(userList.name),
                onTap: () {
                  Navigator.pop(context, userList);
                },
              );
            },
          );
        },
      ),
    );
  }
}