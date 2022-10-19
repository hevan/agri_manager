import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/product/ProductCycle.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/product/product_cycle_edit_screen.dart';
import 'package:dio/dio.dart';
import 'package:znny_manager/src/utils/constants.dart';

class ProductCycleScreen extends StatefulWidget {
  final int productId;
  final String productName;

  const ProductCycleScreen(
      {Key? key, required this.productId, required this.productName})
      : super(key: key);

  @override
  State<ProductCycleScreen> createState() => _ProductCycleScreenState();
}

class _ProductCycleScreenState extends State<ProductCycleScreen> {
  List<ProductCycle> listData = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    var params = {
      'productId': widget.productId,
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.product_cycle_findAll, "GET",
          queryParameters: params);
      if (retData != null) {
        List<ProductCycle> listTemp =
            (retData as List).map((e) => ProductCycle.fromJson(e)).toList();

        List<ProductCycle> listTree = [];

        for (int i = 0; i < listTemp.length; i++) {
          ProductCycle curTemp = listTemp[i];
          if (null == curTemp.parentId) {
            curTemp.children = [];
            listTree.add(curTemp);
          }
        }

        for (int i = 0; i < listTemp.length; i++) {
          ProductCycle curTemp = listTemp[i];
          if (curTemp.parentId != null) {
            for (int m = 0; m < listTree.length; m++) {
              if (curTemp.parentId == listTree[m].id) {
                listTree[m].children!.add(curTemp);
              }
            }
          }
        }
        setState(() {
          listData = listTree;
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [ElevatedButton(onPressed: toAdd, child: const Text('增加'))],
        ),
        Expanded(
            child: ListView.separated(
                primary: false,
                itemCount: listData.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      height: defaultPadding,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  ProductCycle productCycleTemp = listData[index];

                  return Card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: productCycleTemp.imageUrl != null
                                  ? Image(
                                      image: NetworkImage(
                                          '${HttpApi.host_image}${productCycleTemp.imageUrl}'),
                                      width: 120,
                                      height: 120)
                                  : Center(
                                      child: Image.asset(
                                          'assets/icons/icon_add_image.png'),
                                    ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${productCycleTemp.name}'),
                                  Text('${productCycleTemp.amount}'),
                                  Text('${productCycleTemp.description}'),
                                ],
                              ),
                              flex: 6,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: const Text('编辑'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductCycleEditScreen(
                                                  id: productCycleTemp.id,
                                                  productId: widget.productId,
                                                  productName:
                                                      widget.productName,
                                                )),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    child: const Text('查看'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductCycleEditScreen(
                                                  id: productCycleTemp.id,
                                                  productId: widget.productId,
                                                  productName:
                                                      widget.productName,
                                                )),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    child: const Text('删除'),
                                    onTap: toDelete(productCycleTemp.id),
                                  ),
                                ],
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                        null != productCycleTemp.children
                            ? Column(
                                children: buildItem(productCycleTemp.children!),
                              )
                            : Container(),
                      ],
                    ),
                  );
                })),
      ],
    ));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductCycleEditScreen(
                productId: widget.productId,
                productName: widget.productName,
              )),
    );
  }

  toDelete(int? id) {}

  buildItem(List<ProductCycle> listItem) {
    List<Widget> itemWdiget = [];
    for (int i = 0; i < listItem.length; i++) {
      ProductCycle curTemp = listItem[i];
      itemWdiget.add(SizedBox(
          height: 120,
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child:curTemp.imageUrl != null
                      ? Image(
                      image: NetworkImage(
                          'http://localhost:8080/open/gridfs/${curTemp.imageUrl}'),
                      width: 80,
                      height: 80)
                      : Center(
                    child: Image.asset(
                        'assets/icons/icon_add_image.png'),
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${curTemp.name}'),
                      Text('${curTemp.amount}'),
                      Text('${curTemp.description}'),
                    ],
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: const Text('编辑'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductCycleEditScreen(
                                      id: curTemp.id,
                                      productId: widget.productId,
                                      productName:
                                      widget.productName,
                                    )),
                          );
                        },
                      ),
                      InkWell(
                        child: const Text('查看'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductCycleEditScreen(
                                      id: curTemp.id,
                                      productId: widget.productId,
                                      productName:
                                      widget.productName,
                                    )),
                          );
                        },
                      ),
                      InkWell(
                        child: const Text('删除'),
                        onTap: toDelete(curTemp.id),
                      ),
                    ],
                  ),
                  flex: 2,
                ),
              ],
            ),
          )));
    }

    return itemWdiget;
  }
}
