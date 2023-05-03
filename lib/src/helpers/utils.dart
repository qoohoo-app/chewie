import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YTE;

String formatDuration(Duration position) {
  final ms = position.inMilliseconds;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  final minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';

  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';

  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';

  final formattedTime = '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

  return formattedTime;
}

extension VideoQualityName on YTE.VideoQuality {
  String get toShortString {
    switch (this) {
      case YTE.VideoQuality.unknown:
        return 'Unknown';
      case YTE.VideoQuality.low144:
        return '144p';
      case YTE.VideoQuality.low240:
        return '240p';
      case YTE.VideoQuality.medium360:
        return '360p';
      case YTE.VideoQuality.medium480:
        return '480p';
      case YTE.VideoQuality.high720:
        return '720p';
      case YTE.VideoQuality.high1080:
        return '1080p';
      case YTE.VideoQuality.high1440:
        return '1440p';
      case YTE.VideoQuality.high2160:
        return '2160p';
      case YTE.VideoQuality.high3072:
        return '3072p';
      case YTE.VideoQuality.high4320:
        return '4320p';
      default:
        return '';
    }
  }
}
