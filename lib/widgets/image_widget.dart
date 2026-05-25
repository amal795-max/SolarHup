// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:shimmer/shimmer.dart';
//
// class ImageWidget extends StatelessWidget {
//   final String? image;
//   final double? height;
//   final double? width;
//   final BoxFit fit;
//   final double borderRadius;
//   final bool enableHero;
//   final String? heroTag;
//
//   const ImageWidget({
//     super.key,
//     this.image,
//     this.height,
//     this.width,
//     this.fit = BoxFit.cover,
//     this.borderRadius = 8,
//     this.enableHero = false,
//     this.heroTag,
//   });
//
//   bool get _isSvg => image != null && image!.toLowerCase().endsWith(".svg");
//
//   bool get _isValidUrl {
//     if (image == null || image!.isEmpty) return false;
//     final uri = Uri.tryParse(image!);
//     return uri != null && uri.isAbsolute;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isValidUrl) {
//       return _fallbackIcon();
//     }
//
//     Widget content = ClipRRect(
//       borderRadius: BorderRadius.circular(borderRadius.r),
//       child: _isSvg ? _buildSvg() : _buildNetworkImage(),
//     );
//
//     if (enableHero && heroTag != null) {
//       content = Hero(tag: heroTag!, child: content);
//     }
//
//     return GestureDetector(
//       onTap: enableHero && heroTag != null
//           ? () => _openFullScreen(context)
//           : null,
//       child: content,
//     );
//   }
//
//   Widget _buildSvg() {
//     return SvgPicture.network(
//       image!,
//       height: height,
//       width: width,
//       fit: fit,
//       placeholderBuilder: (_) => _shimmer(),
//     );
//   }
//
//   Widget _buildNetworkImage() {
//     return CachedNetworkImage(
//       imageUrl: image!,
//       height: height,
//       width: width,
//       fit: fit,
//       placeholder: (_, __) => _shimmer(),
//       errorWidget: (_, __, ___) => _fallbackIcon(),
//     );
//   }
//
//   // Widget _shimmer() {
//   //   return Shimmer.fromColors(
//   //     baseColor: Colors.grey.shade300,
//   //     highlightColor: Colors.grey.shade100,
//   //     child: Container(
//   //       height: height ?? 80.h,
//   //       width: width ?? 110.w,
//   //       color: Colors.white,
//   //     ),
//   //   );
//   // }
//
//   Widget _fallbackIcon() {
//     return Icon(Icons.broken_image_outlined, size: 30.w, color: Colors.grey);
//   }
//
//   void _openFullScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => FullScreenImage(
//           image: image!,
//           heroTag: heroTag!,
//         ),
//       ),
//     );
//   }
// }
//
// class FullScreenImage extends StatelessWidget {
//   final String image;
//   final String heroTag;
//
//   const FullScreenImage({
//     super.key,
//     required this.image,
//     required this.heroTag,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () => Navigator.pop(context),
//         child: Center(
//           child: Hero(
//             tag: heroTag,
//             child: InteractiveViewer(
//               clipBehavior: Clip.hardEdge,
//               child: CachedNetworkImage(
//                 imageUrl: image,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
