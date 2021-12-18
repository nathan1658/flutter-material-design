import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';
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

  @override
  void didUpdateWidget(BackDrop old) {
    super.didUpdateWidget(old);

    if (widget.currentCategory != old.currentCategory) {
      _toggleBackdropLayerVisibility();
    } else {
      _controller.fling(velocity: _kFlingVelocity);
    }
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
            onTap: _toggleBackdropLayerVisibility,
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
      title: _BackdropTitle(
        listenable: _controller.view,
        onPress: _toggleBackdropLayerVisibility,
        frontTitle: widget.frontTitle,
        backTitle: widget.backTitle,
      ),
      actions: [
        // TODO: Add shortcut to login screen from trailing icons (104)
        IconButton(
          icon: const Icon(
            Icons.search,
            semanticLabel: 'login', // New code
          ),
          onPressed: () {
            // TODO: Add open login (104)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.tune,
            semanticLabel: 'login', // New code
          ),
          onPressed: () {
            // TODO: Add open login (104)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            );
          },
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
  const _FrontLayer({Key? key, this.onTap, required this.child})
      : super(key: key);

  final Widget child;
  final VoidCallback? onTap;

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
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 40,
              alignment: AlignmentDirectional.centerStart,
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  final void Function() onPress;
  final Widget frontTitle;
  final Widget backTitle;
  final Animation<double> _listenable;

  const _BackdropTitle({
    Key? key,
    required Animation<double> listenable,
    required this.onPress,
    required this.frontTitle,
    required this.backTitle,
  })  : _listenable = listenable,
        super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = _listenable;
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline6!,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: this.onPress,
              icon: Stack(
                children: [
                  Opacity(
                    opacity: animation.value,
                    child:
                        const ImageIcon(AssetImage('assets/slanted_menu.png')),
                  ),
                  FractionalTranslation(
                    translation: Tween<Offset>(
                            begin: Offset.zero, end: const Offset(1, 0))
                        .evaluate(animation),
                    child: ImageIcon(
                      AssetImage('assets/diamond.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Opacity(
                opacity: CurvedAnimation(
                  parent: ReverseAnimation(animation),
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0.5, 0.0),
                  ).evaluate(animation),
                  child: backTitle,
                ),
              ),
              Opacity(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: const Offset(-0.25, 0.0),
                    end: Offset.zero,
                  ).evaluate(animation),
                  child: frontTitle,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
