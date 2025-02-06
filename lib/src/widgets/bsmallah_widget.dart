part of '../flutter_quran_screen.dart';

class BasmallahWidget extends StatelessWidget {
  const BasmallahWidget({
    super.key,
    required this.surahNumber,
  });
  final int surahNumber;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        surahNumber == 95 || surahNumber == 97
            ? 'بِّسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ'
            : 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
        style: FlutterQuran().hafsStyle,
      ),
    );
  }
}
