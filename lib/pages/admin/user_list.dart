import 'package:flutter/material.dart';
import 'package:jokiapp/components/transaction_row.dart';
import 'package:jokiapp/components/user_row.dart';
import 'package:jokiapp/models/user_model.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/services/user_services.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<UserData>> _futureUsers;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    // Using listen: false to avoid rebuilding the widget tree during initState
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _futureUsers = _userService.getUsers(userProvider.token ?? '');
  }

  void _refreshUsers() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _futureUsers = _userService.getUsers(userProvider.token ?? '');
    });
  }

  // Future<void> _updateUsers(String token, String uid, String jokiStatus) async {
  //   try {
  //     await _transactionService.updateTransaction(token, transactionId, jokiStatus, "update");
  //     scaffoldMessengerKey.currentState?.showSnackBar(
  //       const SnackBar(content: Text('Job taken successfully')),
  //     );
  //     _refreshTransactions();
  //   } catch (e) {
  //     scaffoldMessengerKey.currentState?.showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                'Joki By Dante',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'josefinSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'User List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        _refreshUsers();
                      },
                    ),
                  ],
                ),
              ),
              // Expanded widget is added here to allow the ListView to take available space
              Expanded(
                child: FutureBuilder<List<UserData>>(
                  future: _futureUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No users found.'));
                    } else {
                      List<UserData> users = snapshot.data!;

                      if (users.isEmpty) {
                        return const Center(child: Text('No users found.'));
                      }

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: UserRow(
                              user: user,
                              onCheck: () {
                                final token = Provider.of<UserProvider>(
                                      context,
                                      listen: false,
                                    ).token ??
                                    '';
                                print('EDIT User');
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
