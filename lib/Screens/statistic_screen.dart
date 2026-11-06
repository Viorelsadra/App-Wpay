import 'package:flutter/material.dart';
import '../utils/app_color.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgWhite,
      appBar: AppBar(
        backgroundColor: AppColor.bgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Statistic",
          style: TextStyle(color: AppColor.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColor.textPrimary),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
                    ),
                    child: const Column(
                      children: [
                        Text("Income", style: TextStyle(color: AppColor.textFaded, fontSize: 12)),
                        SizedBox(height: 5),
                        Text("\$5,440", style: TextStyle(color: AppColor.textLight, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColor.secondary,
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
                    ),
                    child: const Column(
                      children: [
                        Text("Expense", style: TextStyle(color: AppColor.textFaded, fontSize: 12)),
                        SizedBox(height: 5),
                        Text("\$2,209", style: TextStyle(color: AppColor.textLight, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Statistic Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColor.socialButtonBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text("Weekly", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
                      Icon(Icons.keyboard_arrow_down, size: 16, color: AppColor.textPrimary),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 8,
                        height: 35.0 + (index * 10 % 30),
                        decoration: BoxDecoration(
                          color: AppColor.accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 8,
                        height: 25.0 + (index * 15 % 40),
                        decoration: BoxDecoration(
                          color: AppColor.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Category Chart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
                const Text("-\$312.00", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
              ],
            ),
            const SizedBox(height: 5),
            const Text("Last 7 days expenses", style: TextStyle(color: AppColor.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.primary, width: 15),
                ),
                child: const Center(
                  child: Icon(Icons.local_cafe, size: 40, color: AppColor.primary),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text("Recent Expenses", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
            const SizedBox(height: 15),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColor.primary),
                child: const Icon(Icons.local_cafe, color: AppColor.textLight),
              ),
              title: const Text("Starbucks Coffee", style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.textPrimary)),
              subtitle: const Text("Dec 2, 2020 • 3:09 PM", style: TextStyle(fontSize: 12, color: AppColor.textSecondary)),
              trailing: const Text("-\$156.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.textPrimary)),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColor.accent,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.qr_code_scanner, color: AppColor.textLight, size: 28),
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
              IconButton(
                icon: const Icon(Icons.home_outlined, color: AppColor.textSecondary, size: 28),
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              ),
              IconButton(
                icon: const Icon(Icons.receipt_long, color: AppColor.cardDark, size: 26),
                onPressed: () {},
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColor.textSecondary, size: 26),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: AppColor.textSecondary, size: 26),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}