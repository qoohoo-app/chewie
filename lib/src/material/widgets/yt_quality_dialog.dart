import 'dart:collection';

import 'package:chewie/src/helpers/utils.dart';
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final _quality = _qualities[index];
        return ListTile(
          dense: true,
          title: Row(
            children: [
              if (_quality == _selected)
                Icon(
                  Icons.check,
                  size: 20.0,
                  color: selectedColor,
                )
              else
                Container(width: 20.0),
              const SizedBox(width: 16.0),
              Text(_quality.videoQuality.toShortString),
            ],
          ),
          selected: _quality == _selected,
          onTap: () {
            Navigator.of(context).pop(_quality);
          },
        );
      },
      itemCount: _qualities.length,
    );
  }
}
