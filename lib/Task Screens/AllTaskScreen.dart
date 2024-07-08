import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Models/add_data_entity.dart';
import 'package:flutter_application_1/Screens/AddData.dart';
import 'package:intl/intl.dart';

class AllTaskScreen extends StatefulWidget {
  const AllTaskScreen({super.key});

  @override
  State<AllTaskScreen> createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends State<AllTaskScreen> {
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot<AddEntity>> allData = [];
  List<DocumentSnapshot<AddEntity>> filterData = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterData);
    searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    if (searchController.text.isEmpty) {
      setState(() {
        filterData = allData;
      });
    } else {
      setState(() {
        filterData = allData.where((doc) {
          final taskName = doc.data()?.taskname ?? '';
          return taskName
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }).toList();
      });
    }
  }

  Stream<List<DocumentSnapshot<AddEntity>>> _fetchData() {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    return AddEntity.collection()
        .where('userID', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      print(
          "Fetched Data: ${snapshot.docs.map((doc) => doc.data().toString()).toList()}");
      return snapshot.docs;
    });
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
            child: StreamBuilder<List<DocumentSnapshot<AddEntity>>>(
              stream: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading data"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Record Found"));
                }

                // Update the state with fetched data
                allData = snapshot.data!;
                filterData = snapshot.data!;

                return ListView.builder(
                  itemCount: filterData.length,
                  itemBuilder: (context, index) {
                    final addData = filterData[index].data();
                    if (addData == null) return Container();

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
                              backgroundImage: addData.image != null
                                  ? NetworkImage(addData.image!)
                                  : null,
                              child: addData.image == null
                                  ? const Icon(Icons.image)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DefaultText(
                                  text: addData.taskname ?? 'No Task Name',
                                  color: Colors.black,
                                ),
                                DefaultText(text: formattedDate)
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddData(
                                              updateAddEntity: addData,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    OutlinedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Delete Task"),
                                                content: Text(
                                                    "Are you sure you want to delete this task?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await FirebaseStorage
                                                          .instance
                                                          .ref("Task Images")
                                                          .child(addData.addId!)
                                                          .delete();
                                                      await AddEntity
                                                              .collection()
                                                          .doc(addData.addId)
                                                          .delete();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: DefaultText(
                                                      text: "Delete",
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ],
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
                                                )
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
