import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code/models/product/product.dart';
import 'package:qr_code/pages/add_product/add_product_page.dart';
import 'package:qr_code/pages/detail_product/detail_product.dart';
import 'package:qr_code/pages/home/home_page.dart';
import 'package:qr_code/pages/login/login_page.dart';
import 'package:qr_code/pages/products/products_page.dart';
import 'package:qr_code/pages/register/register_page.dart';

export 'package:go_router/go_router.dart';

part 'name_router.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: globalNavigatorKey,
  redirect: (BuildContext context, GoRouterState state) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if (firebaseAuth.currentUser == null) {
      return '/login';
    } else {
      return null;
    }
  },
  errorBuilder: (BuildContext context, GoRouterState state) => Container(),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(
          name: Routes.addProduct,
          path: 'add-product',
          builder: (BuildContext context, GoRouterState state) =>
              AddProductPage(),
        ),
        GoRoute(
          name: Routes.products,
          path: 'products',
          builder: (BuildContext context, GoRouterState state) =>
              const ProductsPage(),
          routes: [
            GoRoute(
              name: Routes.detailProduct,
              path: ':productId',
              builder: (context, state) => DetailProductPage(
                productId: state.pathParameters['productId'].toString(),
                product: state.extra as Product,
              ),
            )
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (BuildContext context, GoRouterState state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: Routes.register,
      builder: (BuildContext context, GoRouterState state) => RegisterPage(),
    )
  ],
);
