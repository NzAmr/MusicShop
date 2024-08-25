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
      _ordersFuture = Provider.of<OrderProvider>(context, listen: false)
          .getCustomerOrders();
    });
  }

  Future<void> _showOrder(Order Order) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Order Details', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Order Number: ${Order.orderNumber ?? 'N/A'}',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text('Brand: ${Order.product?.brand?.name ?? 'N/A'}',
                  style: TextStyle(color: Colors.white)),
              Text('Model: ${Order.product?.model ?? 'N/A'}',
                  style: TextStyle(color: Colors.white)),
              Text(
                  'Price: \$${Order.product?.price?.toStringAsFixed(2) ?? 'N/A'}',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text(
                  'Customer: ${Order.shippingInfo?.customer?.firstName ?? 'N/A'} ${Order.shippingInfo?.customer?.lastName ?? 'N/A'}',
                  style: TextStyle(color: Colors.white)),
              Text(
                  'Order Date: ${Order.orderDate?.toLocal().toString() ?? 'N/A'}',
                  style: TextStyle(color: Colors.white)),
              Text('Shipping Status: ${Order.shippingStatus ?? 'N/A'}',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: Colors.white)),
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
              return Center(
                  child: Text('Error fetching orders',
                      style: TextStyle(color: Colors.white)));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No orders found',
                      style: TextStyle(color: Colors.white)));
            }

            final orders = snapshot.data!;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final customerName =
                    '${order.shippingInfo?.customer?.firstName ?? 'N/A'} ${order.shippingInfo?.customer?.lastName ?? 'N/A'}';
                final brand = order.product?.brand?.name ?? 'N/A';
                final model = order.product?.model ?? 'N/A';
                final shippingStatus = order.shippingStatus ?? 'N/A';

                return Card(
                  color: Colors.black,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text('Order Number: ${order.orderNumber ?? 'N/A'}',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer: $customerName',
                            style: TextStyle(color: Colors.white)),
                        Text('Brand: $brand',
                            style: TextStyle(color: Colors.white)),
                        Text('Model: $model',
                            style: TextStyle(color: Colors.white)),
                        Text('Status: $shippingStatus',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    onTap: () => _showOrder(order),
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
