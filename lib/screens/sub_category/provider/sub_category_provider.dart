import 'package:admin/models/api_response.dart';
import 'package:admin/models/brand.dart';
import 'package:admin/utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';

class SubCategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  //key是用来管理表单的,其标识唯一一个表单防止多次新建以及保存之前数据
  //要使用先在Form中: key: addSubCategoryFormKey,
  //然后就可以if (addSubCategoryFormKey.currentState!.validate()){...}
  final addSubCategoryFormKey = GlobalKey<FormState>();

  TextEditingController subCategoryNameCtrl = TextEditingController();
  Category? selectedCategory;
  SubCategory? subCategoryForUpdate;

  SubCategoryProvider(this._dataProvider);

  addSubCategory() async {
    try {
      //这里的string
      Map<String, dynamic> subCategory = {
        'name': subCategoryNameCtrl.text,
        'categoryId': selectedCategory?.sId
      }; //sId代表string
      final response = await service.addItem(
          endpointUrl: 'subCategories', itemData: subCategory);
      if (response.isOk) {
        //fromJson为什么是null?,因为这里不关注body是什么，查看apiResponse,第二个参数是个函数,用来解析的数据的
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllSubCategory();
          //这个notifyListenners不能少，虽然getAllSubCategory里有Notify但那个是通知监听dataProvider的
          //但我们看的页面监听的sub_category Provider
          notifyListeners();
          //log('SubCategoryAdded');
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Error ${response.body['message'] ?? response.statusText}'); //message为空则返回右边的
        }
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An Error Occurred: $e');
      rethrow;
    }
  }

  //? update SubCategory
  updateSubCategory() async {
    try {
      if (subCategoryForUpdate != null) {
        Map<String, dynamic> subCategory = {
          'name': subCategoryNameCtrl.text,
          'categoryId': selectedCategory?.sId
        };
        final Response response = await service.updateItem(
            endpointUrl: 'subCategories',
            itemId: subCategoryForUpdate?.sId ?? '',
            itemData: subCategory);
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            //log('subcategory updated');
            //要更新
            _dataProvider.getAllSubCategory();
            notifyListeners();
          } else {
            //Not success;
            SnackBarHelper.showErrorSnackBar(
                'Filed to update SubCategory ${apiResponse.message}');
          }
        } else {
          //response is not OK
          SnackBarHelper.showErrorSnackBar(
              'Error ${response.body?['message'] ?? response.statusText}');
        }
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An Error Occurred: $e');
      rethrow;
    }
  }

  //? submitSubCategory,用来判断是edit还是new
  submitSubCategory() {
    if (subCategoryForUpdate != null) {
      updateSubCategory();
    } else {
      addSubCategory();
    }
  }

  //? deleteSubCategory
  //需要参数了，这和edit，new 不一样,需要对方的信息
  deleteSubCategory(SubCategory subCategory) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'subCategories', itemId: subCategory.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(
              'SubCategory Deleted Successfully');
          _dataProvider.getAllSubCategory();
          notifyListeners();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error:${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //? 缓存数据
  setDataForUpdateSubCategory(SubCategory? subCategory) {
    if (subCategory != null) {
      subCategoryForUpdate = subCategory;
      subCategoryNameCtrl.text = subCategory.name ?? '';
      selectedCategory = _dataProvider.categories.firstWhereOrNull(
          (element) => element.sId == subCategory.categoryId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    subCategoryNameCtrl.clear();
    selectedCategory = null;
    subCategoryForUpdate = null;
  }

  updateUi() {
    notifyListeners();
  }
}
