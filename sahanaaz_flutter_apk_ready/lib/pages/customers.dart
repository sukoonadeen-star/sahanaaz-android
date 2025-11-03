import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahanaaz_enterprises/models/app_state.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen:false);
    return Scaffold(
      appBar: AppBar(title: Text('Customers')),
      body: Column(children: [
        Expanded(child: FutureBuilder(future: app.getCustomers(), builder:(c,s){
          if(!s.hasData) return Center(child:CircularProgressIndicator());
          final list = s.data as List;
          return ListView.builder(itemCount:list.length, itemBuilder:(_,i){
            final p=list[i];
            return ListTile(title:Text(p['name']), subtitle:Text(p['phone'] ?? ''));
          });
        })),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>showDialog(context:context, builder:(ctx){
          final name=TextEditingController();
          final phone=TextEditingController();
          final state=TextEditingController(text:'Bihar');
          return AlertDialog(
            title:Text('Add Customer'),
            content:Column(mainAxisSize:MainAxisSize.min, children:[
              TextField(controller:name, decoration:InputDecoration(labelText:'Name')),
              TextField(controller:phone, decoration:InputDecoration(labelText:'Phone')),
              TextField(controller:state, decoration:InputDecoration(labelText:'State')),
            ]),
            actions:[
              TextButton(onPressed:()=>Navigator.pop(ctx), child:Text('Cancel')),
              TextButton(onPressed:(){ 
                app.addCustomer({'name':name.text,'phone':phone.text,'address':'','gstin':'','state':state.text}); 
                Navigator.pop(ctx); setState((){}); 
              }, child:Text('Add'))
            ]
          );
        }),
        child: Icon(Icons.add),
      ),
    );
  }
}
