import 'package:flutter/material.dart';

import '../utils/flutter_quran_utils.dart';


class BasmallahWidget extends StatelessWidget {
  const BasmallahWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
        style: FlutterQuran().hafsStyle,
      ),
    );
  }
}
