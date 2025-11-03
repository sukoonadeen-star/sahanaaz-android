import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahanaaz_enterprises/models/app_state.dart';
import 'products.dart';
import 'customers.dart';
import 'create_invoice.dart';
import 'invoices.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sahanaaz Enterprises')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(children: [
            Expanded(child: Card(child: Padding(padding:EdgeInsets.all(16), child: Column(children:[Text('Products'), SizedBox(height:8), FutureBuilder(future: Provider.of<AppState>(context, listen:false).getProducts(), builder:(c,s){ if(!s.hasData) return Text('...'); return Text('${(s.data as List).length}'); })])))),
            SizedBox(width:8),
            Expanded(child: Card(child: Padding(padding:EdgeInsets.all(16), child: Column(children:[Text('Customers'), SizedBox(height:8), FutureBuilder(future: Provider.of<AppState>(context, listen:false).getCustomers(), builder:(c,s){ if(!s.hasData) return Text('...'); return Text('${(s.data as List).length}'); })])))),
          ]),
          SizedBox(height:16),
          Row(children:[
            ElevatedButton.icon(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>ProductsPage())), icon: Icon(Icons.list), label: Text('Products')),
            SizedBox(width:8),
            ElevatedButton.icon(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>CustomersPage())), icon: Icon(Icons.people), label: Text('Customers')),
            SizedBox(width:8),
            ElevatedButton.icon(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>CreateInvoicePage())), icon: Icon(Icons.receipt), label: Text('Create Invoice')),
            SizedBox(width:8),
            ElevatedButton.icon(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>InvoicesListPage())), icon: Icon(Icons.receipt_long), label: Text('Invoices')),
          ])
        ]),
      ),
    );
  }
}
