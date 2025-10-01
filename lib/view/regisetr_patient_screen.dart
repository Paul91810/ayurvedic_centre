import 'package:ayurvedic_centre/view/receiptscreen.dart';
import 'package:ayurvedic_centre/view_models/register_patient_viewmoidel.dart';
import 'package:ayurvedic_centre/widgets/custom_text_field.dart';
import 'package:ayurvedic_centre/widgets/page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';

import 'package:ayurvedic_centre/data/models/branch_list.dart' as branch_model;
import 'package:ayurvedic_centre/data/models/treatment_list.dart'
    as treatment_model;

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final execCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final totalCtrl = TextEditingController();
  final discountCtrl = TextEditingController();
  final advanceCtrl = TextEditingController();
  final balanceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<RegisterPatientViewModel>(context, listen: false);
      vm.fetchBranches();
      vm.fetchTreatments();
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    execCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    totalCtrl.dispose();
    discountCtrl.dispose();
    advanceCtrl.dispose();
    balanceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterPatientViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Register Patient",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: nameCtrl,
                label: "Name",
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter name" : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: execCtrl,
                label: "Executive",
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter executive" : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: phoneCtrl,
                label: "Phone",
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter phone" : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: addressCtrl,
                label: "Address",
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter address" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: vm.selectedLocation,
                isExpanded: true,
                items: vm.locations.map<DropdownMenuItem<String>>((loc) {
                  return DropdownMenuItem<String>(value: loc, child: Text(loc));
                }).toList(),
                onChanged: (v) => vm.setLocation(v),
                decoration: const InputDecoration(labelText: "Location"),
              ),
              const SizedBox(height: 12),
              vm.isLoadingBranches
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      value: vm.selectedBranchId,
                      isExpanded: true,
                      items: vm.branches.map<DropdownMenuItem<String>>((
                        branch_model.Branches b,
                      ) {
                        return DropdownMenuItem<String>(
                          value: b.id?.toString(),
                          child: Text(b.name ?? "-"),
                        );
                      }).toList(),
                      onChanged: vm.setBranch,
                      decoration: const InputDecoration(labelText: "Branch"),
                    ),
              const SizedBox(height: 16),
              const Text(
                "Payment Option",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ["Cash", "Card", "UPI"].map((opt) {
                  final selected = vm.paymentMode == opt;
                  return ChoiceChip(
                    label: Text(opt),
                    selected: selected,
                    onSelected: (_) => vm.setPayment(opt),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                "Treatment Date & Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: vm.selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) vm.setDate(picked);
                      },
                      child: Text(
                        vm.selectedDate == null
                            ? "Pick Date"
                            : DateFormat("dd/MM/yyyy").format(vm.selectedDate!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: vm.selectedTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) vm.setTime(picked);
                      },
                      child: Text(
                        vm.selectedTime == null
                            ? "Pick Time"
                            : vm.selectedTime!.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Treatments",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _showTreatmentDialog(context, vm),
                    icon: const Icon(Icons.add),
                    label: const Text("Add Treatments"),
                  ),
                ],
              ),
              Column(
                children: vm.selectedTreatments.map((t) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(t.name),
                      subtitle: Text("Male: ${t.male}    Female: ${t.female}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => vm.removeTreatment(t.id),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: totalCtrl,
                label: "Total Amount",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter total" : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: discountCtrl,
                label: "Discount Amount",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter discount" : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: advanceCtrl,
                label: "Advance Amount",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter advance" : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: balanceCtrl,
                label: "Balance Amount",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter balance" : null,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Save",
                loading: vm.isLoading,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (vm.selectedBranchId == null ||
                      vm.selectedBranchId!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a branch")),
                    );
                    return;
                  }

                  if (vm.paymentMode == null || vm.paymentMode!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a payment option"),
                      ),
                    );
                    return;
                  }

                  if (vm.selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please pick a treatment date"),
                      ),
                    );
                    return;
                  }

                  if (vm.selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please pick a treatment time"),
                      ),
                    );
                    return;
                  }

                  if (vm.selectedTreatments.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please add at least one treatment"),
                      ),
                    );
                    return;
                  }

                  final success = await vm.savePatient(
                    context: context,
                    name: nameCtrl.text.trim(),
                    executive: execCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    address: addressCtrl.text.trim(),
                    totalAmount: double.tryParse(totalCtrl.text) ?? 0,
                    discountAmount: double.tryParse(discountCtrl.text) ?? 0,
                    advanceAmount: double.tryParse(advanceCtrl.text) ?? 0,
                    balanceAmount: double.tryParse(balanceCtrl.text) ?? 0,
                  );

                  if (success) {
                    Navigator.push(
                      context,
                      AppPageTransition.slideUp(
                        ReceiptScreen(
                          name: nameCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          address: addressCtrl.text.trim(),
                          branch: vm.branches
                                  .firstWhere(
                                    (b) =>
                                        b.id?.toString() == vm.selectedBranchId,
                                    orElse: () =>
                                        branch_model.Branches(name: "-"),
                                  )
                                  .name ??
                              "-",
                          payment: vm.paymentMode ?? "",
                          dateTime:
                              "${DateFormat("dd/MM/yyyy").format(vm.selectedDate!)} - ${vm.selectedTime!.format(context)}",
                          treatments: vm.selectedTreatments
                              .map(
                                (t) => {
                                  "name": t.name,
                                  "male": t.male,
                                  "female": t.female,
                                  "price":
                                      0, // TODO: replace with actual price if available
                                },
                              )
                              .toList(),
                          total: double.tryParse(totalCtrl.text) ?? 0,
                          discount: double.tryParse(discountCtrl.text) ?? 0,
                          advance: double.tryParse(advanceCtrl.text) ?? 0,
                          balance: double.tryParse(balanceCtrl.text) ?? 0,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showTreatmentDialog(BuildContext context, RegisterPatientViewModel vm) {
    int? selectedTreatmentId;
    int maleCount = 0;
    int femaleCount = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text("Choose Treatment"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                vm.isLoadingTreatments
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : DropdownButtonFormField<int>(
                        value: selectedTreatmentId,
                        isExpanded: true,
                        items: vm.treatments.map<DropdownMenuItem<int>>((
                          treatment_model.Treatments t,
                        ) {
                          return DropdownMenuItem<int>(
                            value: t.id,
                            child: Text(
                              "${t.name}${t.price != null ? " (₹${t.price})" : ""}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: "Select Treatment",
                        ),
                        onChanged: (v) =>
                            setState(() => selectedTreatmentId = v),
                      ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Male"),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => setState(
                            () => maleCount = maleCount > 0 ? maleCount - 1 : 0,
                          ),
                        ),
                        Text("$maleCount"),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => maleCount++),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Female"),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => setState(
                            () => femaleCount =
                                femaleCount > 0 ? femaleCount - 1 : 0,
                          ),
                        ),
                        Text("$femaleCount"),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => femaleCount++),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedTreatmentId != null) {
                    final t = vm.treatments.firstWhere(
                      (el) => el.id == selectedTreatmentId,
                    );
                    vm.addTreatment(
                      t.id!,
                      t.name ?? "Unknown",
                      maleCount,
                      femaleCount,
                    );
                  }
                  Navigator.pop(ctx);
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      ),
    );
  }
}
