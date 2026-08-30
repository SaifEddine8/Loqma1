import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loqma/provider/update_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/models/order_model.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/provider/offer%20providers/cart_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.order.orderId} Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(currentStatus).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _getStatusColor(currentStatus)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _getStatusColor(currentStatus)),
                  const SizedBox(width: 10),
                  Text(
                    'Status: ${_getFormattedStatus(currentStatus)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _getStatusColor(currentStatus),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Pickup Location (Restaurant / Donor):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: widget.order.orderedItems.keys.map((offer) {
                    final providerUser = users.firstWhere(
                      (u) => u.id == offer.volunteerId,
                      orElse: () => users.first,
                    );
                    final providerLocation = providerUser.location?.address ?? "Amman, Jordan";

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.store, color: Colors.orange),
                      title: Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Provider: ${providerUser.fullName}\nPickup Location: $providerLocation',
                        style: const TextStyle(height: 1.3),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Customer & Delivery Location:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(widget.order.userName.isNotEmpty ? widget.order.userName : "Customer"),
                      subtitle: const Text('Customer Name'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green),
                      title: Text(widget.order.userPhone.isNotEmpty ? widget.order.userPhone : "N/A"),
                      subtitle: const Text('Phone Number'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.red),
                      title: Text(widget.order.userAddress.isNotEmpty ? widget.order.userAddress : "Amman, Jordan"),
                      subtitle: const Text('Delivery Address'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Order Items Summary:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: widget.order.orderedItems.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${entry.value}x ${entry.key.title}'),
                          Text('${((entry.key.price ?? 0) * entry.value).toStringAsFixed(2)} JD'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),

            _buildActionButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final bool isVolunteer = widget.order.volunteerId != null &&
        widget.order.volunteerId == context.read<UpdateUserProvider>().currentUser!.id.toString();
    if(isVolunteer){
    if (currentStatus.toLowerCase() == 'in preparation') {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.directions_bike),
          label: const Text('Start Delivery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: ConstantColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            _updateStatus(cartProvider, 'delivering', 'Order status updated to: Out for Delivery');
          },
        ),
      );
    } 
    else if (currentStatus.toLowerCase() == 'delivering') {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Mark as Delivered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: ConstantColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            _updateStatus(cartProvider, 'delivered', 'Order successfully marked as Delivered!');
          },
        ),
      );
    } 
    else if (currentStatus.toLowerCase() == 'delivered') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Order Completed & Delivered',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      );
    }}

    return const SizedBox.shrink();
  }

  void _updateStatus(CartProvider provider, String newStatus, String message) {
    setState(() {
      currentStatus = newStatus;
      widget.order.status = newStatus;
    });

    provider.updateOrderStatus(widget.order.orderId, newStatus);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in preparation':
        return Colors.orange;
      case 'delivering':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return ConstantColors.primaryColor;
    }
  }

  String _getFormattedStatus(String status) {
    switch (status.toLowerCase()) {
      case 'in preparation':
        return 'In Preparation';
      case 'delivering':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      default:
        return status;
    }
  }
}