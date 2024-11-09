class Preferences {
  final String bookmarks = 'bookmarks';
  final String lastPage = 'last_page';

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
