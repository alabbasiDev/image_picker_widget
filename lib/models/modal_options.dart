part of image_picker_widget;

class ModalOptions {
  final Widget? title;
  final Widget? cameraText;
  final Widget? galleryText;
  final IconData? cameraIcon;
  final IconData? galleryIcon;
  final double? cameraSize;
  final double? gallerySize;
  final Color? cameraColor;
  final Color? galleryColor;
  final EdgeInsetsGeometry? margin;

  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;

  Color? bgColor;

  ModalOptions({
    this.title,
    this.cameraText,
    this.galleryText,
    this.cameraIcon,
    this.galleryIcon,
    this.cameraSize,
    this.gallerySize,
    this.cameraColor,
    this.galleryColor,
    this.margin,
    this.padding,
    this.borderRadius,
    this.bgColor,
  });
}
