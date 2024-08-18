import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code/models/product/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Product>> streamProducts() async* {
    yield* firebaseFirestore
        .collection('products')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAddProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingAdd());

        var result = await firebaseFirestore.collection('products').add({
          'code': event.code,
          'name': event.name,
          'quantity': event.quantity,
        });

        await firebaseFirestore
            .collection('products')
            .doc(result.id)
            .update({'productId': result.id});

        emit(ProductStateCompleteAdd());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? 'Tidak dapat menambah product'));
      } catch (e) {
        emit(ProductStateError('Tidak dapat menambah product'));
      }
    });
    on<ProductEventEditProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingEdit());

        await firebaseFirestore
            .collection('products')
            .doc(event.productId)
            .update({
          'code': event.code,
          'name': event.name,
          'quantity': event.quantity,
        });

        emit(ProductStateCompleteEdit());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? 'Tidak dapat mengupdate product'));
      } catch (e) {
        emit(ProductStateError('Tidak dapat mengupdate product'));
      }
    });
    on<ProductEventDeleteProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingDelete());

        await firebaseFirestore
            .collection('products')
            .doc(event.productId)
            .delete();

        emit(ProductStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? 'Tidak dapat mendelete product'));
      } catch (e) {
        emit(ProductStateError('Tidak dapat mendelete product'));
      }
    });
    on<ProductEventExportToPdfProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingExport());

        var querySnap = await firebaseFirestore
            .collection('products')
            .withConverter<Product>(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();

        List<Product> products = [];

        for (var product in querySnap.docs) {
          products.add(product.data());
        }

        final pdf = pw.Document();

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              List<pw.TableRow> allData = List.generate(
                products.length,
                (index) {
                  Product product = products[index];
                  return pw.TableRow(
                    children: [
                      // No
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "${index + 1}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // Kode Barang
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          product.code!,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // Nama Barang
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          product.name!,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // Qty
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "${product.qty}",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // QR Code
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.BarcodeWidget(
                          color: PdfColor.fromHex("#000000"),
                          barcode: pw.Barcode.qrCode(),
                          data: product.code!,
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ],
                  );
                },
              );

              return [
                pw.Center(
                  child: pw.Text(
                    "CATALOG PRODUCTS",
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColor.fromHex("#000000"),
                    width: 2,
                  ),
                  children: [
                    pw.TableRow(
                      children: [
                        // No
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "No",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        // Kode Barang
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Product Code",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        // Nama Barang
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Product Name",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        // Qty
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Quantity",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        // QR Code
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "QR Code",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...allData,
                  ],
                ),
              ];
            },
          ),
        );

        Uint8List bytes = await pdf.save();

        final dir = await getApplicationDocumentsDirectory();
        File file = File('${dir.path}/myproducts.pdf');

        await file.writeAsBytes(bytes);

        await OpenFile.open(file.path);

        emit(ProductStateCompleteExport());
      } on FirebaseException catch (e) {
        emit(ProductStateError(
            e.message ?? 'Tidak dapat mengexport ke pdf product'));
      } catch (e) {
        emit(ProductStateError('Tidak dapat mengexport ke pdf product'));
      }
    });
  }
}
