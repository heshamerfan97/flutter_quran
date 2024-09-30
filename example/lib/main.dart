import 'package:example/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: const MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterQuran().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final jozzs = FlutterQuran().getAllJozzs();
    final hizbs = FlutterQuran().getAllHizbs();
    final surahs = FlutterQuran().getAllSurahs();
    FlutterQuran().removeBookmark(bookmarkId: 0);
    final usedBookmarks = FlutterQuran().getUsedBookmarks();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 22.0),
              child: GestureDetector(
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => SearchScreen())),
                  child: Icon(Icons.search)),
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    title: Text("الجزء", style: TextStyle(fontWeight: FontWeight.bold)),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        jozzs.length,
                        (index) => GestureDetector(
                            onTap: () => FlutterQuran().navigateToJozz(index + 1),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                jozzs[index],
                                textAlign: TextAlign.start,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))),
                  ),
                  ExpansionTile(
                    title: Text("الحزب", style: TextStyle(fontWeight: FontWeight.bold)),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        hizbs.length,
                        (index) => GestureDetector(
                            onTap: () => FlutterQuran().navigateToHizb(index + 1),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                hizbs[index],
                                textAlign: TextAlign.start,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))),
                  ),
                  ExpansionTile(
                    title: Text("السورة", style: TextStyle(fontWeight: FontWeight.bold)),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        surahs.length,
                        (index) => GestureDetector(
                            onTap: () => FlutterQuran().navigateToSurah(index + 1),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                surahs[index],
                                textAlign: TextAlign.start,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))),
                  ),
                  ExpansionTile(
                    title: Text("العلامات", style: TextStyle(fontWeight: FontWeight.bold)),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: usedBookmarks
                        .map((bookmark) => GestureDetector(
                            onTap: () => FlutterQuran().navigateToBookmark(bookmark),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                bookmark.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Color(bookmark.colorCode)),
                              ),
                            )))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: FlutterQuranScreen(),
      ),
    );
  }
}