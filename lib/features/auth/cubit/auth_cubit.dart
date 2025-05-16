import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void getUserData() async {
    emit(AuthLoading());
    final user = _auth.currentUser;
    if (user != null) {
      emit(AuthLoggedIn(user.email ?? ''));
    } else {
      emit(AuthInitial());
    }
  }

  void signUp({required String name, required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthLoggedIn(email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}