import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

// Company details provided by user
const String COMPANY_NAME = 'Sahanaaz Enterprises';
const String COMPANY_ADDRESS = 'Khagra stadium Kishanganj Bihar';
const String COMPANY_GSTIN = ''; // left blank
const String SIGNATORY = 'Samsher Alam';

class AppState extends ChangeNotifier {
  final Database db;
  AppState(Database database) : db = database;

  // Products
  Future<List<Map<String,dynamic>>> getProducts() async => await db.query('products', orderBy: 'id DESC');
  Future<int> addProduct(Map<String,dynamic> p) => db.insert('products', p);

  // Customers
  Future<List<Map<String,dynamic>>> getCustomers() async => await db.query('customers', orderBy: 'id DESC');
  Future<int> addCustomer(Map<String,dynamic> c) => db.insert('customers', c);

  // Invoices
  Future<List<Map<String,dynamic>>> getInvoices() async => await db.query('invoices', orderBy: 'id DESC');
  Future<int> addInvoice(Map<String,dynamic> inv) => db.insert('invoices', inv);
  Future<int> deleteInvoice(int id) => db.delete('invoices', where: 'id=?', whereArgs: [id]);

  // Simple GST calc: businessState = Bihar
  Map<String,double> calculateTaxes(List<dynamic> items, String customerState){
    double subtotal = 0;
    double taxTotal = 0;
    for (var it in items){
      double rate = (it['rate'] as num).toDouble();
      int qty = (it['qty'] as num).toInt();
      double taxP = (it['tax_percent'] as num).toDouble();
      double line = rate * qty;
      subtotal += line;
      taxTotal += line * (taxP/100.0);
    }
    if (customerState.trim().toLowerCase() != 'bihar') {
      return {'subtotal': subtotal, 'tax': taxTotal, 'igst': taxTotal, 'cgst':0, 'sgst':0, 'total': subtotal+taxTotal};
    } else {
      double half = double.parse((taxTotal/2).toStringAsFixed(2));
      return {'subtotal': subtotal, 'tax': taxTotal, 'cgst': half, 'sgst': half, 'igst':0, 'total': subtotal+taxTotal};
    }
  }
}
