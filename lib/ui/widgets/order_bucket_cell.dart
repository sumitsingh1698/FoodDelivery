import 'package:BellyDelivery/constants/String.dart';
import 'package:flutter/material.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuCell extends StatelessWidget {
  final i;
  MenuCell(this.i);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
          color: Colors.white,
          elevation: 4.0,
          borderRadius: BorderRadius.circular(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  // child:
                  //  Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: myDetailsContainer(restaurantName),
                  // ),
                  // )
                  )
            ],
          )),
    );
  }
}
