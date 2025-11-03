import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class AppDatabase {
  static Database? _db;
  static Future<Database> init() async {
    if (_db != null) return _db!;
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'sahanaaz.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, category TEXT, purchase_price REAL, selling_price REAL, quantity INTEGER)');
      await db.execute('CREATE TABLE customers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, address TEXT, gstin TEXT, state TEXT)');
      await db.execute('CREATE TABLE invoices (id INTEGER PRIMARY KEY AUTOINCREMENT, invoice_no TEXT, date TEXT, customer_id INTEGER, items TEXT, subtotal REAL, tax_total REAL, total REAL)');
      await db.insert('products', {'name':'Sample Product','category':'General','purchase_price':50.0,'selling_price':75.0,'quantity':100});
    });
    return _db!;
  }
}
