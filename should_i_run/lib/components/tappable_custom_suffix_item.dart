import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:should_i_run/size_config.dart';

class TappableCustomSuffixIcon extends StatelessWidget {
  const TappableCustomSuffixIcon({
    Key key,
    this.svgIcon,
    this.screenRoute,
  }) : super(key: key);

  final String svgIcon;
  final String screenRoute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.popAndPushNamed(context, screenRoute),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          getProportionateScreenWidth(20),
          getProportionateScreenWidth(20),
          getProportionateScreenWidth(20),
        ),
        child: SvgPicture.asset(
          svgIcon,
          height: getProportionateScreenHeight(18),
        ),
      ),
    );
  }
}
