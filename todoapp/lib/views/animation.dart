import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/view_model_animation.dart';

class AnimationBuilder extends StatefulWidget {
  final String content;
  final VoidCallback onTap;
  final IconData buttonIcon;
  final int index;

  const AnimationBuilder({
    super.key,
    required this.content,
    required this.onTap,
    required this.buttonIcon,
    required this.index,
  });

  @override
  State<AnimationBuilder> createState() => _AnimationBuilderState();
}

class _AnimationBuilderState extends State<AnimationBuilder> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<ViewModelAnimation>(context, listen: false);
    viewModel.initializeAnimation(this, 3);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModelAnimation>(context);

    return GestureDetector(
      onTap: () {
        viewModel.shakeCard(widget.index);
      },
      child: AnimatedBuilder(
        animation: viewModel.animations[widget.index],
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(viewModel.animations[widget.index].value, 0),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(widget.content),
                trailing: IconButton(
                  onPressed: widget.onTap,
                  icon: Icon(widget.buttonIcon),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
