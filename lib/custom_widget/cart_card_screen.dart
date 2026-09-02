import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/offer_image.dart';
import 'package:loqma/models/offer_model.dart';
import 'package:loqma/provider/offer%20providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartCardScreen extends StatelessWidget {
  final Offer offer;

  const CartCardScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: OfferImage(
                imagePath: offer.image,
                height: screenWidth * 0.20,
                width: screenWidth * 0.20,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: ConstantStyle.titeStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => cart.decreament(offer),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.remove, size: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    '${cart.getQuantity(offer)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => cart.increament(offer),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.add, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 4),

                      if (offer.type == OfferType.sale)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (offer.originalPrice != null) ...[
                              Text(
                                "${offer.originalPrice}",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 3),
                            ],
                            Text(
                              "${offer.price} JD",
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

            const SizedBox(width: 8),

            InkWell(
              onTap: () => context.read<CartProvider>().removeFromCart(offer),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}