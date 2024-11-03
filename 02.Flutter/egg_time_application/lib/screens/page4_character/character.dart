import 'dart:math';

class ImageText {
  final String imagePath;
  final String text;
  final String name;
  final int level;
  final String detail;

  ImageText(this.imagePath, this.text, this.name, this.level, this.detail);
}

class ImageTextManager {
  final List<ImageText> _images = [
    ImageText('assets/img/char_peng.png', '\t\t어서와!\n 기다렸어', 'Peng-gu', 1, "While you study, this friend will be there to help you. Give them a gentle pat and a warm hug to unleash their full potential—they're here to be your strength! And just so you know, this friend absolutely loves dancing in the rain!"
    ),
    ImageText('assets/img/char_bear.png', '나랑 같이 갈래?', 'Berr', 1, "The only way to do great work is to love what you do"),
    ImageText('assets/img/char_musicmon.png', '오늘 음악 좋은데?', 'Music-mon', 1, "In the end, we only regret the chances we didn't take"),
    ImageText('assets/img/char_panda.png', '아직 난 배고픈데..', 'Poo', 1, "The best time to plant a tree was 20 years ago. The second best time is now"),
    ImageText('assets/img/char_frangmon.png', '\t\t\t\t  잊지마, 친구\n이게 마지막 기회야', 'Frog-mon', 1, "Believe you can and you're halfway there"),
    ImageText('assets/img/char_sheep.png', '  걱정하지마\n내가 도와줄게', 'Song-2', 1, "Success is not final, failure is not fatal: It is the courage to continue that counts"),
    ImageText('assets/img/char_totoro.png', '나는 비오는 날이 좋아\n\t\t\t\t\t\t   너는 어때?', 'Totoro', 1, "What lies behind us and what lies before us are tiny matters compared to what lies within us"),
  ];

  ImageText getRandomImageText() {
    final randomIndex = Random().nextInt(_images.length);
    return _images[randomIndex];
  }
}
