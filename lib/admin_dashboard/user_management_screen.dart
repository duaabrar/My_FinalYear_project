import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  Future<void> deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).delete();
  }

  Future<void> updateUserStatus(String userId, bool isBlocked) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"isBlocked": isBlocked});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              final userData = user.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(userData['name'] ?? "No Name"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${userData['email'] ?? 'N/A'}"),
                      Text("Phone: ${userData['phone'] ?? 'N/A'}"),
                      Text("Status: ${userData['isBlocked'] == true ? 'Blocked' : 'Active'}"),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "delete") {
                        deleteUser(user.id);
                      } else if (value == "block") {
                        updateUserStatus(user.id, true);
                      } else if (value == "unblock") {
                        updateUserStatus(user.id, false);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "block",
                        child: Text("Block User"),
                      ),
                      const PopupMenuItem(
                        value: "unblock",
                        child: Text("Unblock User"),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text(
                          "Delete User",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
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
