import '../../../models/sub_category.dart';
import '../provider/sub_category_provider.dart';
import '../../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../models/category.dart';
import '../../../utility/constants.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class SubCategorySubmitForm extends StatelessWidget {
  final SubCategory? subCategory;

  const SubCategorySubmitForm({super.key, this.subCategory});

  @override
  Widget build(BuildContext context) {
    context.subCategoryProvider.setDataForUpdateSubCategory(subCategory);

    //MediaQuery 用来取得当前应用的媒体信息,如屏幕尺寸,设备方向和文本缩放
    //跟设备相关的就用这个
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Form(
        key: context.subCategoryProvider.addSubCategoryFormKey,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          //让这个页面大小为设备宽度的0.5
          width: size.width * 0.5,
          //可以但没必要，会自动设置height  height: size.height * 0.03,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(defaultPadding),
              Row(
                children: [
                  Expanded(
                    child: Consumer<SubCategoryProvider>(
                      builder: (context, subCatProvider, child) {
                        //下拉列表
                        return CustomDropdown(
                          initialValue: subCatProvider.selectedCategory,
                          //若未选中则hitText为Select Category
                          hintText: subCatProvider.selectedCategory?.name ??
                              'Select category',
                          items: context.dataProvider.categories,
                          //防御性,这里可以把name改成id,这是display
                          displayItem: (Category? category) =>
                              category?.name ?? '',
                          onChanged: (newValue) {
                            //当选取,provider中selectedCategor被赋值
                            if (newValue != null) {
                              subCatProvider.selectedCategory = newValue;
                              //也就是notifyListeners,如果以后要扩展,这是很好的方法
                              subCatProvider.updateUi();
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller:
                          context.subCategoryProvider.subCategoryNameCtrl,
                      labelText: 'Sub Category Name',
                      onSave: (val) {
                        //TODO: ??
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a sub category name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Gap(defaultPadding * 2),
              Row(
                //mainAxisAlignment ,自动适配Row和Colum,还有个crossAxisAlignment
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: Text('Cancel'),
                  ),
                  Gap(defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context.subCategoryProvider.addSubCategoryFormKey
                          .currentState!
                          .validate()) {
                        //TODO: key是用来save的,但save的什么?
                        context.subCategoryProvider.addSubCategoryFormKey
                            .currentState!
                            .save();
                        //不需要参数,要存的数据都存在provider里呢,被Controller控制
                        context.subCategoryProvider.submitSubCategory();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// How to show the category popup
void showAddSubCategoryForm(BuildContext context, SubCategory? subCategory) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
            child: Text('Add Sub Category'.toUpperCase(),
                style: TextStyle(color: primaryColor))),
        content: SubCategorySubmitForm(subCategory: subCategory),
      );
    },
  );
}
