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
        builder: (_) => Container(
              padding: modalOptions?.padding ??
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  SizedBox(height: 5),
                  FractionallySizedBox(
                    widthFactor: 1.2 / 2,
                    alignment: Alignment.centerLeft,
                    child: (modalOptions?.inRow ?? true)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ImageSourceWidget(
                                titleWidget: modalOptions?.cameraText,
                                title: "camera",
                                inRow: false,
                                icon: Icon(
                                  modalOptions?.cameraIcon ?? Icons.camera,
                                  size: modalOptions?.cameraSize ?? 40,
                                  color: modalOptions?.cameraColor ??
                                      Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop(ImageSource.camera);
                                },
                              ),
                              ImageSourceWidget(
                                titleWidget: modalOptions?.galleryText,
                                title: "gallery",
                                inRow: false,
                                icon: Icon(
                                  modalOptions?.galleryIcon ??
                                      Icons.collections,
                                  size: modalOptions?.gallerySize ?? 40,
                                  color: modalOptions?.galleryColor ??
                                      Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(ImageSource.gallery);
                                },
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ImageSourceWidget(
                                titleWidget: modalOptions?.cameraText,
                                title: "camera",
                                inRow: true,
                                icon: Icon(
                                  modalOptions?.cameraIcon ?? Icons.camera,
                                  size: modalOptions?.cameraSize ?? 40,
                                  color: modalOptions?.cameraColor ??
                                      Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop(ImageSource.camera);
                                },
                              ),
                              ImageSourceWidget(
                                titleWidget: modalOptions?.galleryText,
                                title: "gallery",
                                inRow: true,
                                icon: Icon(
                                  modalOptions?.galleryIcon ??
                                      Icons.collections,
                                  size: modalOptions?.gallerySize ?? 40,
                                  color: modalOptions?.galleryColor ??
                                      Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                  ),
                  SizedBox()
                ],
              ),
            ));
  }
}

class ImageSourceWidget extends StatelessWidget {
  final Icon icon;
  final Widget? titleWidget;
  final String title;
  final VoidCallback onTap;
  final bool inRow;
  const ImageSourceWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleWidget,
    this.inRow = true,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      icon,
      titleWidget ??
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall,
          ),
    ];

    return InkWell(
      onTap: onTap,
      child: inRow
          ? Row(
              children: children,
            )
          : Column(
              children: children,
            ),
    );
  }
}
