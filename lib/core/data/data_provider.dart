import 'dart:convert';

import '../../models/api_response.dart';
import '../../models/coupon.dart';
import '../../models/my_notification.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/variant_type.dart';
import '../../services/http_services.dart';
import '../../utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../models/category.dart';
import '../../models/brand.dart';
import '../../models/sub_category.dart';
import '../../models/variant.dart';

//继承自ChangeNotifier
//内部变量可以调用notifyListeners()
class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<VariantType> _allVariantTypes = [];
  List<VariantType> _filteredVariantTypes = [];
  List<VariantType> get variantTypes => _filteredVariantTypes;

  List<Variant> _allVariants = [];
  List<Variant> _filteredVariants = [];
  List<Variant> get variants => _filteredVariants;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;

  List<Coupon> _allCoupons = [];
  List<Coupon> _filteredCoupons = [];
  List<Coupon> get coupons => _filteredCoupons;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  List<MyNotification> _allNotifications = [];
  List<MyNotification> _filteredNotifications = [];
  List<MyNotification> get notifications => _filteredNotifications;

  //这意味着在出现一个DataProvider对象时候就以及初始化所有内容了
  //在main里第一个被调用
  DataProvider() {
    getAllCategory();
    getAllSubCategory();
    getAllBrands();
    getAllVariantTypes();
    getAllVariants();
    getAllProducts();
    getAllPosters();
    getAllCoupons();
    getAllOrders();
  }

  //TODO: should complete getAllCategory
  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      //Response 类似 IActionResult 或 HttpResponse
      //包括response.head .status .data,这个自动解析了Api的response
      Response response = await service.getItems(endpointUrl: 'categories');
      if (response.isOk) {
        //接口的Response,位于models/api_response,
        ApiResponse<List<Category>> apiResponse =
            //接受俩参数 Factory
            ApiResponse<List<Category>>.fromJson(
          response.body,
          // factory ApiResponse.fromJson(
          // Map<String, dynamic> json,
          // T Function(Object? json)? fromJsonT,
          // ) =>
          (json) =>
              (json as List).map((item) => Category.fromJson(item)).toList(),
        );
        _allCategories = apiResponse.data ?? [];
        _filteredCategories = List.from(_allCategories);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCategories;
  }

  void filterCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredCategories = List.from(_allCategories);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      //可以悬指针于where查看其参数：返回值为bool 的 函数
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<SubCategory>> getAllSubCategory(
      {bool showSnackBar = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'subCategories');
      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse =
            ApiResponse<List<SubCategory>>.fromJson(
          response.body,
          //将json转List, map()=> SubCategory的Fromjson得到的List
          (json) =>
              (json as List).map((item) => SubCategory.fromJson(item)).toList(),
        );
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(_allSubCategories);
        notifyListeners();
        if (showSnackBar == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      }
    } catch (e) {
      print(e);
      if (showSnackBar == false) {
        SnackBarHelper.showSuccessSnackBar(e.toString());
      }
      rethrow;
    }
    return _filteredSubCategories;
  }

  void filterSubCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      //可以悬指针于where查看其参数：返回值为bool 的 函数
      _filteredSubCategories = _allSubCategories.where((subCategory) {
        return (subCategory.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<Brand>> getAllBrands({bool showSnackBar = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'brands');
      if (response.isOk) {
        ApiResponse<List<Brand>> apiResponse =
            ApiResponse<List<Brand>>.fromJson(
          response.body,
          (json) => (json as List).map((item) => Brand.fromJson(item)).toList(),
        );
        _allBrands = apiResponse.data ?? [];
        _filteredBrands = List.from(_allBrands);
        notifyListeners();
        if (showSnackBar == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      }
    } catch (e) {
      print(e);
      if (showSnackBar == false) {
        SnackBarHelper.showSuccessSnackBar(e.toString());
      }
      rethrow;
    }
    return _filteredBrands;
  }

  void filterBrands(String keyword) {
    if (keyword.isEmpty) {
      _filteredBrands = List.from(_allBrands);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredBrands = _allBrands.where((brand) {
        return (brand.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<VariantType>> getAllVariantTypes(
      {bool showSnackBar = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'variantTypes');
      if (response.isOk) {
        ApiResponse<List<VariantType>> apiResponse =
            ApiResponse<List<VariantType>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => VariantType.fromJson(item)).toList(),
        );
        _allVariantTypes = apiResponse.data ?? [];
        _filteredVariantTypes = List.from(_allVariantTypes);
        notifyListeners();
        if (showSnackBar == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      }
    } catch (e) {
      print(e);
      if (!showSnackBar) {
        SnackBarHelper.showErrorSnackBar('An Error Occurred: $e');
      }
      rethrow;
    }
    return _filteredVariantTypes;
  }

  void filterVariantTypes(String keyword) {
    if (keyword.isEmpty) {
      _filteredVariantTypes = List.from(_allVariantTypes);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredVariantTypes = _allVariantTypes.where((variantType) {
        return (variantType.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<Variant>> getAllVariants({bool showSnackBar = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'variants');
      if (response.isOk) {
        ApiResponse<List<Variant>> apiResponse =
            ApiResponse<List<Variant>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Variant.fromJson(item)).toList(),
        );
        _allVariants = apiResponse.data ?? [];
        _filteredVariants = List.from(_allVariants);
        notifyListeners();
        if (showSnackBar == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      }
    } catch (e) {
      print(e);
      if (!showSnackBar) {
        SnackBarHelper.showErrorSnackBar('An Error Occurred: $e');
      }
      rethrow;
    }
    return _filteredVariants;
  }

  void filterVariants(String keyword) {
    if (keyword.isEmpty) {
      _filteredVariants = List.from(_allVariants);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredVariants = _allVariants.where((variant) {
        return (variant.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<Product>> getAllProducts({bool showSnackBar = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'products');
      if (response.isOk) {
        ApiResponse<List<Product>> apiResponse =
            ApiResponse<List<Product>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Product.fromJson(item)).toList(),
        );
        _allProducts = apiResponse.data ?? [];
        _filteredProducts = List.from(_allProducts);
        notifyListeners();
        if (showSnackBar == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
      }
    } catch (e) {
      print(e);
      if (!showSnackBar) {
        SnackBarHelper.showErrorSnackBar('An Error Occurred: $e');
      }
      rethrow;
    }
    return _filteredProducts;
  }

  void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_allProducts);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyWord =
            (product.name ?? '').toLowerCase().contains(lowerKeyword);
        final categoryNameContainsKeyWord = (product.proCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyword) ??
            false);
        final subCategoryNameContainsKeyWord = (product.proSubCategoryId?.name
                ?.toLowerCase()
                .contains(lowerKeyword)) ??
            false;
        return productNameContainsKeyWord ||
            categoryNameContainsKeyWord ||
            subCategoryNameContainsKeyWord;
      }).toList();
      notifyListeners();
    }
  }

  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');
      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse =
            ApiResponse<List<Poster>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Poster.fromJson(item)).toList(),
        );
        _allPosters = apiResponse.data ?? [];
        _filteredPosters = List.from(_allPosters);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredPosters;
  }

  void filterPosters(String keyword) {
    if (keyword.isEmpty) {
      _filteredPosters = List.from(_allPosters);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      //可以悬指针于where查看其参数：返回值为bool 的 函数
      _filteredPosters = _allPosters.where((poster) {
        return (poster.posterName ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  Future<List<Coupon>> getAllCoupons({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'couponCodes');
      if (response.isOk) {
        ApiResponse<List<Coupon>> apiResponse =
            ApiResponse<List<Coupon>>.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Coupon.fromJson(item)).toList(),
        );
        _allCoupons = apiResponse.data ?? [];
        _filteredCoupons = List.from(_allCoupons);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCoupons;
  }

  void filterCoupons(String keyword) {
    if (keyword.isEmpty) {
      _filteredCoupons = List.from(_allCoupons);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredCoupons = _allCoupons.where((coupon) {
        return (coupon.couponCode ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
      notifyListeners();
    }
  }

  //TODO: should complete getAllNotifications

  //TODO: should complete filterNotifications

  Future<List<Order>> getAllOrders({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'orders');
      if (response.isOk) {
        ApiResponse<List<Order>> apiResponse =
            ApiResponse<List<Order>>.fromJson(
          response.body,
          (json) => (json as List).map((item) => Order.fromJson(item)).toList(),
        );
        _allOrders = apiResponse.data ?? [];
        _filteredOrders = List.from(_allOrders);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredOrders;
  }

  void filterOrders(String keyword) {
    if (keyword.isEmpty) {
      _filteredOrders = List.from(_allOrders);
      notifyListeners();
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredOrders = _allOrders.where((order) {
        bool nameMatches =
            (order.userID?.name ?? '').toLowerCase().contains(keyword);
        bool statusMatches =
            (order.orderStatus ?? '').toLowerCase().contains(keyword);
        return nameMatches || statusMatches;
      }).toList();
      notifyListeners();
    }
  }

  //TODO: should complete calculateOrdersWithStatus
  int calculateOrdersWithStatus({String? status}) {
    int totalOrders = 0;
    if (status == null) {
      totalOrders = _allOrders.length;
    } else {
      for (Order order in _allOrders) {
        if (order.orderStatus == status) {
          totalOrders += 1;
        }
      }
    }
    return totalOrders;
  }

  //?
  void filterProductsByQuantity(String productQntType) {
    if (productQntType == 'All Product') {
      _filteredProducts = List.from(_allProducts);
    } else if (productQntType == 'Out of Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity == 0;
      }).toList();
    } else if (productQntType == 'Limited Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null &&
            product.quantity! <= 10 &&
            product.quantity! > 0;
      }).toList();
    } else if (productQntType == 'Other Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity! > 10;
      }).toList();
    } else {
      _filteredProducts = List.from(_allProducts); //防御性
    }
    notifyListeners();
  }

  int calculateProductWithQuantity({int? quantity}) {
    int totalProduct = 0;
    if (quantity == null) {
      totalProduct = _allProducts.length;
    } else {
      for (Product product in _allProducts) {
        if (product.quantity != null && product.quantity! <= quantity) {
          totalProduct += 1;
        }
      }
    }
    return totalProduct;
  }
}
