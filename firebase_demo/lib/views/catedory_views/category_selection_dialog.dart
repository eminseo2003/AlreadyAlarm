import 'package:flutter/material.dart';

class CategorySelectionDialog extends StatefulWidget {
  final List<String> selectedCategories;
  final Function(List<String>) onSelectedCategoriesChanged;

  const CategorySelectionDialog({
    Key? key,
    required this.selectedCategories,
    required this.onSelectedCategoriesChanged,
  }) : super(key: key);

  @override
  _CategorySelectionDialogState createState() => _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  List<String> _tempSelectedCategories = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedCategories = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = ["오늘", "예정", "전체", "완료됨"];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "표시할 카테고리 선택",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: categories.map((category) {
              return CheckboxListTile(
                title: Text(category),
                value: _tempSelectedCategories.contains(category),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _tempSelectedCategories.add(category);
                    } else {
                      _tempSelectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context), // 취소
                child: const Text("취소"),
              ),
              TextButton(
                onPressed: () {
                  widget.onSelectedCategoriesChanged(_tempSelectedCategories);
                  Navigator.pop(context);
                },
                child: const Text("확인"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
