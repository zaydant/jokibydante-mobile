import 'package:flutter/material.dart';
import 'package:jokiapp/components/support_details.dart';
import 'package:jokiapp/components/support_row.dart';
import 'package:jokiapp/models/support_model.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/services/support_services.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class SupportList extends StatefulWidget {
  const SupportList({super.key});

  @override
  State<SupportList> createState() => _SupportListState();
}

class _SupportListState extends State<SupportList> {
  late Future<List<SupportData>> _futureSupports;
  final SupportService _supportService = SupportService();

  final TextEditingController _searchController = TextEditingController();
  List<SupportData> _filteredSupports = [];
  List<SupportData> _allSupports = []; // Store all transactions here
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Using listen: false to avoid rebuilding the widget tree during initState
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _futureSupports = _supportService.getSupports(userProvider.token!);
  }

  void _filterSupports() {
    setState(() {
      _filteredSupports = _allSupports
          .where((support) =>
              support.supportId
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              support.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              support.transactionId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              support.issue
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              support.email
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              support.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              support.phoneNumber
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _refreshSupports() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _futureSupports = _supportService.getSupports(userProvider.token!);
    });
  }

  void _showSupportDetailsDialog(SupportData support) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SupportDetailsDialog(
          supports: support,
          onFinishDelete: _refreshSupports,
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
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        _refreshSupports();
                      },
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
                      _filterSupports(); // Filter as the user types
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<SupportData>>(
                  future: _futureSupports,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No users found.'));
                    } else {
                      _allSupports = snapshot.data!;

                      List<SupportData> supports = _filteredSupports.isEmpty
                          ? _allSupports
                          : _filteredSupports;

                      supports.sort((a, b) {
                        return b.createdAt.compareTo(a.createdAt);
                      });

                      if (supports.isEmpty) {
                        return const Center(
                            child: Text('No support requests found.'));
                      }

                      return ListView.builder(
                        itemCount: supports.length,
                        itemBuilder: (context, index) {
                          final support = supports[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: SupportRow(
                              supportData: support,
                              onCheck: () => {
                                _showSupportDetailsDialog(support),
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
