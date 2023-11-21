import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late String selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // DropdownSearch<String>(
            //   mode: Mode.MENU,
            //   showSelectedItems: true,
            //   items: const [
            //     'English',
            //     'Spanish',
            //     'French',
            //   ],
            //   // ignore: deprecated_member_use
            //   label: "Select Language",
            //   onChanged: (value) {
            //     setState(() {
            //       selectedLanguage = value!;
            //     });
            //   },
            //   selectedItem: selectedLanguage,
            // ),
            SizedBox(height: 20),
            Text(
              'Selected Language: $selectedLanguage',
              style: TextStyle(fontSize: 18),
            ),
            // TODO: Display products based on selected language
          ],
        ),
      ),
    );
  }
}
