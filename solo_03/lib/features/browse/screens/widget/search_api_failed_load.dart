import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:solo_03/features/browse/screens/browse_screen.dart';
import 'package:solo_03/features/browse/controller/search_controller.dart';

class PokeAPIFailedToLoad extends StatelessWidget {
  const PokeAPIFailedToLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPokemonController());

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
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        const Gap(75),
        TextButton(onPressed: () {
          // Retry fetching data from the API by re-initializing the controller
          // and navigate back to the app's Home (first) route.
          controller.fetchedAPIItems.value = false;
          controller.fetchInitialData();

          // Go to the Home screen by popping all routes until the first.
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0)
            ),
          ),
        ),
        child: Text(
          "Retry",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
          ),
        ),
      ],
    );
  }
}
