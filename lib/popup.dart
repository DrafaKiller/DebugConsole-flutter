part of debug_console;

class DebugConsolePopup extends StatefulWidget {
  final Widget child;

  final bool shakeEnabled;
  final bool showButton;

  final DebugConsoleController controller;
  final List<PopupMenuItem<void>> actions;
  final bool showStackTrace;
  final String? savePath;

  DebugConsolePopup({
    super.key,
    required this.child,

    this.shakeEnabled = true,
    this.showButton = true,
    
    DebugConsoleController? controller,
    this.actions = const [],
    this.showStackTrace = false,
    this.savePath,
  }) :
    controller = controller ?? DebugConsole.instance;

  @override
  State<DebugConsolePopup> createState() => _DebugConsolePopupState();
}

class _DebugConsolePopupState extends State<DebugConsolePopup> {
  bool isOpen = false;
  ShakeDetector? shakeDetector;
  
  @override
  void initState() {
    super.initState();
    if (!widget.shakeEnabled) return;
    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () => popup(),
    );
  }

  @override
  void dispose() {
    shakeDetector?.stopListening();
    super.dispose();
  }

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
              showStackTrace: widget.showStackTrace,
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