import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:should_i_run/constants.dart';
import 'package:should_i_run/size_config.dart';

class CustomSuffixIcon extends StatelessWidget {
  const CustomSuffixIcon({
    Key key,
    this.svgIcon,
    this.iconSize,
  }) : super(key: key);

  final String svgIcon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: getProportionateScreenHeight(iconSize),
        color: kPrimaryColor,
      ),
    );
  }
}
