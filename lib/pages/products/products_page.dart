import 'package:flutter/material.dart';
import 'package:qr_code/blocs/bloc.dart';
import 'package:qr_code/blocs/product/product_bloc.dart';
import 'package:qr_code/models/product/product.dart';
import 'package:qr_code/routes/router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductBloc productBloc = context.read<ProductBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products'),
        actions: const [],
      ),
      body: StreamBuilder(
        stream: productBloc.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Tidak dapat mengambil data'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          List<Product> products = [];

          for (var product in snapshot.data!.docs) {
            products.add(product.data());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 20.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    context.goNamed(
                      Routes.detailProduct,
                      pathParameters: {
                        "productId": product.productId!,
                      },
                      extra: product,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.code!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5.0),
                              Text(product.name!),
                              Text('Stok: ${product.qty!}')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            data: product.code!,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
