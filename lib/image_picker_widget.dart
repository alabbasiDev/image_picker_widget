library image_picker_widget;

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_widget/functions/extensions.dart';
import 'package:logger/logger.dart';

part 'components/modal_image_selector.dart';

part 'enum/image_picker_widget_shape.dart';

part 'models/cropped_image_options.dart';

part 'models/image_picker_options.dart';

part 'models/bottom_sheet.dart';

part 'models/modal_options.dart';

part 'functions/crop_image.dart';

part 'functions/change_image.dart';


final  logger =  Logger() ;

class ImagePickerWidget extends StatefulWidget {
  /// The diameter of the container in which the image is contained
  final double diameter;

  /// The shape of the widget [square or circle]
  final ImagePickerWidgetShape shape;

  /// How the image should be inscribed into the box.
  ///
  /// The default is [BoxFit.scaleDown] if [centerSlice] is null, and
  /// [BoxFit.fill] if [centerSlice] is not null.
  ///
  /// See the discussion at [paintImage] for more details.
  final BoxFit? fit;

  /// The initial image to be displaied, can be an `ImageProvider`,
  /// `File` or a `external url (String)`
  final dynamic initialImage;

  /// Checks whether the image can be changed
  final bool isEditable;

  /// Case the image can be changed, this function will be called after the change
  final void Function(File)? onChange;
  final Color? backgroundColor;
  final Radius borderRadius;
  final Widget? editIcon;
  final AlignmentGeometry? iconAlignment;

  final IndexedWidgetPickerBuilder? imagePickerModal;

  final ModalOptions? modalOptions;

  /// Image picker params
  final ImagePickerOptions? imagePickerOptions;

  /// Defines if the image can be edited
  final bool shouldCrop;
  final double? width;
  final double? height;

  /// Image editing params
  final CroppedImageOptions? croppedImageOptions;

  final ImageSource? mandatoryImageSource;

  const ImagePickerWidget({
    Key? key,
    required this.diameter,
    this.initialImage,
    this.isEditable = false,
    this.shouldCrop = false,
    this.onChange,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderRadius = const Radius.circular(8),
    this.shape = ImagePickerWidgetShape.circle,
    this.iconAlignment,
    this.editIcon,
    this.fit,
    this.imagePickerModal,
    this.modalOptions,
    this.croppedImageOptions,
    this.imagePickerOptions,
    this.mandatoryImageSource,
  })  : assert(
            (initialImage is String ||
                initialImage is File ||
                initialImage is ImageProvider ||
                initialImage == null),
            'initialImage must be an String, ImageProvider, or File'),
        super(key: key);

  @override
  _ImagePickerWidgetState createState() =>
      _ImagePickerWidgetState(this.initialImage);

  static Future<ImageSource?> selectSourceModal(BuildContext context,
      {ModalOptions? options}) async {
    return showModalBottomSheet<ImageSource?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ModalImageSelector(options),
    );
  }
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  dynamic image;

  _ImagePickerWidgetState(this.image);

  double? get height {
    return widget.shape == ImagePickerWidgetShape.circle
        ? widget.diameter
        : widget.height;
  }

  double? get width {
    return widget.shape == ImagePickerWidgetShape.circle
        ? widget.diameter
        : widget.width;
  }

  bool hasError = false;

  void onHasErrorListener(error) {
    logger.e(error.toString());
    setState(() {
      hasError = true;
    });
  }

  /// Analysis if the image is a `File`, an external `url` or null
  DecorationImage? _image() {
    BoxFit _fit = widget.fit ?? (kIsWeb ? BoxFit.contain : BoxFit.cover);

    if (image is ImageProvider) {
      return DecorationImage(image: image, fit: _fit);
    }

    if (image is File) {
      if (kIsWeb) {
        return DecorationImage(image: NetworkImage(image.path), fit: _fit);
      }
      return DecorationImage(
        image: FileImage(
          image,
        ),
        fit: _fit,
      );
    }

    if (image != null && image is String && image.isNotNullOrEmpty) {
      late ImageProvider imageProvider;
      logger.e('isBase64 isBase64 => ${image.toString().isBase64}');
      if (image.toString().isBase64) {
        var decoded = base64Decode(image);
        imageProvider = MemoryImage(decoded);
      } else {
        imageProvider = CachedNetworkImageProvider(
          widget.initialImage,
          errorListener: onHasErrorListener,
        );
      }
      return DecorationImage(
        image: imageProvider,
        fit: _fit,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _editMode(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.grey[500],
          borderRadius: BorderRadius.all(
            (widget.shape == ImagePickerWidgetShape.circle
                ? Radius.circular(999)
                : widget.borderRadius),
          ),
          image: _image(),
        ),
        child: hasError && image is String
            ? Icon(
                Icons.camera_alt_outlined,
                size: height,
              )
            : null,
      ),
    );
  }

  Widget _editMode({required Widget child}) {
    if (widget.isEditable)
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Widget modal = ModalImageSelector(widget.modalOptions);
            if (widget.imagePickerModal != null) {
              modal = widget.imagePickerModal!(
                  context,
                  (context) => Navigator.of(context).pop(ImageSource.camera),
                  (context) => Navigator.of(context).pop(ImageSource.gallery));
            }
            changeImage(
              context,
              modal,
              widget.shouldCrop,
              widget.croppedImageOptions,
              widget.imagePickerOptions,
              mandatoryImageSource: widget.mandatoryImageSource,
            ).then((file) {
              if (file != null) {
                if (widget.onChange != null) {
                  widget.onChange!(file);
                }
                setState(() {
                  image = file;
                });
              }
            });
          },
          child: Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                child,
                Align(
                  alignment: widget.iconAlignment ?? Alignment.bottomLeft,
                  child: widget.editIcon ??
                      Card(
                        shape: CircleBorder(),
                        color: Colors.grey[700],
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child:
                              Icon(Icons.edit, size: 22, color: Colors.white),
                        ),
                      ),
                )
              ],
            ),
          ),
        ),
      );
    return child;
  }
}
