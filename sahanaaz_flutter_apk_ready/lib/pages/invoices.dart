import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahanaaz_enterprises/models/app_state.dart';
import 'dart:convert';
import 'invoice_view.dart';

class InvoicesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen:false);
    return Scaffold(
      appBar: AppBar(title: Text('Invoices')),
      body: FutureBuilder(future: app.getInvoices(), builder:(c,s){
        if(!s.hasData) return Center(child:CircularProgressIndicator());
        final list = s.data as List;
        if(list.isEmpty) return Center(child:Text('No invoices yet'));
        return ListView.builder(itemCount:list.length, itemBuilder:(_,i){ final inv = list[i]; return ListTile(title:Text(inv['invoice_no']), subtitle:Text('Total ₹${inv['total']}'), trailing: Row(mainAxisSize: MainAxisSize.min, children:[ IconButton(icon:Icon(Icons.remove_red_eye), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>InvoiceViewPage(inv:inv)))), IconButton(icon:Icon(Icons.delete), onPressed: () async { await app.deleteInvoice(inv['id']); (context as Element).reassemble(); }) ])); });
      }),
    );
  }
}
