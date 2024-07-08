import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/Widgets.dart';
import 'package:flutter_application_1/Models/add_data_entity.dart';

class CompletedScreenTask extends StatefulWidget {
  const CompletedScreenTask({super.key});

  @override
  State<CompletedScreenTask> createState() => _CompletedScreenTaskState();
}

class _CompletedScreenTaskState extends State<CompletedScreenTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: AddEntity.collection()
            .where('isCompleted', isEqualTo: true)
            .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.toString()),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Task are not Completed yet"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              AddEntity addData = snapshot.data!.docs[index].data();
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
                        backgroundImage: NetworkImage(addData.image!),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      DefaultText(
                        text: addData.taskname!,
                        color: Colors.black,
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  AddEntity.collection()
                                      .doc(addData.addId)
                                      .delete();
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          addData.isCompleted == true
                              ? const Text("Completed")
                              : const Text("Pending")
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
