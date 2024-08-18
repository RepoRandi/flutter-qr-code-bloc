import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code/blocs/product/product_bloc.dart';
import 'package:qr_code/routes/router.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({Key? key}) : super(key: key);

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
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
          const SizedBox(height: 20.0),
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
              if (codeC.text.length == 10) {
                context.read<ProductBloc>().add(ProductEventAddProduct(
                    code: codeC.text,
                    name: nameC.text,
                    quantity: int.tryParse(qtyC.text) ?? 0));
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Code product must 10 characters')),
                  );
                });
              }
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
                if (state is ProductStateCompleteAdd) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Product dengan nama: ${nameC.text} berhasil ditambahkan')),
                    );
                  });
                  context.pop();
                }
              },
              builder: (context, state) {
                if (state is ProductStateLoadingAdd) {
                  return const CircularProgressIndicator();
                }

                return const Text('Add Product');
              },
            ),
          )
        ],
      ),
    );
  }
}
