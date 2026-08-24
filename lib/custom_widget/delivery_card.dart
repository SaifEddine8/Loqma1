import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/offer_image.dart';
import 'package:loqma/models/offer_model.dart';
import 'package:loqma/provider/offer%20providers/delivery_provider.dart';
import 'package:provider/provider.dart';

class DeliveryCard extends StatefulWidget {
  final Offer offer;
  const DeliveryCard({super.key, required this.offer});

  @override
  State<DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {

  Future<void> _handleDelete(BuildContext context) async {
    final provider = context.read<DeliveryProvider>();
    bool canCancel = provider.canCancelReservation(widget.offer);

    if (!canCancel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sorry, the cancellation window (15 minutes) has expired!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Cancellation"),
        content: const Text("Are you sure you want to cancel the reservation for this item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Go Back"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    bool success = await provider.removeFromDelivery(widget.offer);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reservation cancelled and item returned successfully."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Offer Image
                  OfferImage(
                    imagePath: widget.offer.image,
                    height: 80,
                    width: 80,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(width: 12),

                  // Title, Quantity Counter, and Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.offer.title,
                                style: ConstantStyle.titeStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Delete Button
                            Consumer<DeliveryProvider>(
                              builder: (context, provider, child) {
                                bool canCancel = provider.canCancelReservation(widget.offer);
                                return InkWell(
                                  onTap: () => _handleDelete(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: canCancel ? Colors.red.shade50 : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: canCancel ? Colors.red : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity Counter
                            Consumer<DeliveryProvider>(
                              builder: (context, value, child) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => value.decreament(widget.offer),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Icon(Icons.remove, size: 16),
                                      ),
                                    ),
                                    Text(
                                      value.getQuantity(widget.offer).toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      onTap: () => value.increament(widget.offer),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Icon(Icons.add, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Price Display
                            if (widget.offer.type == OfferType.sale)
                              Row(
                                children: [
                                  Text(
                                    "${widget.offer.originalPrice}",
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${widget.offer.price} JOD",
                                    style: ConstantStyle.priceStyle,
                                  ),
                                ],
                              )
                            else
                              Text(
                                "FREE",
                                style: ConstantStyle.priceStyle,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status Badge
                  Consumer<DeliveryProvider>(
                    builder: (context, value, child) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ConstantColors.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined, 
                            size: 16, 
                            color: ConstantColors.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            value.getStatus(widget.offer),
                            style: TextStyle(
                              color: ConstantColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // NEXT Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantColors.primaryColor,
                      foregroundColor: ConstantColors.tertiaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.read<DeliveryProvider>().moveToNextStatus(widget.offer);
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: Text(
                      'N E X T',
                      style: ConstantStyle.titeStyle.copyWith(
                        color: ConstantColors.tertiaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
