import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:should_i_run/size_config.dart';
import 'package:should_i_run/screens/forecast_screen/forecast_screen.dart';

class TappableCustomSuffixIcon extends StatelessWidget {
  const TappableCustomSuffixIcon({
    Key key,
    this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.popAndPushNamed(context, ForecastScreen.routeName),
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
