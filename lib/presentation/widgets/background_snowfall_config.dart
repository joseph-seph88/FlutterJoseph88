import 'package:snow_fall_animation/snow_fall_animation.dart';

class BackgroundSnowfallConfig{

  SnowfallConfig snowfallConfig(){
    return const SnowfallConfig(
      numberOfSnowflakes: 100,
      speed: 0.5,
      useEmoji: false,
      customEmojis: ['❄️', '❅', '❆'],
    );
  }
}