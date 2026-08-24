import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/location_picker_screen.dart';
import 'package:loqma/custom_widget/text_from_field_class.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/models/address_model.dart';
import 'package:loqma/models/user_model.dart';
import 'package:loqma/provider/update_user_provider.dart';
import 'package:loqma/utils.dart';
import 'package:provider/provider.dart';

class EditSheetScreen extends StatefulWidget {
  const EditSheetScreen({super.key});

  @override
  State<EditSheetScreen> createState() => _EditSheetScreenState();
}

class _EditSheetScreenState extends State<EditSheetScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  AddressModel? selectedAddress;
  
  UserType? selectedType=currentUser!.type;

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<UpdateUserProvider>().currentUser;
    selectedType = currentUser?.type ?? UserType.user;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UpdateUserProvider>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            Text('Edit Profile', style: ConstantStyle.titeStyle,),
            Form(
              key: _formkey,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFromFieldClass(
                      controller: fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        return Utils.checkUsername(value) ? null : 'invalid username';
                      },
                      hint: userProvider.currentUser!.fullName,
                    ),
                    TextFromFieldClass(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        return Utils.checkEmail(value) ? null : 'invalid email';
                      },
                      hint: userProvider.currentUser!.email,
                      sufIcon: const Icon(Icons.email),
                    ),
                    TextFromFieldClass(
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        return Utils.checkPhone(value) ? null : 'invalid phone';
                      },
                      hint: userProvider.currentUser!.phone,
                    ),
                    TextFormField(
                      controller: addressController,
                      readOnly: true,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationPickerScreen(),
                          ),
                        );
                        if (result != null) {
                          selectedAddress = result;
                          addressController.text = selectedAddress!.address;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: selectedAddress == null
                            ? userProvider.currentUser!.location!.address
                            : addressController.text,
                        prefixIcon: const Icon(Icons.location_on),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Account Type",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<UserType>(
                            title: const Text('User', style: TextStyle(fontSize: 14)),
                            value: UserType.user,
                            groupValue: selectedType,
                            contentPadding: EdgeInsets.zero,
                            activeColor: ConstantColors.primaryColor,
                            onChanged: (UserType? value) {
                              setState(() {
                                selectedType = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<UserType>(
                            title: const Text('Volunteer', style: TextStyle(fontSize: 14)),
                            value: UserType.volunteer,
                            groupValue: selectedType,
                            contentPadding: EdgeInsets.zero,
                            activeColor: ConstantColors.primaryColor,
                            onChanged: (UserType? value) {
                              setState(() {
                                selectedType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    UserModel updatedUser = UserModel(
                      id: userProvider.currentUser!.id, // تأكد من إرسال الـ id حتى يطابق بشكل صحيح في القائمة
                      fullName: fullNameController.text.isNotEmpty ? fullNameController.text : userProvider.currentUser!.fullName,
                      password: userProvider.currentUser!.password, 
                      email: emailController.text.isNotEmpty ? emailController.text : userProvider.currentUser!.email,
                      phone: phoneController.text.isNotEmpty ? phoneController.text : userProvider.currentUser!.phone,
                      location: selectedAddress != null 
                          ? AddressModel(address: selectedAddress!.address, latitude: selectedAddress!.latitude, longitude: selectedAddress!.longitude) 
                          : userProvider.currentUser!.location,
                      profileImage: userProvider.currentUser!.profileImage, 
                      type: selectedType ?? userProvider.currentUser!.type, // الحفظ هنا
                    );

                    int userIndex = users.indexWhere((user) => user.id == userProvider.currentUser!.id);
                    userProvider.updateUser(updatedUser);
                    
                    if (userIndex != -1) {
                      users[userIndex] = userProvider.currentUser!;
                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save', style: ConstantStyle.titeStyle.copyWith(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
