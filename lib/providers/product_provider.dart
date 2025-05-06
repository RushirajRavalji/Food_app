import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_app/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  late ProductModel productModel;

  List<ProductModel> search = [];
  productModels(QueryDocumentSnapshot element) {
    productModel = ProductModel(
      productImage: element.get("productImage") as String,
      productName: element.get("productName") as String,
      productPrice: element.get("productPrice") as int,
      productId: element.get("productId") as String,
      productUnit: element.get("productUnit") as List<dynamic>,
      productQuantity: 1,
    );
    search.add(productModel);
  }

  // Add dummy data method
  void addDummyData() {
    // Add herbs products
    _addDummyHerbsProducts();

    // Add fresh fruits
    _addDummyFreshProducts();

    // Add root vegetables
    _addDummyRootProducts();

    // Add all products to search list
    search = [...herbsProductList, ...freshProductList, ...rootProductList];
    notifyListeners();
  }

  /////////////// herbsProduct ///////////////////////////////
  List<ProductModel> herbsProductList = [];

  // Original Firebase method
  Future<void> fatchHerbsProductData() async {
    // Check if we already have dummy data
    if (herbsProductList.isNotEmpty) {
      return;
    }

    try {
      // Try to fetch from Firebase
      List<ProductModel> newList = [];
      QuerySnapshot value =
          await FirebaseFirestore.instance.collection("HerbsProduct").get();

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          productModels(element);
          newList.add(productModel);
        }
        herbsProductList = newList;
      } else {
        // If no data from Firebase, use dummy data
        _addDummyHerbsProducts();
      }
    } catch (e) {
      // On error, use dummy data
      print("Error fetching herbs data: $e");
      _addDummyHerbsProducts();
    }

    notifyListeners();
  }

  // Add dummy herbs products
  void _addDummyHerbsProducts() {
    herbsProductList = [
      ProductModel(
        productId: "Herb1",
        productImage: "lib/assets/herbs/basil.jpg", // Updated path
        productName: "Fresh Basil",
        productPrice: 12,
        productUnit: ["50g", "100g", "150g", "250g"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Herb2",
        productImage: "lib/assets/herbs/mint.jpg", // Updated path
        productName: "Mint Leaves",
        productPrice: 8,
        productUnit: ["50g", "100g", "150g"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Herb3",
        productImage: "lib/assets/herbs/thyme.jpg", // Updated path
        productName: "Thyme",
        productPrice: 10,
        productUnit: ["50g", "100g"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Herb4",
        productImage: "lib/assets/herbs/rosemary.jpg", // Updated path
        productName: "Rosemary",
        productPrice: 15,
        productUnit: ["50g", "100g", "150g"],
        productQuantity: 1,
      ),
    ];
  }

  List<ProductModel> get getHerbsProductDataList {
    return herbsProductList;
  }

  //////////////// Fresh Product ///////////////////////////////////////

  List<ProductModel> freshProductList = [];

  Future<void> fatchFreshProductData() async {
    // Check if we already have dummy data
    if (freshProductList.isNotEmpty) {
      return;
    }

    try {
      // Try to fetch from Firebase
      List<ProductModel> newList = [];
      QuerySnapshot value =
          await FirebaseFirestore.instance.collection("FreshProduct").get();

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          productModels(element);
          newList.add(productModel);
        }
        freshProductList = newList;
      } else {
        // If no data from Firebase, use dummy data
        _addDummyFreshProducts();
      }
    } catch (e) {
      // On error, use dummy data
      print("Error fetching fresh fruits data: $e");
      _addDummyFreshProducts();
    }

    notifyListeners();
  }

  // Add dummy fresh products
  void _addDummyFreshProducts() {
    freshProductList = [
      ProductModel(
        productId: "Fruit1",
        productImage: "lib/assets/fruits/apple.jpg", // Updated path
        productName: "Red Apple",
        productPrice: 20,
        productUnit: ["1Kg", "2Kg", "3Kg", "5Kg"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Fruit2",
        productImage:
            "lib/assets/fruits/Oranges.jpg", // Updated path with correct capitalization
        productName: "Orange",
        productPrice: 15,
        productUnit: ["1Kg", "2Kg", "3Kg"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Fruit3",
        productImage: "lib/assets/fruits/strawberry.jpg", // Updated path
        productName: "Strawberry",
        productPrice: 30,
        productUnit: ["250g", "500g", "1Kg"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Fruit4",
        productImage: "lib/assets/fruits/banana.jpg", // Updated path
        productName: "Banana",
        productPrice: 10,
        productUnit: ["1 Dozen", "2 Dozen"],
        productQuantity: 1,
      ),
    ];
  }

  List<ProductModel> get getFreshProductDataList {
    return freshProductList;
  }

  //////////////// Root Product ///////////////////////////////////////

  List<ProductModel> rootProductList = [];

  Future<void> fatchRootProductData() async {
    // Check if we already have dummy data
    if (rootProductList.isNotEmpty) {
      return;
    }

    try {
      // Try to fetch from Firebase
      List<ProductModel> newList = [];
      QuerySnapshot value =
          await FirebaseFirestore.instance.collection("RootProduct").get();

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          productModels(element);
          newList.add(productModel);
        }
        rootProductList = newList;
      } else {
        // If no data from Firebase, use dummy data
        _addDummyRootProducts();
      }
    } catch (e) {
      // On error, use dummy data
      print("Error fetching root vegetables data: $e");
      _addDummyRootProducts();
    }

    notifyListeners();
  }

  // Add dummy root products
  void _addDummyRootProducts() {
    rootProductList = [
      ProductModel(
        productId: "Root1",
        productImage: "lib/assets/roots/potato.jpg", // Updated path
        productName: "Potato",
        productPrice: 8,
        productUnit: ["1Kg", "2Kg", "5Kg"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Root2",
        productImage: "lib/assets/roots/carrot.jpg", // Updated path
        productName: "Carrot",
        productPrice: 12,
        productUnit: ["500g", "1Kg", "2Kg"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Root3",
        productImage: "lib/assets/roots/onion.jpg", // Updated path
        productName: "Onion",
        productPrice: 10,
        productUnit: ["1Kg", "2Kg", "5Kg"],
        productQuantity: 1,
      ),
      ProductModel(
        productId: "Root4",
        productImage:
            "lib/assets/roots/Ginger.jpg", // Updated path with correct capitalization
        productName: "Ginger",
        productPrice: 18,
        productUnit: ["250g", "500g", "1Kg"],
        productQuantity: 1,
      ),
    ];
  }

  List<ProductModel> get getRootProductDataList {
    return rootProductList;
  }

  /////////////////// Search Return ////////////
  List<ProductModel> get getAllProductSearch {
    // Fixed typo: gerAllProductSearch -> getAllProductSearch
    return search;
  }
}
