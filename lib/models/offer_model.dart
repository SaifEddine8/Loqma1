import 'package:loqma/db/user_db.dart';
 
 

enum OfferType{
  donation,
  sale
}



class Offer {
  static int counter=0;
  final int? id;
  final int ownerId;
  final String title;
  final String description;
  final int quantity;
  final DateTime expiryDate;
  final DateTime productionDate;
  final OfferType type;
  final String image;
  final double?price;
  final double?originalPrice;
  final String category;
  final bool public;
  final int? volunteerId;





Offer({
   required this.ownerId,
    required this.title,
    required this.description,
    required this.quantity,
    required this.expiryDate,
    required this.productionDate,
    required this.image,
    this.price,
    this.originalPrice,
    required this.category,
    this.volunteerId,
    required this.type,
    this.public=false,
    int?id

  }):id=id??++counter;

Offer copyWith({
    int? ownerId,
    String? title,
    String? description,
    int? quantity,
    DateTime? expiryDate,
    DateTime? productionDate,
    OfferType? type,
    String? image,
    double? price,
    double? originalPrice,
    String? category,
    int? volunteerId,
    bool? public
  }) {
    return Offer(
      id: this.id, 
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      productionDate: productionDate ?? this.productionDate,
      type: type ?? this.type,
      image: image ?? this.image,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      volunteerId: volunteerId ?? this.volunteerId,
      public: public??this.public
    );
  }


}
