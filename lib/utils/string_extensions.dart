import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {

  DateTime get asDateTime {
    String pattern = 'yyyy-MM-dd';
    return DateFormat(pattern).parse(this);
  }

  // bool get isEmpty

  Color get toColor {
    final hue = (hashCode % 270.0) + 90;
    final hslColor = HSLColor.fromAHSL(1.0, hue.toDouble(), 0.6, 0.9);
    return hslColor.toColor();
  }

}

extension NullableStringExtensions on String? {

  bool get isNullOrBlank {
    if (this == null) return true;
    return this!.replaceAll(' ', '').isEmpty;
  }

  static final RegExp _hashTagRegExp = RegExp(r"#[\p{L}0-9-_]*", unicode: true);

  List<String> get splitHashTags {
    var result = <String>[];
    if (this == null || this!.isEmpty) return result;

    var tags = _hashTagRegExp.allMatches(this!).toList();
    if (tags.isEmpty) return <String>[this!];

    if (tags[0].start > 0) {
      result.add(this!.substring(0, tags[0].start));
    }

    for (var i = 0; i < tags.length; i++) {
      result.add(tags[i].group(0) ?? '');
      if (tags[i].end >= this!.length) break;
      if (i == (tags.length - 1)) {
        result.add(this!.substring(tags[i].end));
      } else {
        result.add(this!.substring(tags[i].end, tags[i+1].start));
      }
    }
    return result;
  }

  List<String> get hashTags {
    var result = <String>[];
    if (this == null || this!.isEmpty) return result;

    return _hashTagRegExp
      .allMatches(this!)
      .map((e) => e.group(0))
      .whereType<String>()
      .toList();
  }

  String? limitFromStart(int maxSize) => (this?.length ?? 0) < maxSize ? this : this!.substring(0, maxSize);

  String getActiveTag(int position) {
    int totalLen = 0;
    List<String> list = splitHashTags;
    for (String element in list) {
      totalLen += element.length;
      if (position <= totalLen && element.startsWith("#")) {
        return element;
      }
    }
    return "";
  }

String getActiveWord(int position) {
    if (this == null || this!.isEmpty || position < 0 || position > this!.length) {
      return '';
    }

    final wordRegExp = RegExp(r'[\p{L}\p{N}]', unicode: true);

    int index = position;
    if (index >= this!.length || !wordRegExp.hasMatch(this![index])) {
      index--;
    }

    if (index < 0 || !wordRegExp.hasMatch(this![index])) {
      return '';
    }

    int start = index;
    while (start > 0 && wordRegExp.hasMatch(this![start - 1])) {
      start--;
    }

    int end = index;
    while (end < this!.length - 1 && wordRegExp.hasMatch(this![end + 1])) {
      end++;
    }

    return this!.substring(start, end + 1);
  }

  (String, int) replaceActiveTag(int position, String tag) {
    if (this == null || this!.isEmpty) return (tag, tag.length);
    final String text = this!;
    int totalLen = 0;
    List<String> list = splitHashTags;
    int ind = 0;
    while (ind < list.length) {
      totalLen += list[ind].length;
      if (position <= totalLen) {
        break;
      } else {
        ind++;
      }
    }
    if (ind >= list.length) ind = list.length - 1;
    if (list[ind].startsWith("#")) {
      list[ind] = tag;
    } else {
      return (text.substring(0, position) + tag + text.substring(position), position+tag.length);
    }

    int newPosition = 0;
    for (int i = 0; i <= ind; i++) {
      newPosition += list[i].length;
    }
    return (list.join(), newPosition);
  }

  (String, int) replaceActiveWord(int cursorIndex, String replacement) {
    if (this == null || this!.isEmpty) return (replacement, replacement.length);
    final text = this!;

    final RegExp wordRegex = RegExp(r'[\p{L}\p{N}#]+', unicode: true);
    
    final Iterable<RegExpMatch> matches = wordRegex.allMatches(text);
    
    RegExpMatch? targetMatch;

    for (final match in matches) {
      if (cursorIndex >= match.start && cursorIndex <= match.end) {
        targetMatch = match;
        break;
      }
    }

    if (targetMatch != null) {
      String before = text.substring(0, targetMatch.start);
      String after = text.substring(targetMatch.end);
      
      String newText = before + replacement + after;
      
      int newPosition = targetMatch.start + replacement.length;
      
      return (newText, newPosition);
    } else {
      String before = text.substring(0, cursorIndex);
      String after = text.substring(cursorIndex);
      return (before + replacement + after, cursorIndex + replacement.length);
    }
  }  


}