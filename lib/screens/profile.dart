import 'package:bon_appetit_app/providers/auth_provider.dart';
import 'package:bon_appetit_app/screens/auth.dart';
import 'package:bon_appetit_app/screens/profile/profile_edit.dart';
import 'package:bon_appetit_app/screens/profile/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var profile = ref.watch(authProvider);
    void navigateToRestaurants() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const RestaurantsScreen()));
    }

    void navigateToProfileEdit() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const ProfileEditScreen()));
    }

    void navigateToLoginScreen() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const LoginScreen()));
    }
    
    List<Widget> profileOptions = [
      ListTile(
        onTap: navigateToLoginScreen,
        leading: Icon(Icons.login_outlined,
            color: Theme.of(context).colorScheme.surface),
        title: const Text('Login'),
        trailing: const Icon(Icons.arrow_right_alt, size: 40),
      ),
    ];

    List<Widget> managementOptions = [];

    if (profile.loggedIn) {
      profileOptions = [
        ListTile(
          onTap: navigateToProfileEdit,
          leading: Icon(Icons.info_outline,
              color: Theme.of(context).colorScheme.surface),
          title: const Text('Meu Perfil'),
          trailing: const Icon(Icons.arrow_right_alt, size: 40),
        ),
        ListTile(
          onTap: ref.read(authProvider.notifier).logout,
          leading: Icon(Icons.logout_outlined,
              color: Theme.of(context).colorScheme.surface),
          title: const Text('Logout'),
          trailing: const Icon(Icons.arrow_right_alt, size: 40),
        ),
      ];

      managementOptions = [
        Text('Meus Restaurantes',
            style: Theme.of(context).textTheme.titleLarge),
        ListTile(
          onTap: navigateToRestaurants,
          leading: Icon(Icons.storefront_outlined,
              color: Theme.of(context).colorScheme.surface),
          title: const Text('Restaurantes'),
          trailing: const Icon(Icons.arrow_right_alt, size: 40),
        ),
      ];
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                clipBehavior: Clip.hardEdge,
                surfaceTintColor: Theme.of(context).colorScheme.primary,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Row(children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        alignment: Alignment.center,
                        child: const Icon(Icons.person, size: 40),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá,',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              profile.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ]),
                    )
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Minha Conta',
                      style: Theme.of(context).textTheme.titleLarge),
                  ...profileOptions,
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.settings_outlined,
                        color: Theme.of(context).colorScheme.surface),
                    title: const Text('Configurações'),
                    trailing: const Icon(Icons.arrow_right_alt, size: 40),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...managementOptions
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
