import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/cart_icon.dart';
import 'package:loqma/custom_widget/delivery_icon.dart';
import 'package:loqma/custom_widget/text_from_field_class.dart';
import 'package:loqma/db/offers_db.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/models/offer_model.dart';
import 'package:loqma/models/user_model.dart';
import 'package:loqma/provider/offer%20providers/cart_provider.dart';
import 'package:loqma/provider/offer%20providers/waiting_offers.dart';
import 'package:loqma/provider/update_user_provider.dart';
import 'package:provider/provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController productionDateController =
      TextEditingController();
  final TextEditingController expiredDateController = TextEditingController();
  DateTime? selectedDate;
  DateTime? productionDate;
  DateTime? expiryDate;
  TextEditingController originPrice = TextEditingController();
  TextEditingController discount = TextEditingController();
  double finalPrice = 0;

  List<DropdownMenuItem<String>> addcategories = categories
      .skip(1)
      .map(
        (category) =>
            DropdownMenuItem<String>(value: category, child: Text(category)),
      )
      .toList();
  TextEditingController nameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickerImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
    }
  }

  String? selectedCategory;
  OfferType? selectedType;
  TextEditingController descriptionController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.tertiaryColor,
      appBar: AppBar(
        leading:
            context.watch<UpdateUserProvider>().currentUser!.type ==
                UserType.volunteer
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DeliveryIcon(),
              )
            : Text(''),

        backgroundColor: ConstantColors.tertiaryColor,
        title: Text('Add New Offer', style: ConstantStyle.screentitleStyle),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CartIcon(iconColor: Colors.black,),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                InkWell(
                  onTap: () {
                    _pickerImage();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    width: .infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: .infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: .center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: MediaQuery.of(context).size.height / 8,
                                color: ConstantColors.primaryColor,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Upload Surplus Food Image",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Product Name',
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter product name";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  hint: Text('Choose Category'),
                  value: selectedCategory,
                  items: addcategories,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),

                TextFormField(
                  controller: quantityController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: '1',
                    prefixIcon: IconButton(
                      onPressed: () {
                        int current =
                            int.tryParse(quantityController.text) ?? 1;
                        setState(() {
                          if (current > 0)
                            quantityController.text = (current - 1).toString();
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        int current =
                            int.tryParse(quantityController.text) ?? 0;
                        setState(() {
                          quantityController.text = (current + 1).toString();
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    labelText: 'quantity',
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'required';
                    }
                    final q = int.tryParse(value.trim());
                    if (q == null || q <= 0) {
                      return 'quantity must be at lest one';
                    }
                    return null;
                  },
                ),

                // ElevatedButton.icon(onPressed: () async{
                //   final  DateTime? picked=await showDatePicker(context: context,initialDate:DateTime.now() , firstDate: DateTime(DateTime.now().year-10), lastDate: DateTime(DateTime.now().year+10));
                //   if(picked!=null)
                //   {
                //     setState(() {
                //       productionDate=picked;
                //     });
                //   }
                // } ,
                // icon: Icon(Icons.calendar_today),
                // label:Text('Choose Production Date') ,),

                TextFormField(
                  controller: productionDateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: productionDate ?? DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 10),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );

                    if (picked != null) {
                      setState(() {
                        productionDate = picked;
                        productionDateController.text =
                            "${picked.year}/${picked.month}/${picked.day}";
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Production Date',
                    hintText: 'Choose date',
                    suffixIcon: const Icon(
                      Icons.date_range,
                    ), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: expiredDateController,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: expiryDate ?? DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 10),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );

                    if (picked != null) {
                      setState(() {
                        expiryDate = picked;
                        expiredDateController.text =
                            "${picked.year}/${picked.month}/${picked.day}";
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Expired Date',
                    hintText: 'Choose date',
                    suffixIcon: const Icon(
                      Icons.date_range,
                    ),  
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),

                TextFromFieldClass(
                  controller: descriptionController,
                  hint: 'Product Description',
                  lable: 'description',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your product description';
                    }
                    return null;
                  },
                ),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.all(16),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<OfferType>(
                                value: OfferType.donation,
                                title: Text('donation'),
                                groupValue: selectedType,
                                onChanged: (value) => setState(() {
                                  selectedType = value;
                                }),
                                activeColor: ConstantColors.secondaryColor,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<OfferType>(
                                value: OfferType.sale,
                                title: Text('sale'),
                                groupValue: selectedType,
                                onChanged: (value) => setState(() {
                                  selectedType = value;
                                }),
                                activeColor: ConstantColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                        if (selectedType == OfferType.sale)
                          Form(
                            child: Column(
                              spacing: 10,
                              children: [
                                TextFromFieldClass(
                                  controller: originPrice,
                                  hint: 'Origin Price',
                                  preIcon: Icons.attach_money,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'required';
                                    }
                                    final price = double.tryParse(value.trim());
                                    if (price == null) {
                                      return 'must be numbers';
                                    }
                                    if (price <= 0) {
                                      return 'must be greater than 0';
                                    }
                                  },
                                ),
                                TextFromFieldClass(
                                  controller: discount,
                                  hint: 'Discount',
                                  help: '30 <= discount <= 100',
                                  preIcon: Icons.percent,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'required';
                                    }
                                    final discount = double.tryParse(
                                      value.trim(),
                                    );
                                    if (discount == null) {
                                      return 'must be numbers';
                                    }
                                    if (discount < 30 || discount > 100) {
                                      return 'must be between 30% and 100%';
                                    }
                                    // if()
                                  },
                                ),
                              ],
                            ),
                            onChanged: () => setState(() {
                              final Discount = double.tryParse(
                                discount.text.trim(),
                              );
                              final price = double.tryParse(
                                originPrice.text.trim(),
                              );
                              if (Discount != null &&
                                  Discount >= 30 &&
                                  Discount < 100 &&
                                  price != null &&
                                  price > 0) {
                                finalPrice = price - (price * (Discount / 100));
                              } else {
                                finalPrice = 0;
                              }
                            }),
                          ),
                        if (selectedType == OfferType.sale)
                          Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'the final price after discount : ',
                                style: ConstantStyle.priceStyle,
                              ),
                              Text(
                                '${finalPrice} JD',
                                style: ConstantStyle.priceStyle,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!_formkey.currentState!.validate()) {
                      return;
                    }
                    if (_selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please choose an image')),
                      );
                      return;
                    }
                    if (selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please choose offer type')),
                      );
                      return;
                    }
                    if (selectedType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please choose offer type')),
                      );
                      return;
                    }
                    if (productionDate == null || expiryDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please choose both dates"),
                        ),
                      );
                      return;
                    }

                    if (expiryDate!.isBefore(productionDate!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Expiry date must be after production date",
                          ),
                        ),
                      );
                      return;
                    }

                    final diferenceDay = expiryDate!
                        .difference(productionDate!)
                        .inDays;
                    final maxAllowedDays = categoryMaxDays[selectedCategory];
                    if (diferenceDay > maxAllowedDays!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'the diference detween dates greater than the limit is allowed',
                          ),
                        ),
                      );
                      return;
                    }
                    final offer = Offer(
                      title: nameController.text,
                      description: descriptionController.text,
                      quantity: int.parse(quantityController.text),
                      expiryDate: expiryDate!,
                      productionDate: productionDate!,
                      image: _selectedImage!.path,
                      category: selectedCategory!,
                      type: selectedType!,
                      originalPrice: selectedType == OfferType.sale
                          ? double.parse(originPrice.text)
                          : null,
                      price: selectedType == OfferType.sale ? finalPrice : 0,
                      ownerId: currentUser!.id,
                    );

                    context.read<WaitingOffers>().add(offer);
                    context
                        .read<UpdateUserProvider>()
                        .currentUser!
                        .donations
                        .add(offer);
                    currentUser!.donations.add(offer);
                    //   offersNotifier.value.add(Offer(title:nameController.text , description: descriptionController.text, quantity: int .parse(quantityController.text), expiryDate: expiryDate!, productionDate: productionDate!, image: _selectedImage!.path, category: selectedCategory!,type: selectedType!,originalPrice: selectedType==OfferType.sale? double.parse(originPrice.text):null,price: selectedType == OfferType.sale
                    // ? finalPrice
                    // : 0, ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Offer added successfully")),
                    );
                  },
                  child: Text(
                    'ADD OFFER',
                    style: ConstantStyle.titeStyle.copyWith(
                      color: ConstantColors.tertiaryColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantColors.primaryColor,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
