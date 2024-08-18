import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_code/blocs/bloc.dart';
import 'package:qr_code/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Home'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventLogout());
              },
              icon: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthStateLogout) {
                    context.goNamed(Routes.login);
                  }
                },
                builder: (context, state) {
                  if (state is AuthStateLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const Icon(
                    Icons.logout,
                  );
                },
              ),
            ),
          ],
        ),
        body: GridView.builder(
          itemCount: 4,
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final random = Random();

            String? title;
            IconData? icon;
            VoidCallback? onTap;

            switch (index) {
              case 0:
                title = 'Add Product';
                icon = Icons.post_add_rounded;
                onTap = () => context.goNamed(Routes.addProduct);
                break;

              case 1:
                title = 'Products';
                icon = Icons.list_alt_outlined;
                onTap = () => context.goNamed(Routes.products);
                break;

              case 2:
                title = 'QR Code';
                icon = Icons.qr_code;
                onTap = () {};
                break;

              default:
                title = 'Catalog';
                icon = Icons.document_scanner_outlined;
                onTap = () {
                  context
                      .read<ProductBloc>()
                      .add(ProductEventExportToPdfProduct());
                };
                break;
            }
            return Material(
              color: Color.fromARGB(
                255,
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
              ),
              child: InkWell(
                onTap: onTap,
                child: (index == 3)
                    ? BlocConsumer<ProductBloc, ProductState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if (state is ProductStateLoadingExport) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                icon,
                                size: 50,
                              ),
                              const SizedBox(height: 10.0),
                              Text(title!),
                            ],
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 50,
                          ),
                          const SizedBox(height: 10.0),
                          Text(title),
                        ],
                      ),
              ),
            );
          },
        ));
  }
}
