import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/ui/theme/theme.dart';

enum DataType {
  file,
  text,
}

class DropDownListWidget extends StatelessWidget {
  const DropDownListWidget({
    super.key,
    required this.controller,
    this.index,
    required this.width,
    required this.height,
    required this.contentPadding,
    required this.fontSelectedSize,
    required this.overflow,
    required this.initialValue,
    required this.dataType,
    required this.fontItembuilderSize,
  });

  final int? index;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final EdgeInsets contentPadding;
  final double fontSelectedSize;
  final TextOverflow overflow;
  final String? initialValue;
  final DataType dataType;
  final double fontItembuilderSize;

  void _saveSelectedRegion(
    BuildContext context,
    String? value,
  ) {
    if (value != null) {
      if (dataType == DataType.file) {
        DatabaseHelper.instance.updateRegion(value, index: index);
      } else {
        DatabaseHelper.instance.updateRegion(value);
      }
      controller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle =
        theme.textTheme.bodyMedium!.copyWith(fontSize: fontItembuilderSize);
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: DropdownSearch<String>(
          dropdownButtonProps: const DropdownButtonProps(isVisible: false),
          popupProps: PopupProps.dialog(
            showSearchBox: true,
            searchDelay: Duration.zero,
            dialogProps: const DialogProps(clipBehavior: Clip.antiAlias),
            searchFieldProps: TextFieldProps(
              controller: controller,
              style: textStyle,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () => Functions.pasteData(controller),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            itemBuilder: (_, item, __) {
              return SingleItemAlertDialog(
                item: item,
                theme: theme,
                textStyle: textStyle,
              );
            },
            emptyBuilder: (context, searchEntry) {
              return Center(
                child: Text('Ничего не найдено', style: textStyle),
              );
            },
          ),
          items: DrowDownRegionsData.regionMap.keys.toList(),
          dropdownDecoratorProps: DropDownDecoratorProps(
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            baseStyle: TextStyle(
              fontSize: fontSelectedSize,
              fontWeight: FontWeight.w700,
              overflow: overflow,
            ),
            dropdownSearchDecoration: InputDecoration(
              isDense: true,
              hintText: "Выбрать регион",
              hintStyle: TextStyle(color: ColorsList.hintRegionTextColor),
              contentPadding: contentPadding,
              isCollapsed: true,
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          onChanged: (value) => _saveSelectedRegion(
            context,
            value,
          ),
          selectedItem: initialValue,
        ),
      ),
    );
  }
}

class SingleItemAlertDialog extends StatelessWidget {
  const SingleItemAlertDialog({
    super.key,
    this.width,
    required this.theme,
    required this.textStyle,
    required this.item,
  });

  final double? width;
  final String item;
  final ThemeData theme;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorsList.primaryWithLargeOpacity,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          item,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
