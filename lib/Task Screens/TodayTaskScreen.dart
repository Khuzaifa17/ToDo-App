import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Models/add_data_entity.dart';
import 'package:intl/intl.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({super.key});

  @override
  State<TodayTaskScreen> createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  final TextEditingController searchController = TextEditingController();
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  Stream<QuerySnapshot<AddEntity>> _fetchData() {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    return AddEntity.collection()
        .where('userID', isEqualTo: userId)
        .snapshots();
  }

  bool _isToday(DateTime date) {
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimSearchBar(
            width: 400,
            textController: searchController,
            onSuffixTap: () {
              searchController.clear();
            },
            onSubmitted: (value) {},
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<AddEntity>>(
              stream: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }
                List<DocumentSnapshot<AddEntity>> allData = snapshot.data!.docs;
                List<DocumentSnapshot<AddEntity>> filterData =
                    allData.where((doc) {
                  var data = doc.data()!;
                  return _isToday(data.dateTime!) &&
                      !data.isCompleted &&
                      data.taskname!
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filterData.length,
                  itemBuilder: (context, index) {
                    AddEntity addData = filterData[index].data()!;
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(addData.dateTime!);
                    return Container(
                      margin: const EdgeInsets.all(8),
                      height: 70,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 10,
                              offset: Offset(5.0, 5.0),
                              color: Colors.grey,
                              spreadRadius: 2.0),
                          BoxShadow(
                              blurRadius: 0,
                              color: Colors.white,
                              spreadRadius: 0,
                              offset: Offset(0, 0))
                        ],
                        border: Border.all(width: 1, color: Colors.indigo),
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  filterData[index].data()!.image!),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                DefaultText(
                                  text: addData.taskname!,
                                  color: Colors.black,
                                ),
                                DefaultText(text: formattedDate)
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Delete Task"),
                                          content: const Text(
                                              "Are you sure you want to delete this task?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                AddEntity.collection()
                                                    .doc(addData.addId)
                                                    .delete();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Container(
                                            height: 120,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                DefaultText(
                                                    text:
                                                        "Are You Completed this Task?"),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        await AddEntity.doc(
                                                                addId: addData
                                                                    .addId
                                                                    .toString())
                                                            .update({
                                                          "isCompleted": true
                                                        });
                                                      },
                                                      child: const Text("Yes"),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: addData.isCompleted == true
                                      ? const Text("Completed")
                                      : const Text("Pending"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
