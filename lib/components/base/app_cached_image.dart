

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class AppCachedImage extends StatelessWidget{
  /// Image url, if not provided it will show an empty placeholder
  final String? url;

  /// Image height
  final double height;

  /// Image width
  final double width;

  const AppCachedImage({super.key, this.url, required this.height, this.width = double.infinity});

  @override
  Widget build(BuildContext context) =>
    ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: url != null ?
        CachedNetworkImage(
          imageUrl: url!, 
          alignment: Alignment.bottomCenter,
          fit: BoxFit.cover,
          height: height,
          width: width,
          placeholder: (c, url)=> Shimmer.fromColors(
            baseColor: Colors.grey.shade300, 
            highlightColor: AppTheme.appLightGrey,
            child: imagePlaceholder(context, children: []), 
          ),
          errorWidget: (c, url, err)=> imagePlaceholder(
            context, 
            children: [
              Icon(Icons.warning_rounded, color: AppTheme.appGrey),
            ]
          ),
        ) :
        imagePlaceholder(
          context,
          children: [
            Icon(Icons.question_mark_rounded, color: AppTheme.appGrey),
          ]
        )
        
    );
  

  Widget imagePlaceholder(BuildContext context, {required List<Widget> children}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppTheme.appLightGrey
      ),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children
      ),
    );
  
}