import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loqma/provider/offer%20providers/cart_provider.dart';
import 'package:loqma/provider/update_user_provider.dart';
import 'package:loqma/models/order_model.dart';

class AvailableOrdersScreen extends StatelessWidget {
  final String currentVolunteerId;

  const AvailableOrdersScreen({Key? key, required this.currentVolunteerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final availableOrders = cartProvider.getAvailableOrdersForVolunteers();

    final currentUser = context.read<UpdateUserProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Deliveries'),
        centerTitle: true,
      ),
      body: availableOrders.isEmpty
          ? const Center(
              child: Text(
                'No orders available for delivery right now.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: availableOrders.length,
              itemBuilder: (context, index) {
                final order = availableOrders[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text('Order #${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Items: ${order.orderedItems.length} | Total: ${order.totalPrice.toStringAsFixed(2)} JOD'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        cartProvider.acceptOrder(
                          order: order,
                          volunteerId: currentVolunteerId,
                          volunteerName: currentUser?.fullName ?? "Volunteer",
                          volunteerPhone: currentUser?.phone ?? "N/A",
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('You accepted order #${order.orderId}!')),
                        );
                      },
                      child: const Text('Accept', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
            ),
            
    );
  }
}
