import 'dart:io';
import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/order/order.dart';
import 'package:musicshop_admin/providers/order_provider/order_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Order> _orders = [];
  Map<String, double> _revenuePerBrand = {};

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      var orderProvider = context.read<OrderProvider>();
      var orders = await orderProvider.get();
      setState(() {
        _orders = orders;
        _computeRevenuePerBrand();
      });
    } catch (e) {
      print(e);
    }
  }

  void _computeRevenuePerBrand() {
    final revenueMap = <String, double>{};

    for (var order in _orders) {
      if (order.product != null &&
          order.product!.brand != null &&
          order.product!.price != null) {
        final brandName = order.product!.brand!.name ?? 'Unknown';
        final revenue = order.product!.price!;

        if (revenueMap.containsKey(brandName)) {
          revenueMap[brandName] = revenueMap[brandName]! + revenue;
        } else {
          revenueMap[brandName] = revenue;
        }
      }
    }

    setState(() {
      _revenuePerBrand = revenueMap;
    });
  }

  Future<void> _generateAndDownloadPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Revenue Report', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Revenue per Brand:'),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Brand', 'Revenue'],
                data: _revenuePerBrand.entries.map((entry) {
                  return [entry.key, entry.value.toStringAsFixed(2)];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = "${directory.path}/revenue_report_$timestamp.pdf";
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $path')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue per brand'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: _buildChart(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateAndDownloadPdf,
              child: Text('Download PDF Report'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final chartData = _revenuePerBrand.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n${entry.value.toStringAsFixed(2)}',
        color: _getColorForBrand(entry.key),
        radius: 100,
        titleStyle: TextStyle(fontSize: 16, color: Colors.white),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: chartData,
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 50,
        sectionsSpace: 0,
        startDegreeOffset: 90,
      ),
    );
  }

  Color _getColorForBrand(String brand) {
    return Colors.primaries[_revenuePerBrand.keys.toList().indexOf(brand) %
        Colors.primaries.length];
  }
}

class ChartData {
  final String brand;
  final double revenue;

  ChartData(this.brand, this.revenue);
}
