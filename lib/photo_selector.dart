library photo_selector;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 包名
const String _packageName = "photo_selector";

/// 照片数据
class PhotoData extends Object {
  /// 照片数据
  var imageData;

  /// 允许编辑
  bool allowEdit;

  /// 构建照片数据
  PhotoData({
    required this.imageData,
    this.allowEdit = true,
  });
}

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

/// 照片选择器状态
class _PhotoSelectorState extends State<PhotoSelector> {
  /// Build
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: widget._photoSelectorLayout.horizontalSpacing,
      mainAxisSpacing: widget._photoSelectorLayout.verticalSpacing,
      crossAxisCount: widget._photoSelectorLayout.column,
      physics: widget._photoSelectorLayout.scroll
          ? null
          : NeverScrollableScrollPhysics(),
      children: _cells(),
    );
  }

  /// 单元格集合
  List<Widget> _cells() {
    // 单元格集合
    List<Widget> cells = [];

    // 添加PhotoPreviewCell
    widget._photoDatas.forEach((element) {
      _PhotoPreviewData photoPreviewData = _PhotoPreviewData(
        imageData: element.imageData,
        edit: widget._photoSelectorLayout.edit ? element.allowEdit : false,
        onPreview: (data) {
          _preview(element);
        },
        onDelete: (data) {
          widget._photoDatas.remove(element);
          _delete(element);
          setState(() {});
        },
      );
      _PhotoPreviewCell cell = _PhotoPreviewCell(photoPreviewData);
      cells.add(cell);
    });

    // 添加PhotoAddCell
    if (widget._photoSelectorLayout.maxCount != null) {
      int maxCount = widget._photoSelectorLayout.maxCount!;
      int currentCount = widget._photoDatas.length;
      if (maxCount > currentCount) {
        if (widget._photoSelectorLayout.edit) {
          cells.add(_PhotoAddCell(onAdd: _add));
        }
      } else {
        widget._photoDatas.removeRange(maxCount, currentCount);
        cells.removeRange(maxCount, currentCount);
      }
    } else {
      if (widget._photoSelectorLayout.edit) {
        cells.add(_PhotoAddCell(onAdd: _add));
      }
    }
    return cells;
  }

  /// 添加
  _add() {
    widget._photoSelectorHandler.onAdd?.call((photoDatas) {
      if (widget._photoSelectorLayout.maxCount != null) {
        int maxCount =
            widget._photoSelectorLayout.maxCount! - widget._photoDatas.length;
        int currentCount = photoDatas.length;
        if (maxCount > currentCount) {
          widget._photoDatas.addAll(photoDatas);
        } else {
          photoDatas.removeRange(maxCount, photoDatas.length);
          widget._photoDatas.addAll(photoDatas);
        }
      } else {
        widget._photoDatas.addAll(photoDatas);
      }
      setState(() {});
    });
  }

  /// 预览
  _preview(var data) {
    widget._photoSelectorHandler.onPreview?.call(data, widget._photoDatas);
  }

  /// 删除
  _delete(var data) {
    widget._photoSelectorHandler.onDelete?.call(data, widget._photoDatas);
  }
}

/// 照片预览数据
class _PhotoPreviewData extends Object {
  /// 照片数据
  var imageData;

  /// 预览回调
  void Function(_PhotoPreviewData _photoPreviewData)? onPreview;

  /// 删除回调
  void Function(_PhotoPreviewData _photoPreviewData)? onDelete;

  /// 编辑
  bool edit;

  /// 构建照片预览数据
  _PhotoPreviewData({
    required this.imageData,
    this.onPreview,
    this.onDelete,
    this.edit = true,
  });
}

/// 照片预览单元格
class _PhotoPreviewCell extends StatelessWidget {
  /// 照片预览数据
  final _PhotoPreviewData _photoPreviewData;

  /// 构建照片预览单元格
  _PhotoPreviewCell(this._photoPreviewData);

  /// Build
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double deleteImageSize = constraints.maxWidth / 4.5;
      double borderRadius = constraints.maxWidth / 25.5;
      return Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onTap: () {
                _photoPreviewData.onPreview?.call(_photoPreviewData);
              },
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    color: Color.fromRGBO(244, 244, 244, 1),
                    child: _image(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Offstage(
              offstage: !_photoPreviewData.edit,
              child: GestureDetector(
                onTap: () {
                  _photoPreviewData.onDelete?.call(_photoPreviewData);
                },
                child: Image.asset(
                  _ImageAsset().deleteImage,
                  package: _packageName,
                  fit: BoxFit.cover,
                  width: deleteImageSize,
                  height: deleteImageSize,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  /// Image
  Image _image() {
    if (_photoPreviewData.imageData is String) {
      String string = _photoPreviewData.imageData;
      if (string.contains("http")) {
        return Image.network(
          _photoPreviewData.imageData,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          _photoPreviewData.imageData,
          fit: BoxFit.cover,
        );
      }
    } else if (_photoPreviewData.imageData is File) {
      return Image.file(
        _photoPreviewData.imageData,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        _ImageAsset().defaultImage,
        package: _packageName,
        fit: BoxFit.cover,
      );
    }
  }
}

/// 照片添加单元格
class _PhotoAddCell extends StatelessWidget {
  /// 添加回调
  final void Function()? onAdd;

  /// Build
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double addImageSize = constraints.maxWidth / 3.0;
        double addTextSize = constraints.maxWidth / 9.0;
        double borderRadius = constraints.maxWidth / 25.5;
        double addTextTop = constraints.maxWidth / 27.8;
        return GestureDetector(
          onTap: onAdd,
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                color: Color.fromRGBO(244, 244, 244, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        _ImageAsset().cameraImage,
                        package: _packageName,
                        width: addImageSize,
                        height: addImageSize,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: addTextTop),
                      child: Text(
                        '添加照片',
                        style: TextStyle(
                            fontSize: addTextSize, color: Color(0xff999999)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建图片添加
  _PhotoAddCell({required this.onAdd});
}

/// Image资源
class _ImageAsset {
  final String cameraImage = "images/photo_selector_camera.png";
  final String defaultImage = "images/photo_selector_default.png";
  final String deleteImage = "images/photo_selector_delete.png";
}
