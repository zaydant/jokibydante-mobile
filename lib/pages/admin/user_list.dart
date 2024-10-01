import 'package:flutter/material.dart';
import 'package:jokiapp/components/user_details.dart';
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

  final TextEditingController _searchController = TextEditingController();
  List<UserData> _filteredUsers = [];
  List<UserData> _allUsers = []; // Store all transactions here
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Using listen: false to avoid rebuilding the widget tree during initState
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _futureUsers = _userService.getUsers(userProvider.token ?? '');
  }

  void _filterWithdraws() {
    setState(() {
      _filteredUsers = _allUsers
          .where((user) =>
              user.uid.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.fullName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              user.username
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.phoneNumber
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              user.role.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _refreshUsers() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _futureUsers = _userService.getUsers(userProvider.token ?? '');
    });
  }

  void _showUserDetailsDialog(UserData user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserDetailsDialog(
          users: user,
          onFinishDelete: _refreshUsers,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context);

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
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _refreshUsers();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            _refreshUsers();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(131, 162, 255, 0.3)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color.fromRGBO(43, 52, 153, 1),
                    ),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                      _filterWithdraws(); // Filter as the user types
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
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
                      _allUsers = snapshot.data!;

                      List<UserData> users =
                          _filteredUsers.isEmpty ? _allUsers : _filteredUsers;

                      users.sort((a, b) {
                        return a.fullName
                            .toLowerCase()
                            .compareTo(b.fullName.toLowerCase());
                      });

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
                              onCheck: () => {
                                _showUserDetailsDialog(user),
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
