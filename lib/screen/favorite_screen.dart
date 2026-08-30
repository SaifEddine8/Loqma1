import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/cart_icon.dart';
import 'package:loqma/custom_widget/favorite_card.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/models/offer_model.dart';
import 'package:loqma/provider/offer%20providers/favorite_offer_provider.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteOfferProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CircleAvatar(
            backgroundColor: Colors.orange[200],
            radius: MediaQuery.of(context).size.height / 30,
            backgroundImage: currentUser!.profileImage != null
                ? FileImage(currentUser!.profileImage!)
                : null,
            child: currentUser!.profileImage == null
                ?  Icon(Icons.person,color: ConstantColors.primaryColor,size: MediaQuery.of(context).size.height / 40)
                : null,
          ),
        ),
        title: ListTile(
          title: Text(
            currentUser!.fullName,
            style: ConstantStyle.screentitleStyle.copyWith(color: Colors.black),
          ),
          subtitle: Text(currentUser!.email),
        ),
        backgroundColor: ConstantColors.tertiaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CartIcon(iconColor: Colors.black,),
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: ConstantColors.tertiaryColor,
      body: provider.offers.length == 0
          ? Center(child: Text('No Data'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  spacing: 10,
                  children: [
                    // Row(
                    //   children: [
                    //     CircleAvatar(
                    //       radius: 40,
                    //       backgroundImage: currentUser!.profileImage != null
                    //           ? FileImage(currentUser!.profileImage!)
                    //           : null,
                    //       child: currentUser!.profileImage == null
                    //           ? const Icon(Icons.person)
                    //           : null,
                    //     ),
                    //     Expanded(
                    //       child: ListTile(
                    //         title: Text(currentUser!.fullName,style: ConstantStyle.screentitleStyle.copyWith(color: Colors.black,),),
                    //         subtitle: Text(currentUser!.email),

                    //       ),
                    //     )
                    //   ],
                    // ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.offers.length,
                        itemBuilder: (context, index) {
                          // print(item.title);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FavoriteCard(item: provider.offers[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
