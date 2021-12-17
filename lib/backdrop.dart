import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/product.dart';

class BackDrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  BackDrop(
      {required this.currentCategory,
      required this.frontLayer,
      required this.backLayer,
      required this.frontTitle,
      required this.backTitle,
      Key? key});

  @override
  _BlackdropState createState() => _BlackdropState();
}

class _BlackdropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  Widget _buildStack() {
    return Stack(
      key: _backdropKey,
      children: [widget.backLayer, widget.frontLayer],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      titleSpacing: 0,
      leading: const Icon(Icons.menu),
      title: const Text("SHRINE"),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            )),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.tune,
          ),
        ),
      ],
      backwardsCompatibility: false,
    );
    return Scaffold(
      appBar: appBar,
      body: _buildStack(),
    );
  }
}
