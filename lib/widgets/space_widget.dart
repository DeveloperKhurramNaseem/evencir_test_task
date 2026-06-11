import 'package:flutter/material.dart';

class SpaceWidget extends StatelessWidget {
  final num gap;
  const SpaceWidget({super.key , required this.gap});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: gap.toDouble(),),
    );
  }
}