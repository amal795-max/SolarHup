import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

extension SpaceXY on double {
  SizedBox get spaceX => SizedBox(width: w);

  SizedBox get spaceY => SizedBox(height: h);
}
