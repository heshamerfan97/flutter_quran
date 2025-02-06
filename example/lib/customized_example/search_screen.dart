import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Ayah> ayahs = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بحث'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextField(
                  onChanged: (txt) {
                    final _ayahs = FlutterQuran().search(txt);
                    setState(() {
                      ayahs = [..._ayahs];
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: 'بحث',
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: ayahs
                        .map((ayah) => Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    ayah.ayah.replaceAll('\n', ' '),
                                  ),
                                  subtitle: Text(ayah.surahNameAr),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    FlutterQuran().navigateToAyah(ayah);
                                  },
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
