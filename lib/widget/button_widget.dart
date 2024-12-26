part of '../flutter_image_crop_compress.dart';

class ButtonWidget extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final String? selectedText;
  final dynamic Function() onTap;
  final bool enable;
  final bool primary;
  final bool isCapital;
  final Color? colorBtn;
  final Icon? btcIcon;
  final double? borderSize;
  final Color? borderAndTextColor;
  final EdgeInsets padding;

  const ButtonWidget({
    required super.key,
    this.title,
    this.titleWidget,
    required this.onTap,
    this.enable = true,
    this.selectedText,
    this.primary = true,
    this.isCapital = true,
    this.colorBtn,
    this.borderSize,
    this.borderAndTextColor,
    this.btcIcon,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool loading = false;

  void _setLoading(bool newValue) {
    setState(() {
      loading = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.enable && !loading)
          ? () async {
              _setLoading(true);
              await widget.onTap();
              _setLoading(false);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
              color: widget.borderAndTextColor ?? Colors.transparent,
              width: widget.borderSize ?? 0),
          color: widget.title == widget.selectedText
              ? (widget.borderAndTextColor ??
                  Theme.of(context).colorScheme.primary)
              : (widget.primary
                  ? (widget.colorBtn ?? Theme.of(context).colorScheme.primary)
                  : Theme.of(context).colorScheme.onPrimary.withOpacity(0.2)),
        ),
        padding: widget.padding,
        child: Center(
          child: widget.titleWidget ??
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    widget.btcIcon != null
                        ? WidgetSpan(
                            child: widget.btcIcon ?? const Icon(Icons.apple))
                        : const TextSpan(),
                    TextSpan(
                      text: widget.isCapital
                          ? (widget.title ?? "").toUpperCase()
                          : widget.title ?? "",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.title == widget.selectedText
                              ? widget.colorBtn
                              : (widget.borderAndTextColor ??
                                  (widget.primary
                                      ? Colors.white
                                      : Colors.black)),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
