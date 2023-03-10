import 'package:flutter/material.dart';
import 'package:voomeg/core/global/resources/strings_manager.dart';
import 'package:voomeg/core/global/routes/app_routes_names.dart';
import 'package:voomeg/features/auth/presentation/screens/login_screen.dart';
import 'package:voomeg/features/auth/presentation/screens/register_screen.dart';
import 'package:voomeg/features/bids/presentation/screens/add_car_screen.dart';
import 'package:voomeg/features/bids/presentation/screens/home_screen.dart';
import 'package:voomeg/features/bids/presentation/screens/offers_screens/add_offer_screen.dart';
import 'package:voomeg/features/bids/presentation/screens/offers_screens/user_offers_screen.dart';
import 'package:voomeg/features/bids/presentation/screens/trader_home_screen.dart';

class AppRouter {
static Route<dynamic> onGenerateRoutes (RouteSettings settings){
  switch (settings.name){
    case AppRoutesName.login:
      return MaterialPageRoute(builder: (_)=>const LoginScreen());
    case AppRoutesName.register:
      return MaterialPageRoute(builder: (_)=> RegisterScreen());
    case AppRoutesName.home:
      return MaterialPageRoute(builder: (_)=> HomeScreen());
    case AppRoutesName.addCar:
      return MaterialPageRoute(builder: (_)=> AddCarScreen());
    case AppRoutesName.traderHome:
      return MaterialPageRoute(builder: (_)=> const TraderHomeScreen());
    case AppRoutesName.addOffer:
      return MaterialPageRoute(builder: (_)=>  AddOfferScreen());
    case AppRoutesName.userOffers:
      return MaterialPageRoute(builder: (_)=>  const UserOffersScreen());
    default :
      return undefinedRoute();

  }
}
static Route<dynamic>undefinedRoute(){
  return MaterialPageRoute(builder: (_)=>
      Scaffold(
        appBar: AppBar(title: const Text(AppStrings.noRouteFound),),
        body: const Center(
          child: Text(AppStrings.noRouteFound),
        ),
      )
  );
}
}