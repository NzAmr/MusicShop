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
              _buildDetailRow(Icons.branding_watermark, 'Brand', order.product?.brand?.name ?? 'N/A'),
              _buildDetailRow(Icons.devices, 'Model', order.product?.model ?? 'N/A'),
              _buildDetailRow(Icons.attach_money, 'Price', '\$${order.product?.price?.toStringAsFixed(2) ?? 'N/A'}'),
              _buildDetailRow(Icons.person, 'Customer', '${order.shippingInfo?.customer?.firstName ?? 'N/A'} ${order.shippingInfo?.customer?.lastName ?? ''}'),
              _buildDetailRow(Icons.date_range, 'Order Date', order.orderDate?.toLocal().toString().split(" ")[0] ?? 'N/A'),
              _buildDetailRow(Icons.local_shipping, 'Shipping Status', order.shippingStatus ?? 'N/A'),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[400]),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: Offset(0, -6),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Color(0xFF1F1F1F),
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

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final customerName = '${order.shippingInfo?.customer?.firstName ?? 'N/A'} ${order.shippingInfo?.customer?.lastName ?? ''}';

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
                          _buildDetailRow(Icons.confirmation_number, 'Order Number', order.orderNumber ?? 'N/A'),
                          _buildDetailRow(Icons.person, 'Customer', customerName),
                          _buildDetailRow(Icons.branding_watermark, 'Brand', order.product?.brand?.name ?? 'N/A'),
                          _buildDetailRow(Icons.devices, 'Model', order.product?.model ?? 'N/A'),
                          _buildDetailRow(Icons.local_shipping, 'Status', order.shippingStatus ?? 'N/A'),
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
