import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateLogout()) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    on<AuthEventRegister>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await firebaseAuth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(AuthStateRegister());
      } on FirebaseAuthException catch (e) {
        emit(AuthStateError('${e.message}'));
      } catch (e) {
        emit(AuthStateError('$e'));
      }
    });
    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await firebaseAuth.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(AuthStateLogin());
      } on FirebaseAuthException catch (e) {
        emit(AuthStateError('${e.message}'));
      } catch (e) {
        emit(AuthStateError('$e'));
      }
    });
    on<AuthEventLogout>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await firebaseAuth.signOut();
        emit(AuthStateLogout());
      } on FirebaseAuthException catch (e) {
        emit(AuthStateError('${e.message}'));
      } catch (e) {
        emit(AuthStateError('$e'));
      }
    });
  }
}
