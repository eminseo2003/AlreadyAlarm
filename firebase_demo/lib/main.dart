import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../services/userlist_service.dart';
import '../services/alarm_service.dart';

import '../models/userlist_model.dart';
import '../models/alarm_model.dart';
import '../models/repeatfrequency_model.dart';
import '../models/priority_model.dart';

import 'views/alarmlist_views/alarm_list_view.dart';
import 'views/add_views/add_alarm_view.dart';
import 'views/add_views/add_userlist_view.dart';

import 'views/catedory_views/today_alarmlist_view.dart';
import 'views/catedory_views/scheduled_alarmlist_view.dart';
import 'views/catedory_views/all_alarmlist_view.dart';
import 'views/catedory_views/complete_alarmlist_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final UserlistService _userlistService = UserlistService();
  final AlarmService _alarmService = AlarmService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  int _todayCount = 0;
  int _scheduledCount = 0;
  int _allCount = 0;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAlarmCounts();
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  Future<void> _fetchAlarmCounts() async {
    int todayCount = await _alarmService.getTodayAlarmCount();
    int scheduledCount = await _alarmService.getScheduledAlarmCount();
    int allCount = await _alarmService.getAllAlarmCount();
    int completedCount = await _alarmService.getCompletedAlarmCount();

    setState(() {
      _todayCount = todayCount;
      _scheduledCount = scheduledCount;
      _allCount = allCount;
      _completedCount = completedCount;
    });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(242, 242, 247, 1.0),
        actions: [
          TextButton(
            onPressed: () {
              // 
            },
            child: Text(
              "편집",
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(242, 242, 247, 1.0),
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAlarmView()),
                ).then((_) {
                  _fetchAlarmCounts();
                });
              },
              icon: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 12,
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
              label: Text("새로운 미리 알림", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserListView()),
                ).then((_) {
                  _fetchAlarmCounts();
                });
              },
              child: Text("목록 추가", style: TextStyle(color: Colors.blue, fontSize: 18)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 105, 105, 105)),
                    suffixIcon: Icon(Icons.mic, color: const Color.fromARGB(255, 105, 105, 105)),
                    hintText: "검색",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Color.fromRGBO(223, 223, 229, 1),
                    contentPadding: EdgeInsets.symmetric(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),  
              ),
              
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                children: [
                  Flexible(
                    child: _searchQuery.isEmpty ? _buildDefaultView() : _buildSearchResults(),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildDefaultView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 100,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final icons = [Icons.calendar_today, Icons.calendar_month, Icons.list, Icons.check_circle];
                final titles = ["오늘", "예정", "전체", "완료됨"];
                final counts = [_todayCount, _scheduledCount, _allCount, _completedCount];
                final colors = [Colors.blue, Colors.red, Colors.black, Colors.grey];

                return GestureDetector(
                  onTap: () {
                    _navigateToView(context, index);
                  },
                  child: _buildStatusCard(icons[index], titles[index], counts[index], colors[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: Row(
              children: [
                Text("나의 목록", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(
            child: StreamBuilder<List<UserListModel>>(
              stream: _userlistService.getUserLists(),
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
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final userlists = snapshot.data!;
                if (userlists.isEmpty) {
                  return const Center(child: Text("등록된 리스트가 없습니다."));
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: userlists.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color.fromARGB(255, 226, 226, 226),
                        height: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        final userlist = userlists[index];

                        return Dismissible(
                          key: Key(userlist.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            color: Colors.red, // 삭제 배경 색상
                            child: Icon(Icons.delete, color: Colors.white, size: 30),
                          ),
                          onDismissed: (direction) async {
                            await _userlistService.deleteUserList(userlist.id);
                            setState(() {
                              userlists.removeAt(index);
                            });
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: userlist.colorValue,
                              radius: 18,
                              child: Icon(Icons.list, color: Colors.white, size: 25),
                            ),
                            title: Text(
                              userlist.name,
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${userlist.alarms?.length ?? 0}",
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AlarmListView(userList: userlist)),
                              ).then((_) {
                                _fetchAlarmCounts();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
  Widget _buildStatusCard(IconData icon, String title, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: color, size: 35),
                    Text(title, style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),  
                  ],
                ),
                Spacer(),
                Text("$count", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSearchResults() {
    return StreamBuilder<List<AlarmModel>>(
      stream: _alarmService.getAlarms(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("오류 발생: ${snapshot.error}"));
        }
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        List<AlarmModel> alarms = snapshot.data ?? [];

        // 🔍 검색어 필터링
        alarms = alarms.where((alarm) {
          return alarm.title.toLowerCase().contains(_searchQuery) ||
              alarm.memo.toLowerCase().contains(_searchQuery);
        }).toList();

        if (alarms.isEmpty) {
          return const Center(child: Text("검색 결과가 없습니다."));
        }

        return ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (context, index) {
            return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: alarms[index].isCompleted,
                            onChanged: (bool? newValue) async {
                              setState(() {
                                alarms[index].isCompleted = newValue ?? false;
                              });
                              await _alarmService.updateAlarmStatus(
                                alarms[index].id,
                                alarms[index].isCompleted,
                              );
                            },
                            activeColor: Colors.grey,
                            checkColor: Colors.white,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (alarms[index].priority != Priority.none) ...[
                                      Text(
                                        _prioritySymbol(alarms[index].priority),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                    
                                    Text(
                                      alarms[index].title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: alarms[index].isCompleted
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  alarms[index].memo,
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (alarms[index].date != null) ...[
                                      Text(
                                        "${alarms[index].date!.year}. ${alarms[index].date!.month}. ${alarms[index].date!.day}.",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                    if (alarms[index].time != null) ...[
                                      Text(
                                        "${alarms[index].time!.hour}:${alarms[index].time!.minute}",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                    if (alarms[index].repeatFrequency != RepeatFrequency.none) ...[
                                      Icon(
                                        Icons.autorenew,
                                        color: Colors.grey,
                                        size: 14,
                                      ),
                                      Text(
                                        alarms[index].repeatFrequency.title,
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                    if (alarms[index].location != null) ...[
                                      
                                      Text(
                                        "${alarms[index].location}",
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
        );
      },
    );
  }
  void _navigateToView(BuildContext context, int index) {
  Widget destination;
    switch (index) {
      case 0:
        destination = TodayView();
        break;
      case 1:
        destination = ScheduledView();
        break;
      case 2:
        destination = AllTasksView();
        break;
      case 3:
        destination = CompletedView();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    ).then((_) {
      _fetchAlarmCounts(); 
    });
  }
}
