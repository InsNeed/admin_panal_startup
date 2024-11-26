import 'package:admin/main.dart';
import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/add_category_form.dart';
import 'components/category_header.dart';
import 'components/category_list_section.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //SafeArea确保UI不会被系统的状态栏、导航栏、圆角屏幕等覆盖。
    //它会自动为设备的 "安全区域" 添加合适的边距，保证内容的可见性和不被遮挡。
    return SafeArea(
      child: SingleChildScrollView(
        //开启滚动
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            CategoryHeader(),
            SizedBox(height: defaultPadding),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        //水平Row,end表示贴近末尾
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //Expanded会尽可能填充这一行
                          //如果去掉只剩下Text，那么Text会和后面的全挤在这行的最后面
                          Expanded(
                            child: Text(
                              "My Categories",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding,
                              ),
                            ),
                            onPressed: () {
                              showAddCategoryForm(context, null);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add New"),
                          ),
                          Gap(20),
                          IconButton(
                              onPressed: () {
                                //showSnack is True
                                context.dataProvider.getAllCategory(showSnack: true);
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ),
                      //AddNew的行在这里结束了
                      //Gap是一个包里的,简化了sizedbox
                      Gap(defaultPadding),
                      CategoryListSection(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
