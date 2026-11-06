import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/app_color.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    int value = int.parse(newValue.text.replaceAll(RegExp(r'[^0-9]'), ''));
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    String newText = formatter.format(value).trim();
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final AuthService authService = AuthService();
  final FirestoreService firestoreService = FirestoreService();

  void _showTransactionDialog({String? docId, String? currentTitle, double? currentAmount, String? currentType}) {
    final titleController = TextEditingController(text: currentTitle);
    
    String initialAmount = '';
    if (currentAmount != null) {
      initialAmount = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(currentAmount).trim();
    }
    final amountController = TextEditingController(text: initialAmount);
    
    String type = currentType ?? 'Pemasukan';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColor.bgWhite,
              title: Text(docId == null ? "Tambah Transaksi" : "Edit Transaksi", style: const TextStyle(color: AppColor.textPrimary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Judul Transaksi"),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                    decoration: const InputDecoration(labelText: "Nominal (Rp)"),
                  ),
                  DropdownButton<String>(
                    value: type,
                    isExpanded: true,
                    items: ['Pemasukan', 'Pengeluaran'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        type = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                if (docId != null)
                  TextButton(
                    onPressed: () {
                      firestoreService.deleteTransaction(docId);
                      Navigator.pop(context);
                    },
                    child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal", style: TextStyle(color: AppColor.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text;
                    final rawAmount = amountController.text.replaceAll('.', '');
                    final amount = double.tryParse(rawAmount) ?? 0;
                    
                    if (title.isNotEmpty && amount > 0) {
                      if (docId == null) {
                        firestoreService.addTransaction(title, amount, type);
                      } else {
                        firestoreService.updateTransaction(docId, title, amount, type);
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
                  child: const Text("Simpan", style: TextStyle(color: AppColor.textLight)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.bgWhite,
        title: const Text("Logout", style: TextStyle(color: AppColor.textPrimary)),
        content: const Text("Apakah Anda yakin ingin keluar?", style: TextStyle(color: AppColor.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: AppColor.textSecondary))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authService.signOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Keluar", style: TextStyle(color: AppColor.textLight)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userName = user?.displayName ?? user?.email?.split('@')[0] ?? "User";

    return Scaffold(
      backgroundColor: AppColor.bgWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Wpay",
                      style: TextStyle(color: AppColor.textLight, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColor.socialButtonBg, borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: const Icon(Icons.settings_outlined, color: AppColor.textPrimary),
                      onPressed: _showLogoutDialog,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello $userName,", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
                      const SizedBox(height: 4),
                      const Text("Your available balance", style: TextStyle(fontSize: 13, color: AppColor.textSecondary)),
                    ],
                  ),
                  const Text("Rp 2.000.000", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 70,
                decoration: BoxDecoration(color: AppColor.secondary, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.swap_horiz, color: AppColor.textLight, size: 28),
                            SizedBox(width: 8),
                            Text("Transfer", style: TextStyle(color: AppColor.textLight, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1, height: 40, color: AppColor.textFaded),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.credit_card, color: AppColor.textLight, size: 26),
                            SizedBox(width: 8),
                            Text("Top Up", style: TextStyle(color: AppColor.textLight, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text("New Transaction History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
              const SizedBox(height: 15),
              StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Text("Belum ada transaksi.", style: TextStyle(color: AppColor.textSecondary));

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      bool isIncome = data['type'] == 'Pemasukan';
                      
                      String formattedAmount = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(data['amount']);

                      return InkWell(
                        onLongPress: () => _showTransactionDialog(
                          docId: doc.id,
                          currentTitle: data['title'],
                          currentAmount: data['amount'],
                          currentType: data['type'],
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: AppColor.cardDark, borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['title'], style: const TextStyle(color: AppColor.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(isIncome ? "Pemasukan" : "Pengeluaran", style: const TextStyle(color: AppColor.textFaded, fontSize: 12)),
                                ],
                              ),
                              Text(
                                "${isIncome ? '+' : '-'} $formattedAmount",
                                style: TextStyle(color: isIncome ? AppColor.secondary : AppColor.textLight, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTransactionDialog(),
        backgroundColor: AppColor.accent,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: AppColor.textLight, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppColor.bgWhite,
        surfaceTintColor: AppColor.bgWhite,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.home, color: AppColor.cardDark, size: 28), onPressed: () {}),
              IconButton(icon: const Icon(Icons.receipt_long_outlined, color: AppColor.textSecondary, size: 26), onPressed: () => Navigator.pushReplacementNamed(context, '/statistic')),
              const SizedBox(width: 40),
              IconButton(icon: const Icon(Icons.notifications_none, color: AppColor.textSecondary, size: 26), onPressed: () {}),
              IconButton(icon: const Icon(Icons.person_outline, color: AppColor.textSecondary, size: 26), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}