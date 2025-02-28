import 'package:flutter/material.dart';
import '../services/userlist_service.dart';
import '../models/userlist_model.dart';

class AddUserListView extends StatefulWidget {
  const AddUserListView({super.key});

  @override
  AddUserListViewState createState() => AddUserListViewState();
}

class AddUserListViewState extends State<AddUserListView> { 
  final UserlistService _userlistService = UserlistService();


  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
        centerTitle: true,
        title: Text(
          "새로운 목록",
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
            onPressed: _saveUserList,
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
                                color: _selectedColor,
                                blurRadius: 15, 
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: _selectedColor,
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
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: _selectedColor
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
          bool isSelected = color == _selectedColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
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
  void _saveUserList() async {
    if (_nameController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("목록 이름을 입력해주세요.")),
      );
      return;
    }
    UserListModel newUserList = UserListModel(
      name: _nameController.text,
      color: _getColorName(_selectedColor),
    );

    await _userlistService.addUserList(newUserList);
    
    if (!mounted) return;
    Navigator.pop(context); // 저장 후 이전 화면으로 이동
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

