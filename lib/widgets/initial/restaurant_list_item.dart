import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantListItem extends ConsumerWidget {
  const RestaurantListItem(
      {super.key, required this.restaurant, required this.onSelectRestaurant});

  final DiscoveryRestaurant restaurant;
  final Function(String restaurantId) onSelectRestaurant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () => onSelectRestaurant(restaurant.id),
        child: Column(
          children: [
            // FadeInImage(
            //   placeholder: MemoryImage(kTransparentImage),
            //   image: NetworkImage(Uri.https("placehold.co", "/600x400/png",
            //       {"text": restaurant.title}).toString()),
            //   fit: BoxFit.cover,
            //   height: 100,
            //   width: double.infinity,
            // ),
            Image.asset(
              'images/specialties/${restaurant.specialty}.png',
              fit: BoxFit.cover,
              height: 120,
              width: double.infinity,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              color: Colors.white,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(restaurant.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(specialtyDescription(restaurant.specialty)),
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
