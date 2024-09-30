import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/bookmarks_controller.dart';
import 'controllers/quran_controller.dart';

class AppBloc {
  static final quranCubit = QuranCubit();
  static final bookmarksCubit = BookmarksCubit();

  static final List<BlocProvider> providers = [
    BlocProvider<QuranCubit>(create: (context) => quranCubit),
    BlocProvider<BookmarksCubit>(create: (context) => bookmarksCubit),
  ];

  static void dispose() {
    quranCubit.close();
    bookmarksCubit.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
