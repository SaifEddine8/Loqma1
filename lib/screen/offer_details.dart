import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/cart_icon.dart';
import 'package:loqma/custom_widget/offer_image.dart';
import 'package:loqma/db/offers_db.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/models/offer_model.dart';
import 'package:loqma/models/user_model.dart';
import 'package:loqma/provider/offer%20providers/cart_provider.dart';
import 'package:loqma/provider/offer%20providers/delivery_provider.dart';
import 'package:loqma/provider/offer%20providers/favorite_offer_provider.dart';
import 'package:loqma/provider/update_user_provider.dart';
import 'package:provider/provider.dart';


class OfferDetails extends StatefulWidget {

  final Offer offer;

  const OfferDetails({
    super.key,
    required this.offer,
  });


  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}
class _OfferDetailsState extends State<OfferDetails> {

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UpdateUserProvider>(); 
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if(widget.offer.type==OfferType.donation&&userProvider.currentUser!.type==UserType.volunteer)
              Expanded(
                child: SizedBox(
                  height: 55,
                  width: width/2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantColors.tertiaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
  updateOfferQuantityInDB(
    updatedOffer: widget.offer.copyWith(
      volunteerId: userProvider.currentUser!.id, 
    ),
  );
  context.read<DeliveryProvider>().addToDelivery(widget.offer,volunteerId: userProvider.currentUser!.id); 

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Reserved successfully!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade600,
      behavior: SnackBarBehavior.floating, // يعطيه مظهر عصري وعائم
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 2),
    )
    );
},
                    child: Text(
                      
                           "Reserve Now",
                      style:  TextStyle(
                        color: ConstantColors.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              
              Expanded(
                child: SizedBox(
                  height: 55,
                  width: width/2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: (){
                      context.read<CartProvider>().addToCart(widget.offer);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Added to cart successfully!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade600,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
                    },
                    child: Text(
                      
                          "ADD TO CART",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.offer.id!,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                     child:OfferImage(imagePath: widget.offer.image,fit: .cover,height:height * 0.45 ,width: width,)
                    // Image.network(
                    //   widget.offer.image,
                    //   width: width,
                    //   height: height * 0.45,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                Container(
                  height: height * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      onPressed: (){
                        context.read<FavoriteOfferProvider>().toggleFavorite(widget.offer);


                      },


                      icon: Consumer<FavoriteOfferProvider>(
                            builder: (context, value, child) => 
                            Icon(
                              value.offers.contains(widget.offer)? Icons.favorite:Icons.favorite_border,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 25,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: widget.offer.type == OfferType.donation
                          ? Colors.green
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      widget.offer.type == OfferType.donation
                          ? "Donation"
                          : "Sale",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                   bottom: 35,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: CartIcon(iconColor: Colors.white)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.offer.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.offer.category,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 15),
                  widget.offer.type == OfferType.donation
                      ? Text(
                          "FREE",
                          style: TextStyle(
                            color: ConstantColors.primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.offer.originalPrice} JD",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${widget.offer.price} JD",
                              style: TextStyle(
                                color: ConstantColors.primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 25),
                  Container(
                    alignment: .centerLeft,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.fastfood,
                          title: "Quantity",
                          value: "${widget.offer.quantity} meals",
                        ),
                        const Divider(),
                        _infoRow(
                          icon: Icons.category,
                          title: "Category",
                          value: widget.offer.category,
                        ),
                        const Divider(),
                        _infoRow(
                          icon: Icons.calendar_today,
                          title: "Production",
                          value:
                          "${widget.offer.productionDate.day}/${widget.offer.productionDate.month}/${widget.offer.productionDate.year}",
                        ),
                        const Divider(),
                        _infoRow(
                          icon: Icons.timer,
                          title: "Expiry",
                          value:
                          "${widget.offer.expiryDate.day}/${widget.offer.expiryDate.month}/${widget.offer.expiryDate.year}",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: ConstantStyle.titeStyle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(
                      widget.offer.description,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ConstantColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Owner",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "User #${widget.offer.ownerId}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                          ConstantColors.primaryColor,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }){
    return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(
        icon,
        color: ConstantColors.primaryColor,
      ),
      const SizedBox(width: 12),
      
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  );
  }



  Widget _buildOfferImage(String imagePath) {
  final String path = imagePath.trim();

  if (path.startsWith('http://') || path.startsWith('https://')) {
    return Image.network(
      path,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagePlaceholder(),
    );
  }

  final cleanPath = path.startsWith('file://') 
      ? path.replaceFirst('file://', '') 
      : path;
  final file = File(cleanPath);

  if (file.existsSync()) {
    return Image.file(
      file,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagePlaceholder(),
    );
  }

  return _imagePlaceholder();
}

Widget _imagePlaceholder() {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.45,
    color: Colors.grey.shade300,
    child: const Icon(Icons.fastfood, size: 60, color: Colors.grey),
  );
}
}




