import 'package:flutter/material.dart';
import 'package:quotes_app_web_scraping/utils.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class QuotesPage extends StatefulWidget {
  final String categoryname;
  const QuotesPage({Key? key, required this.categoryname}) : super(key: key);
  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List quotes = [];
  List author = [];
  bool isData = false;

  @override
  void initState() {
    super.initState();
    getQuotes();
  }

  getQuotes() async {
    String url = "https://quotes.toscrape.com/tag/${widget.categoryname}/";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass = document.getElementsByClassName('quote');
    quotes = quotesclass
        .map((element) => element.getElementsByClassName('text')[0].innerHtml)
        .toList();
    author = quotesclass
        .map((element) => element.getElementsByClassName('author')[0].innerHtml)
        .toList();

    setState(() {
      isData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        title: Text(
          '${widget.categoryname} Quotes'.toUpperCase(),
          style: textStyle(25, Colors.white, FontWeight.w700),
        ),
      ),
      body: isData == false
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 20, bottom: 20),
                              child: Text(
                                quotes[index],
                                style: textStyle(
                                    18, Colors.black, FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                author[index],
                                style: textStyle(
                                    15, Colors.black, FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
