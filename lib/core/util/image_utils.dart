class EmojiUtils {
  static const String defaultOne = "assets/emoji/emoji_default.svg";
  static const List<String> all = const [
    "assets/emoji/emoji_default.svg",
    "assets/emoji/emoji_1.svg",
    "assets/emoji/emoji_2.svg",
    "assets/emoji/emoji_3.svg",
    "assets/emoji/emoji_4.svg",
    "assets/emoji/emoji_5.svg",
    "assets/emoji/emoji_6.svg",
    "assets/emoji/emoji_7.svg",
    "assets/emoji/emoji_8.svg",
    "assets/emoji/emoji_9.svg",
    "assets/emoji/emoji_10.svg",
    "assets/emoji/emoji_11.svg",
    "assets/emoji/emoji_12.svg",
    "assets/emoji/emoji_13.svg",
    "assets/emoji/emoji_14.svg",
    "assets/emoji/emoji_15.svg",
    "assets/emoji/emoji_16.svg",
    "assets/emoji/emoji_17.svg",
    "assets/emoji/emoji_18.svg",
    "assets/emoji/emoji_19.svg",
    "assets/emoji/emoji_20.svg",
  ];

  static bool isDefaultOne(String path) {
    return path == defaultOne;
  }
}

class StickerGroup {
  final List<String> assetPaths;

  StickerGroup(this.assetPaths);

  @override
  String toString() {
    return 'StickerGroup{assetPaths: $assetPaths}';
  }
}

class _StickerData {
  final String folderName;
  final int count;

  _StickerData(this.folderName, this.count);

  StickerGroup _toStickerGroup() {
    List<String> assetsPath = [];
    for (int i = 0; i <= count; i++) {
      assetsPath.add("assets/sticker/$folderName/${getFileNameAt(i)}");
    }
    return StickerGroup(assetsPath);
  }

  String getFileNameAt(int index) {
    return "tile${(1000 + index).toString().substring(1, 4)}.png";
  }
}

class StickerUtils {
  static List<_StickerData> stickerData = [
    _StickerData("meep", 31),
    _StickerData("brown", 19),
    _StickerData("mimiandneko", 23),
    _StickerData("mugsy", 39),
    _StickerData("piyomaru", 23),
    _StickerData("qoobee", 19),
    _StickerData("tonton2", 23),
    _StickerData("usagyuuun", 23),
    _StickerData("yam", 23),
  ];

  static List<StickerGroup> all() {
    return stickerData.map((data) => data._toStickerGroup()).toList();
  }
}
