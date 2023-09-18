import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthState {
  bool loggedIn = false;
  String? token;
  String? id;
  String name = "Anônimo";
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void logout() {
    state = AuthState();
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      var token = await BonAppetitApiService().postLoginWithEmailAndPassword(email, password);
      var s = AuthState();
      s.loggedIn = true;
      s.token = token;
      s.id = token;
      s.name = "Autenticado";
      state = s;

      // var decoded = JwtDecoder.decode(token);
      // print(decoded);
    } catch (e) {
      throw Exception('Erro ao realizar o login');
    }
  }

  Future<bool> registerWithEmailAndPassword(String email, String password) async {
    try {
      var success = await BonAppetitApiService().postRegisterWithEmailAndPassword(email, password);
      return success;
    } catch (e) {
      throw Exception('Erro ao realizar o registro');
    }
  }

}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>(
        (ref) => AuthNotifier());
