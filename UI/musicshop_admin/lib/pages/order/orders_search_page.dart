import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/order/order.dart';
import 'package:musicshop_admin/models/order/order_shipping_update_request.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/providers/order_provider/order_provider.dart';

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
      _ordersFuture = Provider.of<OrderProvider>(context, listen: false).get();
    });
  }

  Future<void> _showOrder(Order order) async {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRowWithIcon(Icons.confirmation_number_outlined, 'Order Number', order.orderNumber ?? 'N/A'),
            _buildDetailRowWithIcon(Icons.branding_watermark_outlined, 'Brand', order.product?.brand?.name ?? 'N/A'),
            _buildDetailRowWithIcon(Icons.model_training_outlined, 'Model', order.product?.model ?? 'N/A'),
            _buildDetailRowWithIcon(
              Icons.attach_money,
              'Price',
              '\$${order.product?.price?.toStringAsFixed(2) ?? 'N/A'}',
            ),
            SizedBox(height: 20),
            _buildDetailRowWithIcon(
              Icons.person,
              'Customer',
              '${order.shippingInfo?.customer?.firstName ?? 'N/A'} ${order.shippingInfo?.customer?.lastName ?? 'N/A'}',
            ),
            _buildDetailRowWithIcon(
              Icons.calendar_today_outlined,
              'Order Date',
              order.orderDate != null
                  ? order.orderDate!.toLocal().toString().split(' ')[0]
                  : 'N/A',
            ),
            _buildDetailRowWithIcon(
              Icons.local_shipping_outlined,
              'Shipping Status',
              order.shippingStatus ?? 'N/A',
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8 ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, -6),
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 4),
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

  Widget _buildDetailRowWithIcon(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: Offset(0, -6),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
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


  Future<void> _updateOrderStatus(int orderId) async {
    String? selectedStatus;
    final statusOptions = ['Pending', 'Shipped', 'Delivered', 'Cancelled'];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Update Shipping Status', style: TextStyle(color: Colors.white)),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButtonFormField<String>(
              dropdownColor: Colors.grey[850],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              value: selectedStatus,
              hint: Text('Select status', style: TextStyle(color: Colors.white70)),
              iconEnabledColor: Colors.yellow[700],
              items: statusOptions
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status, style: TextStyle(color: Colors.white)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              foregroundColor: Colors.black,
            ),
            onPressed: selectedStatus == null
                ? null
                : () {
                    final updateRequest =
                        OrderShippingUpdateRequest(shippingStatus: selectedStatus!);
                    Provider.of<OrderProvider>(context, listen: false)
                        .update(orderId, updateRequest)
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order status updated successfully!'),
                          backgroundColor: Colors.green[700],
                        ),
                      );
                      Navigator.of(context).pop();
                      _fetchOrders();
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update order status.'),
                          backgroundColor: Colors.red[700],
                        ),
                      );
                      Navigator.of(context).pop();
                    });
                  },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkBg = Colors.grey[900];
    final cardBg = Colors.grey[850];
    final borderColor = Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: darkBg,
        elevation: 0,
      ),
      backgroundColor: darkBg,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.yellow[700]));
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching orders', style: TextStyle(color: Colors.white70)),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No orders found', style: TextStyle(color: Colors.white70)),
              );
            }

            final orders = snapshot.data!;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 3 / 4,
              ),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final customerName =
                    '${order.shippingInfo?.customer?.firstName ?? 'N/A'} ${order.shippingInfo?.customer?.lastName ?? 'N/A'}';
                final brand = order.product?.brand?.name ?? 'N/A';
                final model = order.product?.model ?? 'N/A';
                final shippingStatus = order.shippingStatus ?? 'N/A';

                return GestureDetector(
  onTap: () => _showOrder(order),
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: borderColor!, width: 1.5),
      borderRadius: BorderRadius.circular(12.0),
      color: cardBg,
    ),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDetailRowWithIcon(
          Icons.confirmation_number_outlined,
          'Order Number',
          order.orderNumber ?? 'N/A',
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.person, color: Colors.white70, size: 20),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                customerName,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        _buildDetailRowWithIcon(
          Icons.branding_watermark_outlined,
          'Brand',
          brand,
        ),
        _buildDetailRowWithIcon(
          Icons.model_training_outlined,
          'Model',
          model,
        ),
        _buildDetailRowWithIcon(
          Icons.info_outline,
          'Status',
          shippingStatus,
        ),
        SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _updateOrderStatus(order.id!),
          child: Text('Update Status'),
        ),
      ],
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
