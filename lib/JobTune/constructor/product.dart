class Product {
  String productID,
      providerID,
      name,
      category,
      price,
      additionalFee,
      totalPrice,
      description,
      expectedDeliveryDays,
      availableDay,
      location,
      postDate,
      status;

  Product(
      {required this.productID,
      required this.providerID,
      required this.name,
      required this.category,
      required this.price,
      required this.additionalFee,
      required this.totalPrice,
      required this.description,
      required this.expectedDeliveryDays,
      required this.availableDay,
      required this.location,
      required this.postDate,
      required this.status});

  Product.fromJson(Map<String, dynamic> productData)
      : productID = productData['product_id'],
        providerID = productData['provider_id'],
        name = productData['name'],
        category = productData['category'],
        price = productData['price'],
        additionalFee =
            productData['additional_fee'], // to show image of topic owner
        totalPrice = productData['total_price'],
        description = productData['description'],
        expectedDeliveryDays = productData['expected_delivery_days'],
        availableDay = productData['available_day'],
        location = productData['location'],
        postDate = productData['post_date'],
        status = productData['status'];
}
