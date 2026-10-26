import 'dart:io';
import 'package:image/image.dart' as img;

void main(List<String> args) {
  final destination = Directory(args.isEmpty ? 'build/email-previews' : args.single)
    ..createSync(recursive: true);
  for (final entry in {
    'splash': 'test/previews/splash.png',
    'accueil': 'test/previews/welcome.png',
    'icone': 'assets/branding/app-icon.png',
  }.entries) {
    final source = img.decodeImage(File(entry.value).readAsBytesSync())!;
    final thumbnail = img.copyResize(source,
        width: entry.key == 'icone' ? 192 : 260,
        interpolation: img.Interpolation.cubic);
    final file = File('${destination.path}/${entry.key}.jpg');
    file.writeAsBytesSync(img.encodeJpg(thumbnail, quality: 86));
    stdout.writeln('${file.path}: ${file.lengthSync()} bytes');
  }
}
