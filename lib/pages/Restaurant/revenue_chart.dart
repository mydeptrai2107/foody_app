import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenueChartScreen extends StatefulWidget {
  const RevenueChartScreen({super.key});

  @override
  State<RevenueChartScreen> createState() => _RevenueChartScreenState();
}

class _RevenueChartScreenState extends State<RevenueChartScreen> {
  List<QueryDocumentSnapshot> orders = [];
  bool isLoading = true;
  String selectedFilter = 'Ngày'; // 'Ngày', 'Tháng', 'Quý'
  Map<String, double> revenueData = {};

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  Future<void> getOrders() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Orders')
        .where('status', whereIn: ['Đã giao', 'Hủy']).get();

    setState(() {
      orders = querySnapshot.docs;
    });

    processRevenueData();
  }

  DateTime? parseCustomDate(String dateStr) {
    try {
      String cleaned = dateStr
          .replaceAll('at ', '')
          .replaceAll(RegExp(r' '), ' ')
          .replaceAll(RegExp(r' UTC[+-]\d+'), '')
          .trim();

      // Parse
      final format = DateFormat("MMMM d, yyyy h:mm:ss a");
      return format.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  void processRevenueData() {
    Map<String, double> tempRevenue = {};

    for (var order in orders) {
      final data = order.data() as Map<String, dynamic>;
      final orderItems = data['orderItems'] as List<dynamic>;

      double total = 0.0;

      for (var item in orderItems) {
        int quantity = item['quantity'];
        double price = item['basePrice'] * 1.0;
        total += quantity * price;
      }

      final Timestamp dateStr = data['createAt'];
      final createdAt = dateStr.toDate();

      String key;
      if (selectedFilter == 'Ngày') {
        key = DateFormat('dd/MM').format(createdAt);
      } else if (selectedFilter == 'Tháng') {
        key = DateFormat('MM/yyyy').format(createdAt);
      } else {
        int quarter = ((createdAt.month - 1) ~/ 3) + 1;
        key = 'Q$quarter/${createdAt.year}';
      }

      tempRevenue[key] = (tempRevenue[key] ?? 0) + total;
    }

    setState(() {
      revenueData = tempRevenue;
      isLoading = false;
    });
  }

  List<BarChartGroupData> buildChartData() {
    int index = 0;
    return revenueData.entries.map((entry) {
      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: entry.value / 1000, // chia để gọn trục Y
            color: Colors.orange,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  List<String> getLabels() => revenueData.keys.toList();

  @override
  Widget build(BuildContext context) {
    final labels = getLabels();

    return Scaffold(
      appBar: AppBar(title: Text('Biểu đồ doanh thu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: selectedFilter,
                    items: ['Ngày', 'Tháng', 'Quý'].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text('Theo $value'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedFilter = value;
                          isLoading = true;
                        });
                        processRevenueData();
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                return Text(
                                  index < labels.length ? labels[index] : '',
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 50,
                              showTitles: true,
                              getTitlesWidget: (value, _) =>
                                  Text('${value.toInt()}K'),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: true),
                        barGroups: buildChartData(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
