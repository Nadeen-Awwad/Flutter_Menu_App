import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/colors.dart';
import '../../widgets/custom_text_widget.dart';
import '../../widgets/white_empty_card.dart';

class CategoryItem extends StatelessWidget {
  final String? name;
  final String? imgUrl;
  final int? catId;
  final bool isDarkMode;

  const CategoryItem({
    super.key,
    required this.name,
    required this.imgUrl,
    required this.catId,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imgUrl ?? 'assets/images/food.jpg',
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(color: Palette.appColor),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
            fit: BoxFit.cover,
            height: 220,
            width: double.infinity,
            memCacheWidth: 300,
            memCacheHeight: 300,
            fadeInDuration: Duration(milliseconds: 150),
            cacheManager: DefaultCacheManager(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: WhiteEmptyCard(
              color: isDarkMode ? Palette.lightGrey : Palette.offWhite,
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      text: name ?? "Category Name",
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(Icons.star, color: Palette.appColor, size: 18),
                      )
                        ..add(const SizedBox(width: 8))
                        ..addAll([
                          CustomTextWidget.smallText(text: '4.5'),
                          const SizedBox(width: 8),
                          CustomTextWidget.smallText(text: '123 comments'),
                        ]),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildIconWithText(Icons.circle, Palette.lightPink, "Normal"),
                        _buildIconWithText(Icons.access_time, Palette.grey, "23m"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconWithText(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 6),
          CustomTextWidget.smallText(text: text),
        ],
      ),
    );
  }
}
