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

  Future<void> _showOrder(Order Order) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order Details',
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              Text('Order Number: ${Order.orderNumber ?? 'N/A'}',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 16),
              Text('Brand: ${Order.product?.brand?.name ?? 'N/A'}'),
              Text('Model: ${Order.product?.model ?? 'N/A'}'),
              Text(
                  'Price: \$${Order.product?.price?.toStringAsFixed(2) ?? 'N/A'}'),
              SizedBox(height: 16),
              Text(
                  'Customer: ${Order.shippingInfo?.customer?.firstName ?? 'N/A'} ${Order.shippingInfo?.customer?.lastName ?? 'N/A'}'),
              Text(
                  'Order Date: ${Order.orderDate?.toLocal().toString() ?? 'N/A'}'),
              Text('Shipping Status: ${Order.shippingStatus ?? 'N/A'}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateOrderStatus(int orderId) async {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Shipping Status'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Enter new Status'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStatus = textController.text.trim();
              if (newStatus.isNotEmpty) {
                final updateRequest =
                    OrderShippingUpdateRequest(shippingStatus: newStatus);
                Provider.of<OrderProvider>(context, listen: false)
                    .update(orderId, updateRequest)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Order status updated successfully!')),
                  );
                  Navigator.of(context).pop();
                  _fetchOrders();
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update order status.')),
                  );
                  Navigator.of(context).pop();
                });
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error fetching orders'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found'));
            }

            final orders = snapshot.data!;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3 / 2,
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
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Order Number: ${order.orderNumber ?? 'N/A'}',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 8),
                            Text(
                              customerName,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Brand: $brand',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Model: $model',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Status: $shippingStatus',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _updateOrderStatus(order.id!),
                              child: Text('Update Status'),
                            ),
                          ],
                        ),
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
