import 'package:flutter/material.dart';
import 'package:qr_code/routes/router.dart';

import '../../blocs/bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailC =
      TextEditingController(text: 'admin@qr.com');
  final TextEditingController passC = TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login Page'),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
                children: [
                  const Text('Email'),
                  const SizedBox(height: 5.0),
                  TextField(
                    autocorrect: false,
                    controller: emailC,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Password'),
                  const SizedBox(height: 5.0),
                  TextField(
                    autocorrect: false,
                    controller: passC,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthEventLogin(
                              email: emailC.text,
                              password: passC.text,
                            ));
                      },
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthStateLogin) {
                            context.goNamed(Routes.home);
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthStateLoading) {
                            return const CircularProgressIndicator();
                          }
                          if (state is AuthStateError) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            });
                          }
                          return const Text('Login');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun?'),
                      const SizedBox(width: 5.0),
                      TextButton(
                        onPressed: () {
                          context.goNamed(Routes.register);
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
