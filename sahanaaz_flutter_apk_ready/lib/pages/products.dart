import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahanaaz_enterprises/models/app_state.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen:false);
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(children: [
        Expanded(child: FutureBuilder(future: app.getProducts(), builder:(c,s){
          if(!s.hasData) return Center(child:CircularProgressIndicator());
          final list = s.data as List;
          return ListView.builder(itemCount:list.length, itemBuilder:(_,i){
            final p=list[i];
            return ListTile(title:Text(p['name']), subtitle:Text('₹${p['selling_price']} | Qty ${p['quantity']}'));
          });
        })),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>showDialog(context:context, builder:(ctx){
          final name=TextEditingController();
          final price=TextEditingController();
          final qty=TextEditingController();
          return AlertDialog(
            title:Text('Add Product'),
            content:Column(mainAxisSize: MainAxisSize.min, children:[
              TextField(controller:name, decoration:InputDecoration(labelText:'Name')),
              TextField(controller:price, decoration:InputDecoration(labelText:'Selling Price'), keyboardType:TextInputType.number),
              TextField(controller:qty, decoration:InputDecoration(labelText:'Quantity'), keyboardType:TextInputType.number),
            ]),
            actions:[
              TextButton(onPressed:()=>Navigator.pop(ctx), child:Text('Cancel')),
              TextButton(onPressed:(){ 
                app.addProduct({'name':name.text,'category':'','purchase_price':0.0,'selling_price':double.tryParse(price.text)??0.0,'quantity':int.tryParse(qty.text)??0}); 
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
