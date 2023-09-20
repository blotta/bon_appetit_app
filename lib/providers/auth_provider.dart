import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthState {
  bool loggedIn = false;
  String? token;
  String? id;
  String name = "Anônimo";
  String? email;
  String role = "Anonymous";
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void logout() {
    state = AuthState();
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      var response = await BonAppetitApiService().postLoginWithEmailAndPassword(email, password);
      var s = AuthState();
      s.loggedIn = true;
      s.token = response.token;
      s.id = response.id;

      var decoded = JwtDecoder.decode(response.token);

      s.name = decoded['unique_name'];
      s.email = decoded['unique_name'];
      s.role = decoded['role'];

      state = s;
    } catch (e) {
      throw Exception('Erro ao realizar o login');
    }
  }

  Future<bool> registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      await BonAppetitApiService().postRegisterWithEmailAndPassword(name, email, password);
      return true;
    } catch (e) {
      throw Exception('Erro ao registrar usuário');
    }
  }

}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>(
        (ref) => AuthNotifier());
