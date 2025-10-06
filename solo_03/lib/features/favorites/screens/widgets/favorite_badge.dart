import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_03/features/favorites/controller/favorites_controller.dart';

class FavoritesBadge extends StatelessWidget {
  const FavoritesBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());

    return Obx(() {
        final count = controller.favoriteIds.length;
        return 
        (count > 0) ?
          Badge(
            backgroundColor: Colors.red,
            label: Text(
              '$count',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Icon(Icons.favorite_border),
          ) :
          Badge(child: Icon(Icons.favorite_border));
      }
    );
  }
}