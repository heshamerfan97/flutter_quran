import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_bloc.dart';
import 'controllers/bookmarks_controller.dart';
import 'controllers/quran_controller.dart';
import 'models/bookmark.dart';
import 'models/quran_page.dart';
import 'widgets/bsmallah_widget.dart';
import 'widgets/quran_line.dart';
import 'widgets/quran_page_bottom_info.dart';
import 'widgets/surah_header_widget.dart';

class FlutterQuranScreen extends StatelessWidget {
  const FlutterQuranScreen(
      {this.showBottomWidget = true,
      this.bottomWidget,
      this.appBar,
      this.onPageChanged,
      super.key});


  ///[showBottomWidget] is a bool to disable or enable the default bottom widget
  final bool showBottomWidget;

  ///[bottomWidget] if if provided it will replace the default bottom widget
  final Widget? bottomWidget;

  ///[appBar] if if provided it will replace the default app bar
  final PreferredSizeWidget? appBar;

  ///[onPageChanged] if provided it will be called when a quran page changed
  final Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: Scaffold(
        appBar: appBar,
        body: BlocBuilder<QuranCubit, List<QuranPage>>(
          builder: (ctx, pages) {
            return pages.isEmpty? const Center(child: CircularProgressIndicator()): Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: PageView.builder(
                  itemCount: pages.length,
                  controller: AppBloc.quranCubit.pageController,
                  onPageChanged: (page) {
                    if (onPageChanged != null) onPageChanged!(page);
                    AppBloc.quranCubit.saveLastPage(page+1);
                  },
                  pageSnapping: true,
                  itemBuilder: (ctx, index) {
                    List<String> newSurahs = [];
                    return Container(
                        height: deviceSize.height * 0.8,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: index == 0 || index == 1
                                  /// This is for first 2 pages of Quran: Al-Fatihah and Al-Baqarah
                                  ? Center(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SurahHeaderWidget(pages[index].ayahs[0].surahNameAr),
                                            if (index == 1) const BasmallahWidget(),
                                            ...pages[index].lines.map((line) {
                                              return BlocBuilder<BookmarksCubit, List<Bookmark>>(
                                                builder: (context, bookmarks) {
                                                  final bookmarksAyahs = bookmarks
                                                      .map((bookmark) => bookmark.ayahId)
                                                      .toList();
                                                  return Column(
                                                    children: [
                                                      SizedBox(
                                                          width: deviceSize.width - 32,
                                                          child: QuranLine(
                                                            line,
                                                            bookmarksAyahs,
                                                            bookmarks,
                                                            boxFit: BoxFit.scaleDown,
                                                          )),
                                                    ],
                                                  );
                                                },
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    )

                                  /// Other Quran pages
                                  : LayoutBuilder(
                                    builder: (context, constraints) {
                                      return ListView(
                                          physics: currentOrientation == Orientation.portrait
                                              ? const NeverScrollableScrollPhysics()
                                              : null,
                                          children: [
                                              ...pages[index].lines.map((line) {
                                                bool firstAyah = false;
                                                if (line.ayahs[0].ayahNumber == 1 &&
                                                    !newSurahs.contains(line.ayahs[0].surahNameAr)) {
                                                  newSurahs.add(line.ayahs[0].surahNameAr);
                                                  firstAyah = true;
                                                }
                                                return BlocBuilder<BookmarksCubit, List<Bookmark>>(
                                                  builder: (context, bookmarks) {
                                                    final bookmarksAyahs = bookmarks
                                                        .map((bookmark) => bookmark.ayahId)
                                                        .toList();
                                                    return Column(
                                                      children: [
                                                        if (firstAyah)
                                                          SurahHeaderWidget(line.ayahs[0].surahNameAr),
                                                        if (firstAyah &&
                                                            (line.ayahs[0].surahNumber != 9))
                                                          const BasmallahWidget(),
                                                        SizedBox(
                                                          width: deviceSize.width - 30,
                                                          height: ((currentOrientation ==
                                                                          Orientation.portrait
                                                                      ? constraints.maxHeight
                                                                      : deviceSize.width) -
                                                                  (pages[index].numberOfNewSurahs *
                                                                      (line.ayahs[0].surahNumber != 9
                                                                          ? 135
                                                                          : 80))) *
                                                              0.95 /
                                                              pages[index].lines.length,
                                                          child: QuranLine(
                                                            line,
                                                            bookmarksAyahs,
                                                            bookmarks,
                                                            boxFit: line.ayahs.last.centered
                                                                ? BoxFit.scaleDown
                                                                : BoxFit.fill,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }),
                                            ]);
                                    }
                                  ),
                            ),
                            bottomWidget ??
                                (showBottomWidget
                                    ? QuranPageBottomInfoWidget(
                                        page: index + 1,
                                        hizb: pages[index].hizb,
                                        surahName: pages[index].ayahs.last.surahNameAr)
                                    : Container()),
                          ],
                        ));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
