import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FavoritesNotFound extends StatelessWidget {
  const FavoritesNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Gap(100),
        SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/favorites/not_found.png',
              fit: BoxFit.cover,
            )),
        const Gap(20),
        Text('No Favorites Selected', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const Gap(20),
        Text('Please go back to the Browser screen and star individual Pokémon to favorite.',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium
        )
      ],
    );
  }
}
