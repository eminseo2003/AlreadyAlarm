import 'package:flutter/material.dart';
import '../services/userlist_service.dart';
import '../models/userlist_model.dart';

class EditUserListView extends StatefulWidget {
  
  final UserListModel userList;
  const EditUserListView({super.key, required this.userList});
  @override
  EditUserListViewState createState() => EditUserListViewState();
}

class EditUserListViewState extends State<EditUserListView> { 
  final UserlistService _userlistService = UserlistService();


  late TextEditingController _updatenameController;
  late Color _updateColor;

  @override
  void initState() {
    super.initState();
    _updatenameController = TextEditingController(text: widget.userList.name);
    _updateColor = widget.userList.colorValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
        centerTitle: true,
        title: Text(
          "목록 정보 보기",
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
            onPressed: _editUserList,
            child: Text(
              "완료",
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
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _updateColor,
                                blurRadius: 15, 
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: _updateColor,
                            radius: 50, 
                            child: const Icon(Icons.list, color: Colors.white, size: 70),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(242, 242, 247, 1.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: TextField(
                            controller: _updatenameController,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: _updateColor
                            ),
                            decoration: const InputDecoration(
                              hintText: "목록 이름",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 22, fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {}); 
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ]
                    )
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    child: _buildColorPicker(),
                  )
                ),
              )
            ]
          )
        )
      ),
    );
    
  }
  Widget _buildColorPicker() {
    final List<Color> colors = [
      Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple, Colors.brown
    ];

    return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: colors.map((color) {
          bool isSelected = color == _updateColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                _updateColor = color;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.grey, width: 3)
                    : null,
              ),
              padding: const EdgeInsets.all(3),
              child: CircleAvatar(
                backgroundColor: color,
                radius: 20, 
              ),
            ),
          );
        }).toList(),
      );
  }
  void _editUserList() async {
    if (_updatenameController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("목록 이름을 입력해주세요.")),
      );
      return;
    }
    UserListModel editUserList = UserListModel(
      id: widget.userList.id,
      name: _updatenameController.text,
      color: _getColorName(_updateColor),
      alarms: widget.userList.alarms,
      sortOption: widget.userList.sortOption,
    );

    await _userlistService.updateUserList(editUserList);
    
    if (!mounted) return;
    Navigator.pop(context, editUserList); // 저장 후 이전 화면으로 이동
  }
  String _getColorName(Color color) {
    Map<Color, String> colorMap = {
      Colors.red: "red",
      Colors.orange: "orange",
      Colors.yellow: "yellow",
      Colors.green: "green",
      Colors.blue: "blue",
      Colors.purple: "purple",
      Colors.brown: "brown",
    };
    return colorMap[color] ?? "blue";
  }
}

