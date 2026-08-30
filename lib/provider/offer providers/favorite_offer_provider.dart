import 'package:flutter/material.dart';
import 'package:loqma/models/offer_model.dart';

class FavoriteOfferProvider with ChangeNotifier{
final Map<String, List<Offer>> _userFavorites = {};
String? _currentUserId;
List<Offer> get _currentFavorites {
    final activeId = _currentUserId ?? "guest_user";
    return _userFavorites.putIfAbsent(activeId, () => []);
  }

  List<Offer> get offers => _currentFavorites;


  void fetchUserFavorites(String userId) {
    _currentUserId = userId;

    if (!_userFavorites.containsKey(userId)) {
      _userFavorites[userId] =[];
    }

    notifyListeners();
  }


  void toggleFavorite(Offer offer){
    if(_currentFavorites.any((item) => item.id == offer.id))
    {
      _currentFavorites.removeWhere((item)=>item.id==offer.id);

    }
    else{
      _currentFavorites.add(offer);
    }
    notifyListeners();
    
    }
    bool isFavorite(Offer offer) {
    return _currentFavorites.any((o) => o.id == offer.id);
  }
}
  
