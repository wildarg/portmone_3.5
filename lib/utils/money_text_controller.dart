import 'package:flutter/material.dart';
import 'package:portmone_bloc/utils/money_extensions.dart';
import 'package:portmone_bloc/utils/string_extensions.dart';

class MoneyFormatTextEditingController extends TextEditingController {
  VoidCallback? _onChange;
  late VoidCallback _textWatcher;
  bool _updating = false;

  TextEditingValue _lastValue = const TextEditingValue(text: "");

  MoneyFormatTextEditingController({super.text, int? cents}) {
    _textWatcher = () {
      if (_updating) {
        _updating = false;
        return;
      }
      if (text != _lastValue.text && selection.start > 0) {
        TextEditingValue newValue = applyFormat();
        if (text != newValue.text) {
          _updating = true;
          value = newValue;
          _lastValue = newValue;
        }
        _lastValue = value;
      } else if (selection.start == -1) {
        value = _lastValue;
      }
      _onChange?.call();
    };

    addListener(_textWatcher);
    if (cents != null) {
      amount = cents;
    }
  }

  int get amount => text.parseToCents;

  set amount(int cents) {
    _updating = true;
    text = cents.asFormattedAmount;
  }

  void setOnChangeListener(VoidCallback? onChange) {
    _onChange = onChange;
  }

  @override
  void dispose() {
    removeListener(_textWatcher);
    super.dispose();
  }

  TextEditingValue applyFormat() {
    if (text.isEmpty) return TextEditingValue.empty;
    String input = Separator.decimal == "," ? text.replaceAll(".", ",") : text;
    int cursorPosition = value.selection.start;
    if (input.startsWith(Separator.decimal)) {
      input = "0$input";
      cursorPosition++;
    }

    bool cursorWasAtTheEnd = cursorPosition == input.length;
    List<String> parts = input.split(Separator.decimal);
    bool cursorWasInFractionalPart = parts[0].length < cursorPosition;
    if (cursorWasInFractionalPart) cursorPosition -= (parts[0].length + 1);
    String leftFromCursor =
        (!cursorWasInFractionalPart ? input.substring(0, cursorPosition) : "")
            .replaceAll(Separator.group, "");
    String intPart = parts[0].asDouble.formattedMoney;
    String fractPart = parts.length == 2
        ? parts[1]
              .limitFromStart(2)!
              .replaceAll(Separator.decimal, "")
              .replaceAll(Separator.group, "")
        : "";

    String newText =
        "$intPart${parts.length == 2 ? Separator.decimal + fractPart : ''}";
    if (cursorWasAtTheEnd) {
      cursorPosition = newText.length;
    } else if (cursorWasInFractionalPart) {
      cursorPosition += (intPart.length + 1);
    } else {
      cursorPosition = 0;
      int n = 0;
      while (n < leftFromCursor.length) {
        if (newText[cursorPosition] != Separator.group) n++;
        cursorPosition++;
      }
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: cursorPosition),
      ),
    );
  }
}
