import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/profile_options.dart';
import 'package:loqma/db/profile_options_db.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/models/user_model.dart';
import 'package:loqma/provider/offer%20providers/delivery_provider.dart';
import 'package:loqma/provider/update_user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UpdateUserProvider>().currentUser;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.tertiaryColor,
        title: Text('My Profile', style: ConstantStyle.screentitleStyle,),
        centerTitle: true,
      ),
      backgroundColor: ConstantColors.tertiaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange[200],
                      radius: MediaQuery.of(context).size.height / 18,
                      backgroundImage: user!.profileImage != null
                          ? FileImage(user.profileImage!)
                          : null,
                      child: user.profileImage == null
                          ?  Icon(Icons.person,color: ConstantColors.primaryColor,size: MediaQuery.of(context).size.height / 22,)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(user.fullName, style: ConstantStyle.titeStyle,),
                    const SizedBox(height: 4),
                    Text(user.location?.address ?? 'Unknown'),
                    
                    if (user.type == UserType.volunteer) ...[
                      const SizedBox(height: 16),
                      Consumer<DeliveryProvider>(
                        builder: (context, value, child) {
                          final totalMeals = value.completedOffers.fold<int>(
                            0, (sum, offer) => sum + value.getCompletedQuantity(offer)
                          );

                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: ConstantColors.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: ConstantColors.primaryColor.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delivery_dining,
                                        color: ConstantColors.primaryColor,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${value.completedOffers.length}', 
                                              style: ConstantStyle.titeStyle.copyWith(
                                                color: ConstantColors.primaryColor,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const Text(
                                              'Deliveries',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 12), 
                              
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: ConstantColors.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: ConstantColors.primaryColor.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.fastfood, 
                                        color: ConstantColors.primaryColor,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '$totalMeals', 
                                              style: ConstantStyle.titeStyle.copyWith(
                                                color: ConstantColors.primaryColor,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const Text(
                                              'Total Meals',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
                
                Column(
                  children: options.map((option) =>
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProfileOptions(
                        optionTitle: option.title,
                        preIcon: option.icon,
                        onTap: option.onTap,
                      ),
                    )
                  ).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}