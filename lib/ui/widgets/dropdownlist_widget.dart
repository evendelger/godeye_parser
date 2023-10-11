import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_corrector/domain/data/regions_data.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/ui/functions/functions.dart';

enum ProviderType {
  fullFilesSearch,
  fullTextSearch,
  miniFilesSearch,
  miniTextSearch,
}

enum ScreenType {
  full,
  mini,
}

class DropDownListWidget extends StatelessWidget {
  const DropDownListWidget({
    super.key,
    required this.controller,
    this.index,
    required this.typeOfProvider,
    required this.width,
    required this.height,
    required this.contentPadding,
    required this.fontSelectedSize,
    required this.overflow,
    required this.initialValue,
    required this.screenType,
    required this.fontItembuilderSize,
  });

  final int? index;
  final TextEditingController controller;
  final ProviderType typeOfProvider;
  final double? width;
  final double? height;
  final EdgeInsets contentPadding;
  final double fontSelectedSize;
  final TextOverflow overflow;
  final String? initialValue;
  final ScreenType screenType;
  final double fontItembuilderSize;

  void _saveSelectedRegion(
    BuildContext context,
    String? value,
    ProviderType typeOfProvider,
  ) {
    if (value != null) {
      if (screenType == ScreenType.full) {
        final model = context.read<FullSearchingData>();
        if (typeOfProvider == ProviderType.fullFilesSearch) {
          model.controllers[index!].regionToSearch = value;
        } else if (typeOfProvider == ProviderType.fullTextSearch) {
          model.textItem.regionToSearch = value;
        }
      } else {
        final model = context.read<MiniSearchingData>();
        model.controllers.regionToSearch = value;
      }
      controller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      fontSize: fontItembuilderSize,
      fontWeight: FontWeight.w700,
    );

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
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
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
            typeOfProvider,
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
        color: theme.primaryColor.withOpacity(0.15),
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
