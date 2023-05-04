import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YTE;

class YTQualityDialog extends StatelessWidget {
  const YTQualityDialog({
    Key? key,
    required UnmodifiableListView<YTE.MuxedStreamInfo> qualities,
    required YTE.MuxedStreamInfo selected,
  })  : _qualities = qualities,
        _selected = selected,
        super(key: key);

  final UnmodifiableListView<YTE.MuxedStreamInfo> _qualities;
  final YTE.MuxedStreamInfo _selected;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 20,
          ).copyWith(
            bottom: 28,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: Color(0xff1B1D20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Video Quality',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 24 / 18,
                  color: Color(0xffFFFFFF),
                ),
              ),
              const SizedBox(height: 24),
              ..._qualities
                  .map<Widget>(
                    (e) => Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop(e);
                          },
                          title: Text(
                            e.qualityLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: (e == _selected) ? FontWeight.w700 : FontWeight.w500,
                              height: 22 / 16,
                              color: const Color(0xffFFFFFF),
                            ),
                          ),
                          trailing: (e == _selected)
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Icon(
                                    Icons.check,
                                    size: 24.0,
                                    color: Color(0xff4666E7),
                                  ),
                                )
                              : const SizedBox(
                                  width: 24,
                                  height: 24,
                                ),
                        ),
                        if (_qualities.indexOf(e) != _qualities.length - 1)
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white.withOpacity(0.05),
                          ),
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
