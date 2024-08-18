import 'package:flutter/material.dart';
import 'package:qr_code/blocs/bloc.dart';
import 'package:qr_code/models/product/product.dart';
import 'package:qr_code/routes/router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailProductPage extends StatelessWidget {
  DetailProductPage(
      {super.key, required this.productId, required this.product});

  final String productId;
  final Product product;

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code!;
    nameC.text = product.name!;
    qtyC.text = product.qty.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: product.code!,
                ),
              )
            ],
          ),
          const SizedBox(height: 20.0),
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: 'Product Code',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Product Name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Product Quantity',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<ProductBloc>().add(ProductEventEditProduct(
                  productId: productId,
                  code: codeC.text,
                  name: nameC.text,
                  quantity: int.tryParse(qtyC.text) ?? 0));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  });
                }
                if (state is ProductStateCompleteEdit) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Product dengan nama: ${nameC.text} berhasil diupdate')),
                    );
                  });
                }
              },
              builder: (context, state) {
                if (state is ProductStateLoadingEdit) {
                  return const CircularProgressIndicator();
                }

                return const Text('Update Product');
              },
            ),
          ),
          const SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              context
                  .read<ProductBloc>()
                  .add(ProductEventDeleteProduct(productId: productId));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateCompleteDelete) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Product dengan nama: ${nameC.text} berhasil dihapus')),
                    );
                  });
                  context.pop();
                }
              },
              builder: (context, state) {
                if (state is ProductStateLoadingDelete) {
                  return const CircularProgressIndicator();
                }
                if (state is ProductStateError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  });
                }
                return const Text(
                  'Delete Product',
                  style: TextStyle(color: Colors.redAccent),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
