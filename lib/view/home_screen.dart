import 'package:ayurvedic_centre/view/regisetr_patient_screen.dart';
import 'package:ayurvedic_centre/view_models/home_viewmodel.dart';
import 'package:ayurvedic_centre/widgets/page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/responsive_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientVM = Provider.of<HomeViewModel>(context, listen: false);
      patientVM.loadPatients(refresh: true);

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent * 0.65 &&
            !patientVM.isLoading &&
            patientVM.hasMore) {
          patientVM.loadPatients();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientVM = Provider.of<HomeViewModel>(context);

    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(
         
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ResponsiveScaffold(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: patientVM.setSearch,
                        decoration: InputDecoration(
                          hintText: "Search by name or phone",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: patientVM.sortBy,
                      items: const [
                        DropdownMenuItem(value: "Name", child: Text("Name")),
                        DropdownMenuItem(value: "Date", child: Text("Date")),
                      ],
                      onChanged: (v) => patientVM.setSortBy(v ?? "Name"),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => patientVM.loadPatients(refresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount:
                        patientVM.patients.length +
                        (patientVM.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < patientVM.patients.length) {
                        final number=index+1;
                        final p = patientVM.patients[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (p.name == null || p.name!.isEmpty)
                                      ? "Unknown Patient"
                                      : "$number. ${p.name!}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text("Phone: ${p.phone ?? "-"}"),
                                Text("Address: ${p.address ?? "-"}"),
                                SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "Date: ${patientVM.formatDate(p.dateNdTime)}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              AppPageTransition.fade(const RegisterPatientScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Register Now"),
        ),
      ),
    );
  }
}
