part of '../flutter_quran_screen.dart';

class AyahLongClickDialog extends StatelessWidget {
  const AyahLongClickDialog(this.ayah, {super.key});

  final Ayah ayah;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 3,
        backgroundColor: const Color(0xFFF7EFE0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'أضف علامة',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...AppBloc.bookmarksCubit.bookmarks
                    .sublist(0, 3)
                    .map((bookmark) => ListTile(
                          leading: Icon(
                            Icons.bookmark,
                            color: Color(bookmark.colorCode),
                          ),
                          title: Text(
                            bookmark.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onTap: () {
                            AppBloc.bookmarksCubit.saveBookmark(
                                ayahId: ayah.id,
                                page: ayah.page,
                                bookmarkId: bookmark.id);
                            Navigator.of(context).pop();
                          },
                        )),
                const Divider(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                            text: AppBloc
                                .quranCubit.staticPages[ayah.page - 1].ayahs
                                .firstWhere((element) => element.id == ayah.id)
                                .ayah))
                        .then((value) =>
                            ToastUtils().showToast("تم النسخ الى الحافظة"));
                    Navigator.of(context).pop();
                  },
                  child: const ListTile(
                      title: Text("نسخ الى الحافظة"),
                      leading: Icon(
                        Icons.copy_rounded,
                        color: Color(0xFF798FAB),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
