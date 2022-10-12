import 'package:flutter/material.dart';

class PlaybackSpeedDialog extends StatelessWidget {
  const PlaybackSpeedDialog({
    Key? key,
    required List<double> speeds,
    required double selected,
  })  : _speeds = speeds,
        _selected = selected,
        super(key: key);

  final List<double> _speeds;
  final double _selected;

  @override
  Widget build(BuildContext context) {
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
                'Playback speed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 24 / 18,
                  color: Color(0xffFFFFFF),
                ),
              ),
              const SizedBox(height: 24),
              ..._speeds
                  .map<Widget>(
                    (e) => Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop(e);
                          },
                          title: Text(
                            '${e}x',
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
                        if (_speeds.indexOf(e) != _speeds.length - 1)
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
