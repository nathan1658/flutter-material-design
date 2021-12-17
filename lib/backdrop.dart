import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/product.dart';

const double _kFlingVelocity = 2;

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
      Key? key})
      : super(key: key);

  @override
  _BlackdropState createState() => _BlackdropState();
}

class _BlackdropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  late AnimationController _controller;

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, layerTop, 0, layerTop - layerSize.height),
      end: const RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(_controller.view);

    return Stack(
      key: _backdropKey,
      children: [
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            child: widget.frontLayer,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: _toggleBackdropLayerVisibility,
      ),
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
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
