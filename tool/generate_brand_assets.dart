import 'dart:io';
import 'package:image/image.dart' as img;

// Deterministic size/padding exports from the approved artwork. No redraw of the logo.
void main() {
  final root = Directory('assets/branding');
  final logo = img.decodePng(
      File('${root.path}/outbuster-wordmark-master.png').readAsBytesSync())!;
  final background = img.decodeImage(
      File('${root.path}/cinema-background.png').readAsBytesSync())!;

  img.Image canvas(int width, int height, {bool transparent = false}) {
    final result = img.Image(width: width, height: height, numChannels: 4);
    img.fill(result, color: img.ColorRgba8(8, 9, 11, transparent ? 0 : 255));
    return result;
  }

  void centered(img.Image target, int width) {
    final mark = img.copyResize(logo,
        width: width, interpolation: img.Interpolation.cubic);
    img.compositeImage(target, mark,
        dstX: (target.width - mark.width) ~/ 2,
        dstY: (target.height - mark.height) ~/ 2);
  }

  void save(String path, img.Image value) {
    File(path).parent.createSync(recursive: true);
    File(path).writeAsBytesSync(img.encodePng(value));
  }

  final splash = canvas(960, 360, transparent: true);
  centered(splash, 900);
  save('${root.path}/splash-logo.png', splash);
  final android12 = canvas(1152, 1152, transparent: true);
  centered(android12, 680);
  save('${root.path}/splash-android12.png', android12);
  final icon = canvas(1024, 1024);
  centered(icon, 880);
  save('${root.path}/app-icon.png', icon);
  final foreground = canvas(1024, 1024, transparent: true);
  centered(foreground, 580);
  save('${root.path}/adaptive-foreground.png', foreground);

  // Use a full-cover portrait without distorting the source artwork.
  final cover = img.copyResize(background,
      height: 1920, interpolation: img.Interpolation.cubic);
  final poster = canvas(1080, 1920);
  img.compositeImage(poster, cover, dstX: (1080 - cover.width) ~/ 2);
  centered(poster, 820);
  save('${root.path}/splash-preview.png', poster);
  // A separate opaque export makes the wordmark legible in email clients.
  final emailLogo = canvas(1200, 440);
  centered(emailLogo, 1080);
  save('${root.path}/wordmark-preview.png', emailLogo);
  stdout.writeln(
      'Brand exports generated: icon 1024, Android 12 1152, native logo 960x360, splash 1080x1920.');
}
