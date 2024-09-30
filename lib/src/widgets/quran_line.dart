import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_bloc.dart';
import '../models/ayah.dart';
import '../models/bookmark.dart';
import '../models/quran_page.dart';
import '../utils/flutter_quran_utils.dart';
import '../utils/toast_utils.dart';

part 'ayah_long_click_dialog.dart';

class QuranLine extends StatelessWidget {
  const QuranLine(this.line, this.bookmarksAyahs, this.bookmarks,
      {super.key, this.boxFit = BoxFit.fill, this.onLongPress});

  final Line line;
  final List<int> bookmarksAyahs;
  final List<Bookmark> bookmarks;
  final BoxFit boxFit;
  final Function? onLongPress;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: boxFit,
        child: RichText(
            text: TextSpan(
          children: line.ayahs.reversed.map((ayah) {
            return WidgetSpan(
              child: GestureDetector(
                onLongPress: () {
                  if(onLongPress != null) {
                    onLongPress!(ayah);
                  }
                  else{
                    final bookmarkId = bookmarksAyahs.contains(ayah.id) ? bookmarks[bookmarksAyahs.indexOf(ayah.id)].id : null;
                    if (bookmarkId != null) {
                      AppBloc.bookmarksCubit.removeBookmark(bookmarkId);
                    } else {
                      showDialog(
                          context: context,
                          builder: (ctx) => AyahLongClickDialog(ayah));
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: bookmarksAyahs.contains(ayah.id)
                        ? Color(bookmarks[bookmarksAyahs.indexOf(ayah.id)].colorCode).withOpacity(0.7)
                        : null,
                  ),
                  child: Text(
                          ayah.ayah,
                          style: FlutterQuran().hafsStyle,
                        ),
                ),
              ),
            );
          }).toList(),
          style: FlutterQuran().hafsStyle,
        )));
  }
  
}