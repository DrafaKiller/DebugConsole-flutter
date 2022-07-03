import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:debug_console/log.dart';

class DebugConsoleTile extends StatefulWidget {
  final DebugConsoleLog log;
  final bool expanded;

  const DebugConsoleTile(this.log, { super.key, this.expanded = false });

  @override
  State<DebugConsoleTile> createState() => _DebugConsoleTileState();
}

class _DebugConsoleTileState extends State<DebugConsoleTile> {
  ExpandableController? controller;

  @override
  void initState() {
    super.initState();
    controller = ExpandableController(initialExpanded: widget.expanded);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.log.level.color?.withOpacity(0.05),
      child: Container(
        color: widget.log.level.color?.withOpacity(0.05),
        child: InkWell(
          onTap: widget.log.stackTrace != null
            ? () {
              controller!.toggle();
              setState(() {});
            }
            : null,
          child: ExpandablePanel(
            controller: controller,
            theme: const ExpandableThemeData(
              tapBodyToCollapse: false,
              tapHeaderToExpand: false,
              hasIcon: false,
            ),
            header: ListTile(
              textColor: widget.log.level.color,
              title: Text(widget.log.message),
              trailing: Column(
                children: [
                  SizedBox(height: widget.log.stackTrace != null ? 4 : 15),
                  Opacity(
                    opacity: 0.5,
                    child: widget.log.timestamp.difference(DateTime.now()).inDays > 1
                      ? Text('${widget.log.timestamp.toIso8601String().substring(0, 10)} ${widget.log.timestamp.toIso8601String().substring(11, 19)}')
                      : Text(widget.log.timestamp.toIso8601String().substring(11, 19)),
                  ),
                  if (widget.log.stackTrace != null) AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    turns: controller!.expanded ? -0.5 : 0,
                    child: Icon(Icons.keyboard_arrow_down, color: widget.log.level.color),
                  )
                ],
              ),
            ),
            collapsed: Container(),
            expanded: widget.log.stackTrace != null
              ? Opacity(
                opacity: 0.75,
                child: ListTile(
                  textColor: widget.log.level.color,
                  title: Text(widget.log.stackTrace.toString()),
                ),
              )
              : Container(),
          ),
        ),
      ),
    );
  }
}