import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_test/common/theme/app_colors.dart';

DataRow buildDataRow(dynamicData, ThemeData theme) {
  final dateTime = DateTime.parse(dynamicData.date);
  final day = DateFormat('d').format(dateTime);
  final month = DateFormat('MMM', 'ru').format(dateTime);
  final shortenedMonth = month.substring(0, min(3, month.length));
  final formattedDate = '$day $shortenedMonth';
  final value = dynamicData.value;
  Color valueColor = value >= 2.8 ? AppColors.appGreen : AppColors.appOrange;

  return DataRow(
    cells: [
      DataCell(Text(formattedDate, style: theme.textTheme.titleMedium)),
      DataCell(Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
          dynamicData.lab,
          style: theme.textTheme.bodySmall,
        ),
        const Spacer(),
      ])),
      DataCell(Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          Text(
            value.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: valueColor,
            ),
          ),
        ],
      )),
    ],
  );
}
