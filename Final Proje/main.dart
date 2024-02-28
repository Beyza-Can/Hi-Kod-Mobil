import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class APODData {
  final String title;
  final String explanation;
  final String url;

  APODData({
    required this.title,
    required this.explanation,
    required this.url,
  });
}

Future<APODData> fetchAPOD(DateTime selectedDate) async {
  final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  final url = Uri.parse(
      'https://api.nasa.gov/planetary/apod?date=$formattedDate&api_key=gZNYkm2IuSn35Drucfm7Bcu5KPncaOoz4cwuAI6v');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // API'den başarılı bir şekilde veri alındı
    final jsonData = json.decode(response.body);
    return APODData(
      title: jsonData['title'],
      explanation: jsonData['explanation'],
      url: jsonData['url'],
    );
  } else {
    // API'den veri alınırken bir hata oluştu
    throw Exception('API isteği başarısız oldu: ${response.reasonPhrase}');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Uzay Uygulaması"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Burada arama işlemleri yapılabilir
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Burada ayarlar işlemleri yapılabilir
              },
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {},
            ),
          ],
        ),
        body: APODPage(),
      ),
    );
  }
}

class APODPage extends StatefulWidget {
  @override
  _APODPageState createState() => _APODPageState();
}

class _APODPageState extends State<APODPage> {
  late int year;
  late int month;
  late int day;
  late Future<APODData> futureAPODData;

  @override
  void initState() {
    super.initState();
    futureAPODData = fetchAPOD(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Astronomy picture of the day",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Tarihlere göre yaşanmış astronomik olayları buradan öğrenebilirsiniz.",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Yıl',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    year = int.tryParse(value) ?? DateTime.now().year;
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Ay',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    month = int.tryParse(value) ?? DateTime.now().month;
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Gün',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    day = int.tryParse(value) ?? DateTime.now().day;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              DateTime selectedDate = DateTime(year, month, day);
              setState(() {
                futureAPODData = fetchAPOD(selectedDate);
              });
            },
            child: Text('Öğren'),
          ),
        ),
        SizedBox(height: 20),
        FutureBuilder<APODData>(
          future: futureAPODData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            } else {
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Başlık: ${snapshot.data!.title}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Açıklama: ${snapshot.data!.explanation}',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _launchURL(snapshot.data!.url);
                              },
                              child: Text(
                                'Resim URL: ${snapshot.data!.url}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Resim URL'sini kontrol etmek için Image.network kullanabiliriz
                            Image.network(
                              snapshot.data!.url,
                              width: 500,
                              height: 500,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Resim yüklenirken hata oluşursa burası çalışır
                                return Center(
                                  child: Text(
                                    'Resim yüklenirken hata oluştu.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
