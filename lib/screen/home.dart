import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/cart_icon.dart';
import 'package:loqma/custom_widget/delivery_icon.dart';
import 'package:loqma/custom_widget/item_card.dart';
import 'package:loqma/db/offers_db.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/models/offer_model.dart';
import 'package:loqma/models/user_model.dart';
import 'package:loqma/provider/update_user_provider.dart';
import 'package:loqma/screen/available_orders_screen.dart';
import 'package:loqma/screen/notification_screen.dart';
import 'package:loqma/screen/waiting_offer_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String categoryName = 'All';
  int selectedCategory = 0;
  String search = '';
  @override
  void initState() {
    super.initState();
    offersNotifier.addListener(_onOffersChanged);
  }

  void _onOffersChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    offersNotifier.removeListener(_onOffersChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth = (screenWidth - 32 - 10) / 2;
    final double requiredItemHeight = 143 + 140;
    final double dynamicAspectRatio = itemWidth / requiredItemHeight;
    // offersNotifier.value=offersNotifier.value.where((item)=>item.expiryDate.isAfter(DateTime.now())).toList();
    offersNotifier.value.removeWhere(
      (item) => item.expiryDate.isBefore(DateTime.now()),
    );

    List<Offer> filterProducts = offersNotifier.value.where((item) {
      final filterFromCategory =
          categoryName == 'All' || item.category == categoryName;
      final filterFromSearch = item.title.toLowerCase().contains(
        search.toLowerCase(),
      );
      return filterFromCategory &&
          filterFromSearch &&
          item.expiryDate.isAfter(DateTime.now()) &&
          item.quantity > 0;

      //  if(categoryName=='All')
      //           {
      //             return true;
      //           }
      //           return item.category==categoryName;
    }).toList();

    return Scaffold(
      backgroundColor: ConstantColors.tertiaryColor,

      appBar: AppBar(
        backgroundColor: ConstantColors.tertiaryColor,
        title: Text('Loqma', style: ConstantStyle.screentitleStyle),
        centerTitle: true,
        leadingWidth: 100,
        leading: Row(
          spacing: 10,
          children: [
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReceiptsHistoryScreen(
                    currentUserId: context
                        .read<UpdateUserProvider>()
                        .currentUser!
                        .id
                        .toString(),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.notifications),
              ),
            ),

            if (context.watch<UpdateUserProvider>().currentUser?.type ==
                UserType.volunteer)
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaitingOfferScreen()),
                ),
                child: Icon(Icons.approval),
              ),
          ],
        ),
        actions: [
          CartIcon(iconColor: Colors.black),
          context.watch<UpdateUserProvider>().currentUser!.type ==
                  UserType.volunteer
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DeliveryIcon(),
                )
              : Text(''),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: .infinity,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fillColor: ConstantColors.tertiaryColor,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Offer.....',
                ),
                onChanged: (value) => setState(() {
                  search = value.toLowerCase();
                }),
              ),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemExtent: 150,
                  itemCount: categories.length,
                  scrollDirection: .horizontal,
                  itemBuilder: (context, index) => ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = index;
                        categoryName = categories[index];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedCategory == index
                          ? ConstantColors.primaryColor
                          : ConstantColors.tertiaryColor,
                    ),
                    child: selectedCategory == index
                        ? Text(
                            categories[index],
                            style: TextStyle(
                              color: ConstantColors.tertiaryColor,
                            ),
                          )
                        : Text(
                            categories[index],
                            style: ConstantStyle.listItem,
                          ),
                  ),
                ),
              ),

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: dynamicAspectRatio,
                  ),

                  itemCount: filterProducts.length,
                  itemBuilder: (context, index) =>
                      ItemCard(offer: filterProducts[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    


    floatingActionButton: context.watch<UpdateUserProvider>().currentUser?.type == UserType.volunteer
    ? FloatingActionButton.extended(
        onPressed: () {
          final currentUser = context.read<UpdateUserProvider>().currentUser;
          if (currentUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AvailableOrdersScreen(
                  currentVolunteerId: currentUser.id.toString(),
                ),
              ),
            );
          }
        },
        backgroundColor: ConstantColors.primaryColor,
        icon: const Icon(Icons.delivery_dining, color: Colors.white),
        label: const Text(
          'Pending Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    : null,
    );
  }
}
