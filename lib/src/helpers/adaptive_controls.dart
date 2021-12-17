import 'package:chewie/chewie.dart';
import 'package:chewie/src/material/material_desktop_controls.dart';
import 'package:flutter/material.dart';

class AdaptiveControls extends StatelessWidget {
  const AdaptiveControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return const MaterialControls();

      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const MaterialDesktopControls();

      case TargetPlatform.iOS:
        return CupertinoControls(
          backgroundColor: Colors.black.withOpacity(0.4),
          iconColor: const Color.fromARGB(255, 200, 200, 200),
        );
      default:
        return const MaterialControls();
    }
  }
}
