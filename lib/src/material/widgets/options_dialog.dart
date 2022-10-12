import 'package:chewie/src/models/option_item.dart';
import 'package:flutter/material.dart';

class OptionsDialog extends StatefulWidget {
  const OptionsDialog({
    Key? key,
    required this.options,
    this.cancelButtonText,
  }) : super(key: key);

  final List<OptionItem> options;
  final String? cancelButtonText;

  @override
  // ignore: library_private_types_in_public_api
  _OptionsDialogState createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.options.length,
            itemBuilder: (context, i) {
              return ListTile(
                onTap: widget.options[i].onTap != null ? widget.options[i].onTap! : null,
                leading: Icon(
                  widget.options[i].iconData,
                  color: Colors.white.withOpacity(0.8),
                ),
                title: Text(
                  widget.options[i].title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 22 / 16,
                    color: Color(0xffFFFFFF),
                  ),
                ),
                subtitle: widget.options[i].subtitle != null ? Text(widget.options[i].subtitle!) : null,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          ListTile(
            onTap: () => Navigator.pop(context),
            leading: Icon(
              Icons.close,
              color: Colors.white.withOpacity(0.8),
            ),
            title: Text(
              widget.cancelButtonText ?? 'Cancel',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 22 / 16,
                color: Color(0xffFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
