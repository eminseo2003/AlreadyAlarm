// import 'package:flutter/material.dart';
// import '../services/userlist_service.dart';
// import '../models/userlist_model.dart';
// import 'add_userlist_view.dart';

// class UserListView extends StatelessWidget {
//   final UserlistService _userlistService = UserlistService();

//   UserListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('유저 리스트 리스트'),
//       ),
//       body: StreamBuilder<List<UserListModel>>(
//         stream: _userlistService.getUserLists(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final userlists = snapshot.data!;
//           if (userlists.isEmpty) {
//             return const Center(child: Text("등록된 알람이 없습니다."));
//           }
//           return ListView.builder(
//             itemCount: userlists.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(userlists[index].name),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     await _userlistService.deleteUserList(userlists[index].id);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AddUserListView()),
//                 );
//               },
//               child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
