import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_mobile/models/order/order.dart';
import 'package:musicshop_mobile/providers/order_provider/order_provider.dart';

class OrdersSearchPage extends StatefulWidget {
  @override
  _OrdersSearchPageState createState() => _OrdersSearchPageState();
}

class _OrdersSearchPageState extends State<OrdersSearchPage> {
  Future<List<Order>>? _ordersFuture;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() {
    setState(() {
      _ordersFuture = Provider.of<OrderProvider>(context, listen: false).getCustomerOrders();
    });
  }

  Future<void> _showOrder(Order order) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFF121212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF121212),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 16),
              _buildDetailRow(Icons.confirmation_number, 'Order Number', order.orderNumber ?? 'N/A'),
              _buildDetailRow(Icons.date_range, 'Order Date', order.orderDate?.toLocal().toString().split(" ")[0] ?? 'N/A'),
              _buildDetailRow(Icons.branding_watermark, 'Brand', order.product?.brand?.name ?? 'N/A'),
              _buildDetailRow(Icons.devices, 'Model', order.product?.model ?? 'N/A'),
              _buildDetailRow(Icons.attach_money, 'Price', '\$${order.product?.price?.toStringAsFixed(2) ?? 'N/A'}'),
              _buildDetailRow(Icons.local_shipping, 'Status', order.shippingStatus ?? 'Unknown', valueColor: _statusColor(order.shippingStatus), isStatus: true),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Close', style: TextStyle(color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor, bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.grey[400]),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
          ),
          isStatus
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: valueColor ?? Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: valueColor ?? Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Color(0xFF272323),
        surfaceTintColor: Color(0xFF272323),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.amber[700]));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error fetching orders', style: TextStyle(color: Colors.redAccent)));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found', style: TextStyle(color: Colors.grey[400])));
            }

            final orders = snapshot.data!;
            orders.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  color: Color(0xFF1F1F1F),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () => _showOrder(order),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.devices, 'Model', order.product?.model ?? 'N/A'),
                          _buildDetailRow(Icons.branding_watermark, 'Brand', order.product?.brand?.name ?? 'N/A'),
                          _buildDetailRow(Icons.date_range, 'Order Date', order.orderDate?.toLocal().toString().split(" ")[0] ?? 'N/A'),
                          _buildDetailRow(
                            Icons.local_shipping,
                            'Status',
                            order.shippingStatus ?? 'Unknown',
                            valueColor: _statusColor(order.shippingStatus),
                            isStatus: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
