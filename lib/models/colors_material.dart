import 'dart:math';

class RandomColors {
  static final List<String> colors = [
    "#C8B4BA",
    "#F3DDB3",
    "#C1CD97",
    "#E18D96",
    "#909090",
  ];
  static String getRandomColor() {
    return colors[Random().nextInt(colors.length)];
  }
}
