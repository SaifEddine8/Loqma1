import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/offer_image.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/models/offer_model.dart';
import 'package:loqma/models/user_model.dart';
import 'package:loqma/provider/offer%20providers/favorite_offer_provider.dart';
import 'package:loqma/screen/offer_details.dart';
import 'package:provider/provider.dart';

class FavoriteCard extends StatelessWidget {
  Offer item;
  FavoriteCard({super.key,required this.item});
  
  @override
  Widget build(BuildContext context) {
    final owner=users.any((user)=>user.id==item.ownerId)?users.firstWhere((user)=>user.id==item.ownerId):null;
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>OfferDetails(offer:item))),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 30,
        child: Container(
          height:height/6 ,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12)
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Container(
                    height: constraints.maxHeight/1.5,
                    
                    child: OfferImage(imagePath: item.image,fit: .cover,height:constraints.maxHeight/1.5 ,width:constraints.maxWidth/3 ,borderRadius: BorderRadius.circular(12),)),
                  Column(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth/4,
                        child: Text(item.title,style: ConstantStyle.titeStyle,textAlign: .center,overflow: TextOverflow.ellipsis,)),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(Icons.schedule),
                          Text('${item.expiryDate.year}/${item.expiryDate.month}/${item.expiryDate.day} Exp'),
                        ],
                      ),
                      Text(owner?.fullName??'UnKnown'),
                      Row(
                        children: [
                          Icon(Icons.location_pin),
                          Text(owner?.location!.address??'no address'),
                        ],
                      )
              
                    ],
                  ),
                  InkWell
                  (
                    onTap: () {
                      context.read<FavoriteOfferProvider>().toggleFavorite(item);
              
                    },
                    child: Column(
                      mainAxisAlignment: .start,
                      children: [
                        Icon( Icons.favorite,color: Colors.red,),
                      ],
                    ))
                ],
              ),
            ),
          ),
        ),
      
      ),
    );



  }
}