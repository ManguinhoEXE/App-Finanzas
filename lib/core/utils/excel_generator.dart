import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class ExcelColumn {
  final String header;
  final String Function(Map<String, dynamic> row) valueExtractor;
  final double? width;

  const ExcelColumn({
    required this.header,
    required this.valueExtractor,
    this.width,
  });
}

class ExcelGenerator {
  ExcelGenerator._();

  static Future<File> generateExcel({
    required String sheetName,
    required List<ExcelColumn> columns,
    required List<Map<String, dynamic>> rows,
    required String fileName,
    String? headerColor,
  }) async {
    final excel = Excel.createExcel();
    excel.delete('Sheet1');
    final sheet = excel[sheetName];

    final headerStyle = CellStyle(
      bold: true,
      fontSize: 12,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString(headerColor ?? '#D4AF37'),
      horizontalAlign: HorizontalAlign.Center,
    );

    for (var i = 0; i < columns.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(columns[i].header);
      cell.cellStyle = headerStyle;
    }

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final rowIndex = i + 1;
      for (var j = 0; j < columns.length; j++) {
        final value = columns[j].valueExtractor(row);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: rowIndex)).value =
            TextCellValue(value);
      }
    }

    for (var i = 0; i < columns.length; i++) {
      if (columns[i].width != null) {
        sheet.setColumnWidth(i, columns[i].width!);
      }
    }

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName.xlsx';
    final fileBytes = excel.save();

    if (fileBytes != null) {
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);
      return file;
    }

    throw Exception('Error al generar el archivo Excel');
  }
}
