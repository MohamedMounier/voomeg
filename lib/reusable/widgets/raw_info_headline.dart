import 'package:flutter/material.dart';

class InfoRowHeadline extends StatelessWidget {
  const InfoRowHeadline({Key? key, required this.title, required this.info}) : super(key: key);
  final String title;
  final String info;
  @override
  Widget build(BuildContext context) {
      return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Flexible(child: Text(info, style: Theme.of(context).textTheme.headlineLarge)),
      ],
    );
  }
}
