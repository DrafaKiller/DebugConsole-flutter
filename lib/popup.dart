part of debug_console;

/// A widget that adds a floating button for debugging purposes.
class DebugConsolePopup extends StatefulWidget {
  final Widget child;

  final bool showButton;

  final DebugConsoleController controller;
  final List<PopupMenuItem<void>> actions;
  final bool expandStackTrace;
  final String? savePath;

  DebugConsolePopup({
    super.key,
    required this.child,

    this.showButton = true,
    
    DebugConsoleController? controller,
    this.actions = const [],
    this.expandStackTrace = false,
    this.savePath,
  }) :
    controller = controller ?? DebugConsole.instance;

  @override
  State<DebugConsolePopup> createState() => _DebugConsolePopupState();
}

class _DebugConsolePopupState extends State<DebugConsolePopup> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showButton)
          Positioned(
            right: 15,
            bottom: 15,
            child: FloatingActionButton(
              child: const Icon(Icons.bug_report),
              onPressed: () => popup(true),
            ),
          ),
      ],
    );
  }

  void popup([ bool? open ]) {
    open ??= !isOpen;
    if (open == isOpen) return;
    if (open) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async {
              isOpen = false;
              return true;
            },
            child: DebugConsole(
              controller: widget.controller,
              actions: widget.actions,
              expandStackTrace: widget.expandStackTrace,
              savePath: widget.savePath,
            ),
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
    isOpen = open;
  }
}