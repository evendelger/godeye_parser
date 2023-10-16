import 'package:flutter/material.dart';
import 'package:godeye_parser/features/full_file_search/widgets/widgets.dart';
import 'package:godeye_parser/features/mini_file_search/widgets/widgets.dart';
import 'package:godeye_parser/ui/widgets/widgets.dart';

class FindDataRow extends StatelessWidget {
  const FindDataRow({
    super.key,
    required this.searchType,
    required this.isRegionSearch,
    required this.controller,
    this.hintText,
    this.parseType,
  });

  final SearchType searchType;
  final bool isRegionSearch;
  final TextEditingController controller;
  final String? hintText;
  final ParseType? parseType;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          child: isRegionSearch
              ? DropDownListWidget(
                  controller: controller,
                  typeOfProvider: ProviderType.miniFilesSearch,
                  width: null,
                  contentPadding: const EdgeInsets.only(left: 40, bottom: 2),
                  fontSelectedSize: 18,
                  overflow: TextOverflow.ellipsis,
                  initialValue: null,
                  screenType: ScreenType.mini,
                  fontItembuilderSize: 16,
                  height: size.height / 18 < 30 ? 30 : size.height / 18,
                )
              : CustomTextField(
                  searchingDataType: SearchingDataType.mini,
                  width: null,
                  controller: controller,
                  hintText: hintText!,
                  parseType: parseType!,
                  fontSize: 18,
                  maxLines: 1,
                  height: size.height / 12 > 50 ? 50 : size.height / 12,
                ),
        ),
        const SizedBox(width: 5),
        CustomSearchButton(searchType: searchType),
        const SizedBox(width: 5),
        CustomShowButton(searchType: searchType),
      ],
    );
  }
}
