import 'package:flutter/material.dart';
import 'package:jokiapp/components/req_details.dart';
import 'package:jokiapp/components/request_row.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:jokiapp/models/withdraw_model.dart';
import 'package:jokiapp/services/withdraw_services.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class WithdrawRequestList extends StatefulWidget {
  const WithdrawRequestList({super.key});

  @override
  State<WithdrawRequestList> createState() => _WithdrawRequestListState();
}

class _WithdrawRequestListState extends State<WithdrawRequestList> {
  late Future<List<WithdrawModel>> _futureWithdraws;
  final WithdrawService _withdrawService = WithdrawService();

   // Search Controller
  final TextEditingController _searchController = TextEditingController();
  List<WithdrawModel> _filteredWithdraws = [];
  List<WithdrawModel> _allWithdraws = []; // Store all transactions here
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Using listen: false to avoid rebuilding the widget tree during initState
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _futureWithdraws = _withdrawService.getWithdraws(userProvider.token!);
  }

  void refreshWithdraws() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _futureWithdraws = _withdrawService.getWithdraws(userProvider.token!);
    });
  }

  // Function to filter transactions based on the search query
  void _filterWithdraws() {
    setState(() {
      _filteredWithdraws = _allWithdraws
          .where((withdraw) =>
              withdraw.withdrawId
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              withdraw.uid.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              withdraw.withdrawMethod.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              withdraw.accountNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              withdraw.status.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              withdraw.accountName.toLowerCase().contains(_searchQuery.toLowerCase())
              )
          .toList();
    });
  }

  void _showRequestDetailsDialog(WithdrawModel withdraw) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReqDetailsDialog(
          withdraws: withdraw,
          onFinishTransaction: refreshWithdraws,
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
                      'Withdraw Requests',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        refreshWithdraws();
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
                      borderSide: const BorderSide(color: Color.fromRGBO(131, 162, 255, 0.3)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: const Color.fromRGBO(43, 52, 153, 1),),
                    border: OutlineInputBorder(),
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
              const SizedBox(height: 10,),
              // Expanded widget is added here to allow the ListView to take available space
              Expanded(
                child: FutureBuilder<List<WithdrawModel>>(
                  future: _futureWithdraws,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No users found.'));
                    } else {
                      _allWithdraws = snapshot.data!;

                      List<WithdrawModel> withdraws = _filteredWithdraws.isEmpty
                          ? _allWithdraws
                          : _filteredWithdraws;

                      withdraws.sort((a, b) {
                        if (a.status == 'pending' &&
                            b.status == 'accepted') return -1;
                        if (a.status == 'accepted' &&
                            b.status == 'pending') return 1;

                        // if (a.jokiStatus == 'actionNeeded' &&
                        //     b.jokiStatus != 'actionNeeded') return -1;
                        // if (a.jokiStatus != 'actionNeeded' &&
                        //     b.jokiStatus == 'actionNeeded') return 1;

                        // if (a.jokiStatus == 'onProgress' &&
                        //     b.jokiStatus != 'onProgress') return -1;
                        // if (a.jokiStatus != 'onProgress' &&
                        //     b.jokiStatus == 'onProgress') return 1;

                        return b.createdAt.compareTo(a.createdAt);
                      });

                      if (withdraws.isEmpty) {
                        return const Center(
                            child:
                                Text('No withdraw requests found.'));
                      }

                      return ListView.builder(
                        itemCount: withdraws.length,
                        itemBuilder: (context, index) {
                          final request = withdraws[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: ReqRow(
                              withdrawData: request,
                              onCheck: () => {
                                _showRequestDetailsDialog(request),
                                print(request.withdrawId)},
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
