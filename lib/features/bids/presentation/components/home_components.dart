import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voomeg/core/global/resources/color_manager.dart';
import 'package:voomeg/core/global/resources/size_config.dart';
import 'package:voomeg/core/global/resources/values_manager.dart';
import 'package:voomeg/features/bids/domain/entities/for_sale_cars.dart';
import 'package:voomeg/reusable/widgets/car_carouser_slider.dart';
import 'package:voomeg/reusable/widgets/info_raw_medium.dart';
import 'package:voomeg/reusable/widgets/price_row.dart';
import 'package:voomeg/reusable/widgets/raw_info_headline.dart';

class HomeComponents extends StatelessWidget {
  HomeComponents(
      {Key? key,
      required this.userUid,
      required this.car,
      required this.imageUrl,
      this.isTrader = false,
      required this.traderFunction,
      required this.userFunction,
      this.imagesList})
      : super(key: key);
  final String userUid;
  final CarForSale car;
  final String imageUrl;
  final bool isTrader;
  final Function userFunction;
  final Function traderFunction;
  List<dynamic>? imagesList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPading.p10),
      decoration: homeBoxDecoration(context),
      margin: const EdgeInsets.only(
          left: AppMargin.m22,
          right: AppMargin.m20,
          top: AppMargin.m50,
          bottom: AppMargin.m22),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarCarouselSlider(imagesList: car.photosUrls),
            SizedBox(height: SizeConfig.screenHeight(context)*0.008,),

            PriceRowWidget(
              title: 'Reserve Price',
              price: car.reservePrice.toString(),
            ),
            SizedBox(height: SizeConfig.screenHeight(context)*0.02,),
           InfoRowHeadline(title: 'Car Name', info: car.carName),
            SizedBox(height: SizeConfig.screenHeight(context)*0.008,),
            InfoRowMedium(title: 'Model', info: car.carModel),
            SizedBox(height: SizeConfig.screenHeight(context)*0.008,),

            InfoRowMedium(title: 'Consumed Kilos', info: car.carKilos),
            SizedBox(height: SizeConfig.screenHeight(context)*0.008,),

            showOrAddOfferButton()
          ],
        ),
      ),
    );
  }

  BoxDecoration homeBoxDecoration(BuildContext context) {
    return BoxDecoration(
        border: Border.all(color: ColorManager.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor.withOpacity(0.1),
          Theme.of(context).primaryColor.withOpacity(0.06),
          Theme.of(context).primaryColor.withOpacity(0.1),
          Theme.of(context).primaryColor.withOpacity(0.08),
          Theme.of(context).primaryColor.withOpacity(0.2),
        ]));
  }

  Visibility showOrAddOfferButton() {
    return Visibility(
            visible: isTrader,
            child: ElevatedButton(
                onPressed: () {
                  traderFunction();
                },
                child: Text('Add Offer')),
            replacement: ElevatedButton(
              onPressed: () {
                userFunction();
              },
              child: Text('Show Offers'),
            ),
          );
  }





}
