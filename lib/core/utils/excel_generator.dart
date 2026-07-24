import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/gastos/domain/entities/gasto.dart';

class ExcelGenerator {
  ExcelGenerator._();

  static Future<File> generateGastosExcel({
    required List<Gasto> gastos,
    required String fileName,
  }) async {
    final excel = Excel.createExcel();
    excel.delete('Sheet1');
    final sheet = excel['Gastos'];

    final headerStyle = CellStyle(
      bold: true,
      fontSize: 12,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString('#D4AF37'),
      horizontalAlign: HorizontalAlign.Center,
    );

    final headers = ['Categoria', 'Descripcion', 'Monto', 'Fecha'];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    final amountStyle = CellStyle(
      fontSize: 11,
    );

    for (var i = 0; i < gastos.length; i++) {
      final gasto = gastos[i];
      final rowIndex = i + 1;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value =
          TextCellValue(gasto.categoria);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value =
          TextCellValue(gasto.descripcion);

      final amountCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      amountCell.value = DoubleCellValue(gasto.valor);
      amountCell.cellStyle = amountStyle;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex)).value =
          TextCellValue(gasto.fecha);
    }

    sheet.setColumnWidth(0, 20);
    sheet.setColumnWidth(1, 35);
    sheet.setColumnWidth(2, 15);
    sheet.setColumnWidth(3, 15);

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
