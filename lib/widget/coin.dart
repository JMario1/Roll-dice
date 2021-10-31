import 'package:flip/asset/custonicons.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Coin3D extends StatefulWidget {
  final Function(Function toss)? coinToss;
  final Color color;
  final Color backgroundColor;
  final Duration animationDuration;
  final double flips;
  final double size;
  final void Function(String face)? selectedFace;

  const Coin3D(
      {Key? key,
      this.coinToss,
      this.color = const Color(0xc4a74700),
      this.backgroundColor = const Color(0xe0c56e00),
      this.animationDuration = const Duration(milliseconds: 3000),
      this.flips = 10.0,
      required this.size,
      this.selectedFace})
      : super(key: key);

  @override
  _Coin3DState createState() => _Coin3DState();
}

class _Coin3DState extends State<Coin3D> with SingleTickerProviderStateMixin {
  late Widget _widget1;
  late Widget _widget2;
  Tween _tween = Tween(begin: 0.0, end: math.pi);
  late List<Widget> iconList;
  late AnimationController _animationController =
      AnimationController(vsync: this, duration: widget.animationDuration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            if (iconList[0].key == ValueKey(1)) {
              widget.selectedFace!('Head');
            } else {
              widget.selectedFace!('Tail');
            }
          }
          if (status == AnimationStatus.forward) {
            widget.selectedFace!('');
          }
        })
        ..addListener(() {
          if (math.cos(_animation.value) <= 0) {
            if (iconList[0].key == ValueKey(1)) {
              var fi = iconList.removeAt(0);
              setState(() {
                iconList.add(fi);
              });
            }
          }
          if (math.cos(_animation.value) > 0) {
            if (iconList[0].key == ValueKey(2)) {
              var fi = iconList.removeAt(0);
              setState(() {
                iconList.add(fi);
              });
            }
          }
        });
  late Animation _animation = _tween.animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear));

  Future<void> toss() async {
    iconList = [_widget1, _widget2];
    _tween.begin = 0.0;
    _tween.end = (widget.flips + math.Random().nextInt(2)) * math.pi;
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.coinToss!(toss);
    });
    _widget1 = Icon(
      CustomIcon.coin_head,
      size: widget.size,
      color: widget.color,
      key: ValueKey(1),
    );
    _widget2 = Transform(
      key: ValueKey(2),
      transform: Matrix4.rotationX(math.pi),
      alignment: FractionalOffset.center,
      child: Icon(
        CustomIcon.coin_tail,
        size: widget.size,
        color: widget.color,
      ),
    );
    iconList = [_widget1, _widget2];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.006)
            ..rotateX(_animation.value),
          child: Container(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    color: widget.backgroundColor,
                  ),
                ),
                Container(child: iconList[0]),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
