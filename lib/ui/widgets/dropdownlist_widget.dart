import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_corrector/domain/data/regions_data.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/ui/functions/functions.dart';

enum TypeOfProvider {
  filesSearch,
  textSearch,
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
    required this.fontSize,
    required this.overflow,
    required this.initialValue,
  });

  final int? index;
  final TextEditingController controller;
  final TypeOfProvider typeOfProvider;
  final double width;
  final double? height;
  final EdgeInsets contentPadding;
  final double fontSize;
  final TextOverflow overflow;
  final String? initialValue;

  void _saveSelectedRegion(
    BuildContext context,
    String? value,
    TypeOfProvider typeOfProvider,
  ) {
    if (value != null) {
      final model = context.read<SearchingDataList>();
      switch (typeOfProvider) {
        case TypeOfProvider.filesSearch:
          {
            model.listOfControllers[index!].regionToSearch = value;
          }
        case TypeOfProvider.textSearch:
          {
            model.textItem.regionToSearch = value;
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );

    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: DropdownSearch<String>(
          dropdownButtonProps: const DropdownButtonProps(isVisible: false),
          popupProps: PopupProps.dialog(
            fit: FlexFit.tight,
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
              return Container(
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
            },
            emptyBuilder: (context, searchEntry) {
              return const Center(
                child: Text('Ничего не найдено', style: textStyle),
              );
            },
          ),
          items: DrowDownRegionsData.regions,
          dropdownDecoratorProps: DropDownDecoratorProps(
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            baseStyle: TextStyle(
              fontSize: fontSize,
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
