import 'package:flutter/material.dart';
import 'package:flutter_quran/src/app_bloc.dart';
import 'package:flutter_quran/src/models/ayah.dart';
import 'package:flutter_quran/src/models/bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quran_constants.dart';
import 'preferences/preferences_utils.dart';

class FlutterQuran {
  /// [init] initializes the FlutterQuran, and must be called before starting using the package
  Future<void> init({List<Bookmark>? userBookmarks, bool overwriteBookmarks = false}) async {
    PreferencesUtils().preferences = await SharedPreferences.getInstance();
    await AppBloc.quranCubit.loadQuran();
    AppBloc.bookmarksCubit
        .initBookmarks(userBookmarks: userBookmarks, overwrite: overwriteBookmarks);
  }

  /// [getCurrentPageNumber] Returns the page number of the page that the user is currently on.
  /// Page numbers start at 1, so the first page of the Quran is page 1.
  int getCurrentPageNumber() => AppBloc.quranCubit.lastPage;

  /// [search] Searches the Quran for the given text.
  ///
  /// Returns a list of all Ayahs whose text contains the given text.
  List<Ayah> search(String text) => AppBloc.quranCubit.search(text);

  /// [navigateToAyah] let's you navigate to any ayah
  void navigateToAyah(Ayah ayah) {
    AppBloc.quranCubit.animateToPage(ayah.page - 1);
    AppBloc.bookmarksCubit.saveBookmark(ayahId: ayah.id, page: ayah.page, bookmarkId: 3);
    Future.delayed(const Duration(seconds: 3))
        .then((value) => AppBloc.bookmarksCubit.removeBookmark(3));
  }

  /// [navigateToPage] let's you navigate to any quran page with page number
  /// Note it receives page number not page index
  void navigateToPage(int page) => AppBloc.quranCubit.animateToPage(page - 1);

  /// [navigateToJozz] let's you navigate to any quran jozz with jozz number
  /// Note it receives jozz number not jozz index
  void navigateToJozz(int jozz) =>
      navigateToPage(jozz == 1 ? 0 : (AppBloc.quranCubit.quranStops[(jozz - 1) * 8 - 1]));

  /// [navigateToHizb] let's you navigate to any quran hizb with hizb number
  /// Note it receives hizb number not hizb index
  void navigateToHizb(int hizb) =>
      navigateToPage(hizb == 1 ? 0 : (AppBloc.quranCubit.quranStops[(hizb - 1) * 4 - 1]));

  /// [navigateToBookmark] let's you navigate to a certain bookmark
  /// Note that bookmark page number must be between 1 and 604
  void navigateToBookmark(Bookmark bookmark) {
    if (bookmark.page > 0 && bookmark.page <= 604) {
      navigateToPage(bookmark.page);
    } else {
      throw Exception("Page number must be between 1 and 604");
    }
  }

  /// [navigateToSurah] let's you navigate to any quran surah with surah number
  /// Note it receives surah number not surah index
  void navigateToSurah(int surah) => navigateToPage(AppBloc.quranCubit.surahsStart[surah - 1]+1);

  ///[getAllJozzs] returns list of all Quran jozzs' names
  List<String> getAllJozzs() =>
      QuranConstants.quranHizbs.sublist(0, 30).map((jozz) => "الجزء $jozz").toList();

  ///[getAllHizbs] returns list of all Quran hizbs' names
  List<String> getAllHizbs() => QuranConstants.quranHizbs.map((jozz) => "الحزب $jozz").toList();

  ///[getAllSurahs] returns list of all Quran surahs' names
  List<String> getAllSurahs() => AppBloc.quranCubit.surahs.map((surah) => "سورة $surah").toList();

  ///[getAllBookmarks] returns list of all bookmarks
  List<Bookmark> getAllBookmarks() =>
      AppBloc.bookmarksCubit.bookmarks.sublist(0, AppBloc.bookmarksCubit.bookmarks.length - 1);

  ///[getUsedBookmarks] returns list of all bookmarks used and set by the user in quran pages
  List<Bookmark> getUsedBookmarks() =>
      AppBloc.bookmarksCubit.bookmarks.where((b) => b.page != -1).toList();

  /// Sets a bookmark with the given [ayahId], [page] and [bookmarkId].
  ///
  /// [ayahId] is the id of the ayah to be saved.
  /// [page] is the page number of the ayah.
  /// [bookmarkId] is the id of the bookmark to be saved.
  ///
  /// You can't save a bookmark with a page number that is not between 1 and 604.
  void setBookmark({required int ayahId, required int page, required int bookmarkId}) =>
      AppBloc.bookmarksCubit.saveBookmark(ayahId: ayahId, page: page, bookmarkId: bookmarkId);

  /// Removes a bookmark from the list of user's saved bookmarks.
  /// [bookmarkId] is the id of the bookmark to be removed.
  void removeBookmark({required int bookmarkId}) =>
      AppBloc.bookmarksCubit.removeBookmark(bookmarkId);

  /// [hafsStyle] is the default style for Quran so all special characters will be rendered correctly
  final hafsStyle = const TextStyle(
    color: Colors.black,
    fontSize: 23.55,
    fontFamily: "hafs",
    package: "flutter_quran",
  );

  ///Singleton factory
  static final FlutterQuran _instance = FlutterQuran._internal();

  factory FlutterQuran() {
    return _instance;
  }

  FlutterQuran._internal();
}
