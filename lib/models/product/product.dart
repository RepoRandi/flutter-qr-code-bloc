class Product {
  String? productId;
  String? code;
  String? name;
  int? qty;

  Product({
    this.productId,
    this.code,
    this.name,
    this.qty,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"] ?? "",
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        qty: json["quantity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "code": code,
        "name": name,
        "qty": qty,
      };
}
