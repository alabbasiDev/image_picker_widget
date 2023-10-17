part of image_picker_widget;

class ModalImageSelector extends StatelessWidget {
  final ModalOptions? modalOptions;

  const ModalImageSelector(this.modalOptions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        backgroundColor: Colors.transparent,
        onClosing: () {
          return null;
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        builder: (_) {
          var children = <Widget>[
            ImageSourceWidget(
              titleWidget: modalOptions?.cameraText,
              title: "camera",
              inRow: modalOptions?.inRow,
              icon: Icon(
                modalOptions?.cameraIcon ?? Icons.camera,
                size: modalOptions?.cameraSize ?? 40,
                color:
                    modalOptions?.cameraColor ?? Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
            ),
            SizedBox(height: 12.0, width: 12.0),
            ImageSourceWidget(
              titleWidget: modalOptions?.galleryText,
              title: "gallery",
              inRow: modalOptions?.inRow,
              icon: Icon(
                modalOptions?.galleryIcon ?? Icons.collections,
                size: modalOptions?.gallerySize ?? 40,
                color: modalOptions?.galleryColor ??
                    Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
            ),
          ];
          return Container(
            padding: modalOptions?.padding ??
                EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
            margin: modalOptions?.margin,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: modalOptions?.borderRadius ??
                  BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
              color: modalOptions?.bgColor ?? Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                modalOptions?.title ??
                    Text("Select:",
                        style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 8),
                FractionallySizedBox(
                  widthFactor: 1.2 / 2,
                  alignment: Alignment.centerLeft,
                  child: modalOptions?.directionOfImageSourceWidgets ==
                          Axis.horizontal
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: children,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: children,
                        ),
                ),
                SizedBox()
              ],
            ),
          );
        });
  }
}

class ImageSourceWidget extends StatelessWidget {
  final Icon icon;
  final Widget? titleWidget;
  final String title;
  final VoidCallback onTap;
  final bool? inRow;

  const ImageSourceWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleWidget,
    this.inRow,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      icon,
      SizedBox(
        width: 8.0,
        height: 8.0,
      ),
      titleWidget ??
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall,
          ),
    ];

    return InkWell(
      onTap: onTap,
      child: (inRow ?? true)
          ? Row(
              children: children,
            )
          : Column(
              children: children,
            ),
    );
  }
}
