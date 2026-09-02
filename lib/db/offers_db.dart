import 'package:flutter/material.dart';
import 'package:loqma/models/offer_model.dart';


final  ValueNotifier<List<Offer>> offersNotifier = ValueNotifier<List<Offer>>([
  Offer(
  ownerId:2 ,
    title: 'وجبة برغر دجاج مضاعفة',
    description: 'وجبة برغر مع بطاطا فائضة عن طلب مطعم، جاهزة للتناول الفوري.',
    quantity: 2,
    productionDate: DateTime.now(),
    expiryDate: DateTime.now().add(const Duration(hours: 6)),
    type: OfferType.sale,
    price: 1.80,
    originalPrice: 4.50,
    category: 'fast food',
    image: 'https://img.pikbest.com/png-images/20250730/delicious-crispy-fried-chicken-burger-with-melted-cheese-and-fresh-lettuce_11810495.jpg!sw800',
    volunteerId: null,
  ),

  // 2. Vegetables
  Offer(
    ownerId: 2,
    title: 'صندوق خضروات مشكلة طازجة',
    description: 'تشكيلة طماطم، خيار، وبطاطا بحالة ممتازة للتبرع المباشر.',
    quantity: 4,
    productionDate: DateTime.now().subtract(const Duration(days: 1)),
    expiryDate: DateTime.now().add(const Duration(days: 3)),
    type: OfferType.donation,
    category: 'vegetablse',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtrTAm3cVcw4vCHCYz5XKhcdrE1tmYFdnKw0IZl-83PY915UW9_DLcKq_a&s=10',
    volunteerId: 101,
  ),

  // 3. Fruits
  Offer(
    ownerId:3 ,
    title: 'سلة تفاح وموز طازج',
    description: 'فواكه مشكلة فائضة بحالة ممتازة جداً وصالحة للاستهلاك.',
    quantity: 3,
    productionDate: DateTime.now(),
    expiryDate: DateTime.now().add(const Duration(days: 2)),
    type: OfferType.donation,
    category: 'fruits',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTv_J_8WRrzF4aMrR0v6QepjbqG9XTNMAO86NSv8Jpa4CQh0CY3UCBeOhQ&s=10',
    volunteerId: 102,
  ),

  // 4. Meat
  Offer(
    ownerId: 3,
    title: 'طبق صدور دجاج متبلة',
    description: 'صدور دجاج طازجة متبلة ومغلفة بسعر مخفض للحد من الهدر.',
    quantity: 2,
    productionDate: DateTime.now(),
    expiryDate: DateTime.now().add(const Duration(days: 1)),
    type: OfferType.sale,
    price: 2.50,
    originalPrice: 5.50,
    category: 'meat',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsFWKmBNgvrHBfauLypv7XsBvHbATqOpchE_drF0xajR7Q4L8Y7tz0HelI&s=10',
    volunteerId: null,
  ),

  // 5. Dairy
  Offer(
    ownerId:4 ,
    title: 'عبوات ألبان وأجبان طازجة',
    description: 'مجموعة ألبان وأجبان مغلقة ومحفوظة بشكل ممتاز بالتلاجة.',
    quantity: 5,
    productionDate: DateTime.now().subtract(const Duration(days: 1)),
    expiryDate: DateTime.now().add(const Duration(days: 4)),
    type: OfferType.donation,
    category: 'dairy',
    image: 'https://media.zid.store/cdn-cgi/image/w=480,q=85,f=auto/https://media.zid.store/thumbs/3dfac062-0e10-4b87-af14-41b816f1152c/f5ec4199-270c-41db-818d-011d5f5d39a6-thumbnail-500x500.png',
    volunteerId: 103,
  ),

  // 6. Bakery
  Offer(
    ownerId: 7,
    title: 'سلة معجنات ومخبوزات مشكلة',
    description: 'تشكيلة خبز ومعجنات طازجة مخبوزة اليوم معروضة بخصم كبير.',
    quantity: 6,
    productionDate: DateTime.now(),
    expiryDate: DateTime.now().add(const Duration(days: 1)),
    type: OfferType.sale,
    price: 1.00,
    originalPrice: 3.50,
    category: 'bakery',
    image: 'https://cdn.salla.sa/BrqOyO/0bc74587-b0ac-434a-8546-cab33b8a6ad9-748.73096446701x1000-Xl1QFk1aFwWI05NuYuUMr0WLr8wg8rlDhWJaaHo4.png',
    volunteerId: null,
  ),

  // 7. Canned
  Offer(
    ownerId: 8,
    title: 'طرد معلبات مشكلة (ذرة وفول)',
    description: 'معلبات غذائية جديدة ومغلقة بالكامل مخصصة للتبرع.',
    quantity: 10,
    productionDate: DateTime.now().subtract(const Duration(days: 30)),
    expiryDate: DateTime.now().add(const Duration(days: 180)),
    type: OfferType.donation,
    category: 'canned',
    image: 'https://i.ytimg.com/vi/g-H3g5pfoJ4/hqdefault.jpg',
    volunteerId: 104,
  ),

  // 8. Dry Food
  Offer(
    ownerId: 15,
    title: 'أكياس أرز ومكرونة مغلفة',
    description: 'مواد غذائية جافة مغلفة ومحفوظة بحالة ممتازة بسعر رمزي.',
    quantity: 4,
    productionDate: DateTime.now().subtract(const Duration(days: 10)),
    expiryDate: DateTime.now().add(const Duration(days: 120)),
    type: OfferType.sale,
    price: 1.20,
    originalPrice: 3.00,
    category: 'dry food',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRXnja8Kyatjx_xNcCPWTPOl-QnrPVr9b9gJjjjjv88YJYh-aBVGHk2paI&s=10',
    volunteerId: null,
    
  ),

  // 9. Snacks
  Offer(
    ownerId: 50,
    title: 'صندوق سناك ومكسرات مشكلة',
    description: 'وجبات خفيفة ومكسرات مشكلة للتبرع المباشر بحالة ممتازة.',
    quantity: 5,
    productionDate: DateTime.now().subtract(const Duration(days: 2)),
    expiryDate: DateTime.now().add(const Duration(days: 30)),
    type: OfferType.donation,
    category: 'snacks',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHZaU-hdYEFKbjkfCN3oxGTPUbYhfd1_tLmhavuRUnQrQuCVYQEdtdGeqK&s=10',
    volunteerId: 105,
  ),

  // 10. Drinks
  Offer(
    ownerId: 3,
    title: 'عبوات عصائر طبيعية طازجة',
    description: 'عصائر برتقال وجزر طازجة ومبردة للبيع بسعر مخفض.',
    quantity: 8,
    productionDate: DateTime.now(),
    expiryDate: DateTime.now().add(const Duration(days: 2)),
    type: OfferType.sale,
    price: 0.75,
    originalPrice: 2.00,
    category: 'drinks',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsfFu2aNqb4CcGxenFCAMrI7lpRVIPEdz-mx02xeYlww&s=10',
    volunteerId: null,
  ),]);


void updateOfferQuantityInDB({updatedOffer}) {
  List<Offer> currentList = List.from(offersNotifier.value);

  int index = currentList.indexWhere((element) => element.id == updatedOffer.id);

  if (index != -1) {
    currentList[index] = updatedOffer;

    offersNotifier.value = currentList;
  }
}



List<String>categories=[
  'All',
  'fast food',
  'vegetablse',
  'fruits',
  'meat',
  'dairy',
  'bakery',
  'canned',
  'dry food',
  'snacks',
  'drinks'  
  ];




  Map<String, int> categoryMaxDays = {
  'fast food': 2,        // يومين كحد أقصى
  'meat': 3,             // 3 أيام
  'bakery': 4,           // 4 أيام
  'dairy': 7,            // أسبوع
  'vegetablse': 10,      // 10 أيام
  'fruits': 14,          // أسبوعين
  'drinks': 30,          // شهر
  'snacks': 180,         // 6 أشهر
  'dry food': 365,       // سنة
  'canned': 730,         // سنتين
};