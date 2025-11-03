import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';
import 'package:sahanaaz_enterprises/models/app_state.dart';

class InvoiceViewPage extends StatelessWidget {
  final Map<String,dynamic> inv;
  InvoiceViewPage({required this.inv});

  pw.Widget buildHeader(pw.Context ctx, Map<String,dynamic> inv, List items, Map taxes) {
    return pw.Column(children:[
      pw.Text(COMPANY_NAME, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      pw.Text(COMPANY_ADDRESS),
      pw.SizedBox(height:10),
      pw.Text('Invoice: ${inv['invoice_no']}', style: pw.TextStyle(fontSize:14)),
      pw.Text('Date: ${inv['date'].toString().split('T')[0]}'),
      pw.SizedBox(height:8),
    ]);
  }

  Future<pw.Document> generatePdf(Map<String,dynamic> invData) async {
    final doc = pw.Document();
    final items = jsonDecode(invData['items']);
    final customerState = 'Bihar'; // simple; in app we didn't save customer state in invoice view for now
    final taxes = {'subtotal': invData['subtotal'], 'tax': invData['tax_total'], 'total': invData['total']};
    doc.addPage(pw.Page(build: (ctx) {
      return pw.Column(children:[
        buildHeader(ctx, invData, items, taxes),
        pw.Table.fromTextArray(context: ctx, data: <List<String>>[<String>['#','Item','Qty','Rate','Line'],] + List.generate(items.length, (i){ final it=items[i]; final line = (it['rate'] * it['qty']).toStringAsFixed(2); return [ (i+1).toString(), it['product_id'].toString(), it['qty'].toString(), it['rate'].toString(), line ]; })),
        pw.SizedBox(height:10),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [ pw.Column(children:[ pw.Text('Subtotal: ₹${invData['subtotal'].toStringAsFixed(2)}'), pw.Text('Tax: ₹${invData['tax_total'].toStringAsFixed(2)}'), pw.Text('Total: ₹${invData['total'].toStringAsFixed(2)}') ]) ]),
        pw.SizedBox(height:20),
        pw.Align(alignment: pw.Alignment.centerRight, child: pw.Column(children:[ pw.Text('Authorized Signatory'), pw.SizedBox(height:20), pw.Text(SIGNATORY) ]))
      ]);
    }));
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    final items = jsonDecode(inv['items']);
    return Scaffold(
      appBar: AppBar(title: Text('Invoice ${inv['invoice_no']}')),
      body: Padding(padding:EdgeInsets.all(12), child: Column(children:[
        Card(child: Padding(padding:EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[ Text('Invoice: ${inv['invoice_no']}', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height:6), Text('Date: ${inv['date'].toString().split('T')[0]}'), SizedBox(height:6), Text('Total: ₹${inv['total']}') ]))),
        Expanded(child: ListView.builder(itemCount: items.length, itemBuilder:(_,i){ final it = items[i]; return ListTile(title: Text('Product ${it['product_id']}'), subtitle: Text('Qty ${it['qty']} x ₹${it['rate']}')); })),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ElevatedButton.icon(onPressed: () async { final pdf = await generatePdf(inv); await Printing.layoutPdf(onLayout: (format) => pdf.save()); }, icon: Icon(Icons.print), label: Text('Print / Save PDF')),
          ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close), label: Text('Close')),
        ])
      ])),
    );
  }
}
