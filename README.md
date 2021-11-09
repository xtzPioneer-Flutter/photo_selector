# photo_selector
一个Flutter轻量级的照片选择器
## 功能介绍
* 类似微信朋友圈九宫格照片预览器
* 可编辑的照片选择器
* 可设置水平间距、垂直间距
* 可设置列数
* 可设置是否可滚动
* 可设置是否可编辑
* 可设置最大数量

## 添加依赖

```yaml
dependencies:
  photo_selector: ^0.0.1
```
## 照片控制器
```dart
/// 照片选择器
class PhotoSelector extends StatefulWidget {
  /// 照片数据集合
  List<PhotoData> _photoDatas = [];

  /// 照片选择器布局
  final PhotoSelectorLayout _photoSelectorLayout = PhotoSelectorLayout();

  /// 照片选择器回调处理
  final PhotoSelectorHandler _photoSelectorHandler = PhotoSelectorHandler();

  /// 创建状态
  @override
  State<StatefulWidget> createState() => _PhotoSelectorState();

  /// 构造照片选择器
  PhotoSelector({
    required List<PhotoData> photoDatas,
    void Function(PhotoSelectorLayout photoSelectorLayout)? photoSelectorLayout,
    void Function(PhotoSelectorHandler photoSelectorHandler)?
        photoSelectorHandler,
  }) {
    _photoDatas = photoDatas;
    photoSelectorLayout?.call(_photoSelectorLayout);
    photoSelectorHandler?.call(_photoSelectorHandler);
  }
}
```
## 布局类
```dart
/// 照片选择器布局
class PhotoSelectorLayout extends Object {
  /// 列数
  int column;

  /// 最大数量
  int? maxCount;

  /// 垂直间距
  double verticalSpacing;

  /// 水平间距
  double horizontalSpacing;

  /// 编辑
  bool edit;

  /// 滚动
  bool scroll;

  /// 构建照片选择器布局
  PhotoSelectorLayout({
    this.column = 3,
    this.horizontalSpacing = 5.0,
    this.verticalSpacing = 5.0,
    this.edit = true,
    this.scroll = true,
  });
}
```
## 处理类
```dart
/// 照片选择器处理
class PhotoSelectorHandler extends Object {
  /// 预览回调
  void Function(PhotoData photoData, List<PhotoData> photoDatas)? onPreview;

  /// 删除回调
  void Function(PhotoData photoData, List<PhotoData> photoDatas)? onDelete;

  /// 添加回调
  void Function(void Function(List<PhotoData> photoDatas))? onAdd;

  /// 照片选择器回调处理
  PhotoSelectorHandler({this.onAdd, this.onPreview, this.onDelete});
}
```
## 示例
```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_selector/photo_selector.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  List<PhotoData> photos = [
    PhotoData(
      allowEdit: false,
      imageData:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F18%2F08%2F24%2F05dbcc82c8d3bd356e57436be0922357.jpg&refer=http%3A%2F%2Fbpic.588ku.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637479550&t=8c5f21b7a3e516e74eba3b72fb63ecce",
    ),
    PhotoData(
      imageData:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage66.360doc.com%2FDownloadImg%2F2013%2F11%2F0708%2F36512556_53.jpg&refer=http%3A%2F%2Fimage66.360doc.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637563329&t=cd4c36d777fa2d5cc3c60ce866a22a9a",
    ),
    PhotoData(
      imageData:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.nipic.com%2F2009-02-26%2F2009226195511805_2.jpg&refer=http%3A%2F%2Fpic1.nipic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637563329&t=f21cc4dc3226c429adf45909367080fb",
    ),
    PhotoData(
      imageData:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic14.nipic.com%2F20110512%2F6202394_223408457128_2.jpg&refer=http%3A%2F%2Fpic14.nipic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637563329&t=91c41dd3c8338e63a489624fa35b7e3e",
    ),
    PhotoData(
      imageData:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.daimg.com%2Fuploads%2Fallimg%2F140628%2F3-14062Q52P5.jpg&refer=http%3A%2F%2Fimg.daimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637563329&t=0f16a592da1207bb234640b533c83e84",
    ),
    PhotoData(
      imageData:
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic24.nipic.com%2F20121031%2F369125_100510566000_2.jpg&refer=http%3A%2F%2Fpic24.nipic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637563329&t=7ed4c46b4b734829db15299d351b613b",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('照片选择器'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: PhotoSelector(
          photoDatas: photos,
          photoSelectorLayout: (layout) {
            layout.edit = false;
            layout.maxCount = 9;
            layout.scroll = true;
            layout.horizontalSpacing = 5.0;
            layout.verticalSpacing = 5.0;
            layout.column = 3;
          },
          photoSelectorHandler: (handler) {
            handler.onAdd = (add) {
              ImagePicker().pickMultiImage().then((value) {
                List<PhotoData> photoDatas = [];
                value?.forEach((element) {
                  PhotoData photoData = PhotoData(
                    imageData: File(element.path),
                  );
                  photoDatas.add(photoData);
                });
                add(photoDatas);
                print("添加后的照片数量：${photos.length}");
              });
            };
            handler.onDelete = (data, datas) {
              print("删除的照片数据：${data.imageData}");
              print("删除后的照片数量：${datas.length}");
            };
            handler.onPreview = (data, datas) {
              print("当前预览的照片数据：${data.imageData}");
              print("当前预览的照片索引：${datas.indexOf(data)}");
              print("预览的照片数量：${datas.length}");
            };
          },
        ),
      ),
    );
  }
}
```
## 预览
![image](https://github.com/xtzPioneer/photo_selector/blob/main/project_preview/photo_selector_preview2.png?raw=true)
![image](https://github.com/xtzPioneer/photo_selector/blob/main/project_preview/photo_selector_preview3.png?raw=true)
![image](https://github.com/xtzPioneer/photo_selector/blob/main/project_preview/photo_selector_preview1.png?raw=true)
