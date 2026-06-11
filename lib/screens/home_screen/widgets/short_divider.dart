import 'package:flutter/material.dart';

class ShortDivider extends StatelessWidget {
  const ShortDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Spacer(flex: 44),
          Expanded(
            flex: 12,
            child: Divider(
              color: Color(0xFF282A39),
              thickness: 6,
              radius: BorderRadius.circular(15),
            ),
          ),
          Spacer(flex: 44),
        ],
      ),
    );
  }
}
