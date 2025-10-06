import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PokeAPIFailedToLoad extends StatelessWidget {
  const PokeAPIFailedToLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Gap(75),
        SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/search/not_found.png',
              fit: BoxFit.cover,
            )),
        const Gap(20),
        Text('Failed API Retrieval', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const Gap(20),
        Text('Sorry, the PokéAPI could not be reached. Please check your internet connection and try again.',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }
}
