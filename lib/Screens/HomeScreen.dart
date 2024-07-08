import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Task%20Screens/AllTaskScreen.dart';
import 'package:flutter_application_1/Task%20Screens/CompletedScreen.dart';
import 'package:flutter_application_1/Task%20Screens/PendingTaskScreen.dart';
import 'package:flutter_application_1/Task%20Screens/TodayTaskScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: Column(
            children: [
              CustomContainer(text: "Home"),
              const TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: [
                  Tab(
                    text: "All Task",
                  ),
                  Tab(
                    text: "Today Task",
                  ),
                  Tab(
                    text: "Pending Task",
                  ),
                  Tab(text: "Completed Task")
                ],
              ),
              const Expanded(
                  child: TabBarView(children: [
                AllTaskScreen(),
                TodayTaskScreen(),
                PendingTask(),
                CompletedScreenTask()
              ]))
            ],
          ),
        ));
  }
}
