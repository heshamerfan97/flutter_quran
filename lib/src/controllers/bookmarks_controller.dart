import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/bookmark.dart';
import '../repository/quran_repository.dart';

class BookmarksCubit extends Cubit<List<Bookmark>> {
  BookmarksCubit({QuranRepository? quranRepository})
      : _quranRepository = quranRepository ?? QuranRepository(),
        super([]);

  final QuranRepository _quranRepository;
  final Bookmark searchBookmark =
      Bookmark(id: 3, colorCode: 0xFFF7EFE0, name: 'search Bookmark');

  final List<Bookmark> _defaultBookmarks = [
    Bookmark(id: 0, colorCode: 0xAAFFD354, name: 'العلامة الصفراء'),
    Bookmark(id: 1, colorCode: 0xAAF36077, name: 'العلامة الحمراء'),
    Bookmark(id: 2, colorCode: 0xAA00CD00, name: 'العلامة الخضراء'),
  ];
  List<Bookmark> bookmarks = [];

  void initBookmarks({List<Bookmark>? userBookmarks, bool overwrite = false}) {
    if (overwrite) {
      bookmarks = [...(userBookmarks ?? _defaultBookmarks), searchBookmark];
    } else {
      bookmarks = _quranRepository.getBookmarks();
      if (bookmarks.isEmpty) {
        if (userBookmarks != null) {
          bookmarks = [...userBookmarks, searchBookmark];
        } else {
          bookmarks = [..._defaultBookmarks, searchBookmark];
        }
      }
    }
    _quranRepository.saveBookmarks(bookmarks);
    emit(bookmarks);
  }

  saveBookmark({
    required int ayahId,
    required int page,
    required int bookmarkId,
    bool saveBookmark = true,
  }) {
    final bookmarkIndex =
        bookmarks.indexWhere((bookmark) => bookmark.id == bookmarkId);
    if (bookmarkIndex != -1) {
      bookmarks[bookmarkIndex].ayahId = ayahId;
      bookmarks[bookmarkIndex].page = page;
      if (saveBookmark) {
        _quranRepository.saveBookmarks(bookmarks);
      }
      bookmarks = [...bookmarks];
      emit(bookmarks);
    }
  }

  removeBookmark(int bookmarkId, {bool saveBookmark = true}) {
    final bookmarkIndex =
        bookmarks.indexWhere((bookmark) => bookmark.id == bookmarkId);
    if (bookmarkIndex != -1) {
      bookmarks[bookmarkIndex].ayahId = -1;
      bookmarks[bookmarkIndex].page = -1;
      if (saveBookmark) {
        _quranRepository.saveBookmarks(bookmarks);
      }
      bookmarks = [...bookmarks];
      emit(bookmarks);
    }
  }
}
