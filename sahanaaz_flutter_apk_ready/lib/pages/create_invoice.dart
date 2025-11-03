import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahanaaz_enterprises/models/app_state.dart';
import 'dart:convert';

class CreateInvoicePage extends StatefulWidget {
  @override
  _CreateInvoicePageState createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  List<Map<String,dynamic>> items = [];
  int selectedCustomer = -1;
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen:false);
    return Scaffold(
      appBar: AppBar(title: Text('Create Invoice')),
      body: Padding(padding:EdgeInsets.all(12), child: Column(children:[
        FutureBuilder(future: app.getCustomers(), builder:(c,s){
          if(!s.hasData) return CircularProgressIndicator();
          final customers = s.data as List;
          return DropdownButton<int>(value: selectedCustomer==-1?null:selectedCustomer, hint: Text('Select Customer'), items: customers.map<DropdownMenuItem<int>>((cust){ return DropdownMenuItem(value:cust['id'], child: Text(cust['name'])); }).toList(), onChanged:(v){ setState(()=>selectedCustomer = v ?? -1); });
        }),
        SizedBox(height:8),
        ElevatedButton(onPressed: () async {
          final products = await app.getProducts();
          showDialog(context:context, builder:(ctx){
            int prodId = products.first['id'];
            final qtyController = TextEditingController(text:'1');
            final rateController = TextEditingController(text: products.first['selling_price'].toString());
            final taxController = TextEditingController(text:'18');
            return AlertDialog(title:Text('Add Item'), content:Column(mainAxisSize:MainAxisSize.min, children:[
              StatefulBuilder(builder:(c,s){ return DropdownButton<int>(value: prodId, items: products.map<DropdownMenuItem<int>>((p)=>DropdownMenuItem(value:p['id'], child: Text(p['name']))).toList(), onChanged:(v){ prodId = v ?? prodId; }); }),
              TextField(controller:qtyController, decoration:InputDecoration(labelText:'Qty'), keyboardType:TextInputType.number),
              TextField(controller:rateController, decoration:InputDecoration(labelText:'Rate'), keyboardType:TextInputType.number),
              TextField(controller:taxController, decoration:InputDecoration(labelText:'Tax %'), keyboardType:TextInputType.number),
            ]), actions:[ TextButton(onPressed:()=>Navigator.pop(ctx), child:Text('Cancel')), TextButton(onPressed:(){
              items.add({'product_id':prodId,'qty':int.tryParse(qtyController.text)??1,'rate':double.tryParse(rateController.text)??0.0,'tax_percent':double.tryParse(taxController.text)??0.0});
              Navigator.pop(ctx); setState((){});
            }, child:Text('Add')) ]);
          });
        }, child: Text('Add Item')),
        SizedBox(height:8),
        Expanded(child: ListView.builder(itemCount: items.length, itemBuilder:(_,i){ final it=items[i]; return ListTile(title:Text('Product ${it['product_id']}'), subtitle: Text('Qty ${it['qty']} x ₹${it['rate']} | Tax ${it['tax_percent']}%'), trailing: IconButton(icon:Icon(Icons.delete), onPressed:(){ setState(()=>items.removeAt(i)); })); })),
        ElevatedButton(onPressed: () async {
          if(selectedCustomer==-1 || items.isEmpty) return;
          final customers = await app.getCustomers();
          final cust = customers.firstWhere((c)=>c['id']==selectedCustomer);
          final taxes = app.calculateTaxes(items, cust['state'] ?? 'Bihar');
          final invoiceNo = 'SE-' + DateTime.now().millisecondsSinceEpoch.toString();
          final inv = {'invoice_no': invoiceNo, 'date': DateTime.now().toIso8601String(), 'customer_id': selectedCustomer, 'items': jsonEncode(items), 'subtotal': taxes['subtotal'], 'tax_total': taxes['tax'], 'total': taxes['total']};
          await app.addInvoice(inv);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invoice created: $invoiceNo')));
          Navigator.pop(context);
        }, child: Text('Create Invoice')),
      ])),
    );
  }
}
