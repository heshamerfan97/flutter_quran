import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../models/ayah.dart';
import '../models/quran_page.dart';
import '../repository/quran_repository.dart';

class QuranCubit extends Cubit<List<QuranPage>> {
  QuranCubit({QuranRepository? quranRepository}) : _quranRepository = quranRepository ?? QuranRepository(), super([]);

  final QuranRepository _quranRepository;

  List<QuranPage> staticPages = [];
  List<int> quranStops = [];
  List<int> surahsStart = [];
  List<String> surahs = [];
  final List<Ayah> ayahs = [];
  int lastPage = 1;



  PageController _pageController = PageController();

  Future<void> loadQuran({quranPages = QuranRepository.hafsPagesNumber}) async {
    lastPage = _quranRepository.getLastPage() ?? 1;
    if(lastPage != 0){
      _pageController = PageController(initialPage: lastPage-1);
    }
    if (staticPages.isEmpty || quranPages != staticPages.length) {
      staticPages = List.generate(quranPages, (index) => QuranPage(pageNumber: index + 1, ayahs: [], lines: []));
      final quranJson = await _quranRepository.getQuran();
      int hizb= 1;
      for (int i = 0; i < quranJson.length; i++) {
        final ayah = Ayah.fromJson(quranJson[i]);
        ayahs.add(ayah);
        staticPages[ayah.page - 1].ayahs.add(ayah);
        if (ayah.ayah.contains('۞')) {
          staticPages[ayah.page - 1].hizb = hizb++;
          quranStops.add(ayah.page);
        }
        if (ayah.ayah.contains('۩')) {
          staticPages[ayah.page - 1].hasSajda = true;
        }
        if (ayah.ayahNumber == 1) {
          ayah.ayah = ayah.ayah.replaceAll('۞', '');
          staticPages[ayah.page - 1].numberOfNewSurahs++;
          surahs.add(ayah.surahNameAr);
          surahsStart.add(ayah.page - 1);
        }
      }
      for (QuranPage staticPage in staticPages) {
        List<Ayah> ayas = [];
        for (Ayah aya in staticPage.ayahs) {
          if (aya.ayahNumber == 1 && ayas.isNotEmpty) {
            ayas.clear();
          }
          if (aya.ayah.contains('\n')) {
            final lines = aya.ayah.split('\n');
            for (int i = 0; i < lines.length; i++) {
              bool centered = false;
              if ((aya.centered && i == lines.length - 2)) {
                centered = true;
              }
              final a = Ayah.fromAya(ayah: aya, aya: lines[i], ayaText: lines[i], centered: centered);
              ayas.add(a);
              if (i < lines.length - 1) {
                staticPage.lines.add(Line([...ayas]));
                ayas.clear();
              }
            }
          } else {
            ayas.add(aya);
          }
        }
        ayas.clear();
      }
      emit(staticPages);
    }
  }


  List<Ayah> search(String searchText) {
    if (searchText.isEmpty) {
      return [];
    } else {
      final filteredAyahs = ayahs.where((aya) => aya.ayahText.contains(searchText.trim())).toList();
      return filteredAyahs;
    }
  }

  saveLastPage(int lastPage) {
    this.lastPage = lastPage;
    _quranRepository.saveLastPage(lastPage);
  }

  animateToPage(int page) => _pageController.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

  get pageController => _pageController;
}
