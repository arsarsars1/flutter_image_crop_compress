part of flutter_image_crop_compress;

class ImageCompressCropPage extends StatefulWidget {
  const ImageCompressCropPage({
    Key? key,
    this.uint8list,
    this.imageFile,
    required this.onTap,
    this.buttonWidget,
    this.appBar,
    this.addAnimation,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? buttonWidget;
  final File? imageFile;
  final Uint8List? uint8list;
  final Function onTap;
  final GestureTapCallback? addAnimation;

  @override
  State<ImageCompressCropPage> createState() => _ImageCompressCropPageState();
}

class _ImageCompressCropPageState extends State<ImageCompressCropPage> {
  CropController controller = CropController();
  bool isLoading = false;
  bool isCircleUi = false;

  @override
  Widget build(BuildContext context) {
    if (widget.uint8list == null && widget.imageFile == null) {
      return const SizedBox();
    }
    return Scaffold(
      appBar: widget.appBar ??
          AppBar(
            key: const Key("appBarCrop"),
            title: const Text("Edit Image"),
          ),
      body: isLoading
          ? Container(
              color: Theme.of(context).appBarTheme.iconTheme?.color,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                children: [
                  if (widget.imageFile != null && widget.uint8list == null)
                    Expanded(
                      child: FutureBuilder(
                        future: widget.imageFile!.readAsBytes(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return snapshot.hasData
                              ? cropWidget(image: snapshot.data)
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                  if (widget.imageFile == null && widget.uint8list != null)
                    Expanded(child: cropWidget(image: widget.uint8list!)),
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                tooltip: "Crop 7_5",
                                icon: const Icon(Icons.crop_7_5,
                                    color: Colors.white),
                                onPressed: () {
                                  isCircleUi = false;
                                  controller.aspectRatio = 16 / 4;
                                },
                              ),
                              IconButton(
                                tooltip: "Crop 16_9",
                                icon: const Icon(Icons.crop_16_9,
                                    color: Colors.white),
                                onPressed: () {
                                  isCircleUi = false;
                                  controller.aspectRatio = 16 / 9;
                                },
                              ),
                              IconButton(
                                tooltip: "Crop 4_3",
                                icon: const Icon(Icons.crop_5_4,
                                    color: Colors.white),
                                onPressed: () {
                                  isCircleUi = false;
                                  controller.aspectRatio = 4 / 3;
                                },
                              ),
                              IconButton(
                                tooltip: "Square",
                                icon: const Icon(Icons.crop_square,
                                    color: Colors.white),
                                onPressed: () {
                                  isCircleUi = false;
                                  controller
                                    ..withCircleUi = false
                                    ..aspectRatio = 1;
                                },
                              ),
                              IconButton(
                                tooltip: "Reset",
                                icon: const Icon(Icons.lock_reset,
                                    color: Colors.white),
                                onPressed: () {
                                  if (widget.addAnimation != null) {
                                    widget.addAnimation!();
                                  }
                                  isCircleUi = false;
                                  controller
                                    ..withCircleUi = false
                                    ..aspectRatio = null;
                                },
                              ),
                              IconButton(
                                  tooltip: "Circle",
                                  icon: const Icon(Icons.circle,
                                      color: Colors.white),
                                  onPressed: () {
                                    isCircleUi = true;
                                    controller.withCircleUi = true;
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: widget.buttonWidget ??
                        ButtonWidget(
                          title: "Crop",
                          key: const Key("cropImageClicked"),
                          onTap: () {
                            isCircleUi
                                ? controller.cropCircle()
                                : controller.crop();
                          },
                        ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget cropWidget({required Uint8List image}) {
    return Crop(
      image: image,
      controller: controller,
      onCropped: (image) async {
        if (widget.imageFile != null && widget.uint8list == null) {
          widget.onTap(await convertImageFile(
              image, DateTime.now().millisecondsSinceEpoch.toString()));
        } else {
          widget.onTap(image);
        }
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          if (widget.addAnimation != null) {
            Navigator.pop(context);
          }
        }
      },
      initialSize: 0.5,
      withCircleUi: isCircleUi,
      maskColor:
          Theme.of(context).appBarTheme.iconTheme?.color?.withOpacity(0.8),
      onMoved: (Rect? rect) {},
      cornerDotBuilder: (size, cornerIndex) =>
          DotControl(color: Theme.of(context).primaryColor),
    );
  }

  Future<File> convertImageFile(Uint8List uit8list, String name) async {
    final Directory tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/$name.png').create();
    file.writeAsBytesSync(uit8list);
    return file;
  }
}
