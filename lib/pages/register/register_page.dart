import 'package:flutter/material.dart';
import 'package:qr_code/blocs/bloc.dart';
import 'package:qr_code/routes/router.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register Page'),
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
                        context.read<AuthBloc>().add(AuthEventRegister(
                              email: emailC.text,
                              password: passC.text,
                            ));
                      },
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthStateRegister) {
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
                          return const Text('Register');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun?'),
                      const SizedBox(width: 5.0),
                      TextButton(
                        onPressed: () {
                          context.goNamed(Routes.login);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
