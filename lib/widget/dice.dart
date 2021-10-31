import 'package:flip/asset/custonicons.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Dice3D extends StatefulWidget {
  final Duration animationDuration;
  final Duration rollDuration;
  final double size;
  final void Function(int face)? selectedFace;
  final void Function(Function roll)? diceRoll;
  final Color color;
  final Color backgroundColor;

  Dice3D(
      {Key? key,
      required this.size,
      this.rollDuration = const Duration(seconds: 3),
      this.animationDuration = const Duration(milliseconds: 500),
      this.selectedFace,
      this.diceRoll,
      this.backgroundColor = Colors.black,
      this.color = Colors.white})
      : super(key: key);

  @override
  _Dice3DState createState() => _Dice3DState();
}

class _Dice3DState extends State<Dice3D> with TickerProviderStateMixin {
  Widget face(IconData side) {
    return Stack(
      key: ValueKey<int>(side.codePoint),
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: widget.size / 1.1,
          height: widget.size / 1.1,
          color: widget.backgroundColor,
        ),
        Icon(
          side,
          size: widget.size,
          color: widget.color,
        ),
      ],
    );
  }

  List<IconData> horizontalSides = [
    CustomIcon.dice_1,
    CustomIcon.dice_2,
    CustomIcon.dice_3,
    CustomIcon.dice_4
  ];
  List<IconData> verticalSides = [
    CustomIcon.dice_1,
    CustomIcon.dice_5,
    CustomIcon.dice_3,
    CustomIcon.dice_6
  ];

  late ValueKey? faceKey = currentFace.key as ValueKey;
  late int faceNum;
  late Widget currentFace = face(horizontalSides[0]);
  late Widget nextVFace = face(horizontalSides[1]);
  late Widget nextHFace = face(horizontalSides[1]);
  late AnimationController _controller =
      AnimationController(vsync: this, duration: widget.animationDuration);
  late AnimationController _timingcontroller =
      AnimationController(vsync: this, duration: widget.rollDuration);
  Tween<double> tween = Tween(begin: 0.0, end: math.pi / 2);
  late Animation<double> _animation;
  late Action _action;
  late Widget _stack = Stack(
    alignment: AlignmentDirectional.center,
    children: [
      Container(
        width: widget.size / 3,
        height: widget.size / 3,
        color: widget.backgroundColor,
      ),
      Icon(
        CustomIcon.dice_1,
        size: widget.size,
        color: widget.color,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _animation = tween.animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInBack));
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (mounted) {
        widget.diceRoll!(_timingcontroller.forward);
      }
    });
    _timingcontroller.addListener(() {
      if (_animation.isCompleted || _animation.isDismissed) {
        if (mounted) {
          changeDieFace();
        }
      }
    });
    _timingcontroller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.selectedFace!(faceNum);
        _timingcontroller.reset();
      }
      if (status == AnimationStatus.forward) {
        //widget.selectedFace!();
      }
    });

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          switch (_action) {
            case Action.left:
              _buildLR(left: true);
              break;
            case Action.right:
              _buildLR(left: false);
              break;
            case Action.up:
              _buildUpDown(up: true);
              break;
            case Action.down:
              _buildUpDown(up: false);
              break;
            default:
          }
        });
      }
    });
  }

  void rollUp() {
    currentFace = face(verticalSides[0]);
    nextVFace = face(verticalSides[3]);
    CircularArray().shiftRight(verticalSides);
    _action = Action.up;
    horizontalSides[0] = verticalSides[0];
    horizontalSides[2] = verticalSides[2];
    if (mounted) {
      _controller.reset();
      _controller.forward();
    }
    faceKey = nextVFace.key as ValueKey;
    getFaceValue(faceKey);
  }

  void rollRight() {
    currentFace = face(horizontalSides[0]);
    nextHFace = face(horizontalSides[3]);
    CircularArray().shiftRight(horizontalSides);
    _action = Action.right;
    verticalSides[0] = horizontalSides[0];
    verticalSides[2] = horizontalSides[2];
    if (mounted) {
      _controller.reset();
      _controller.forward();
    }
    faceKey = nextHFace.key as ValueKey;
    getFaceValue(faceKey);
  }

  void rollDown() {
    currentFace = face(verticalSides[0]);
    nextVFace = face(verticalSides[1]);
    CircularArray().shiftLeft(verticalSides);
    _action = Action.down;
    horizontalSides[0] = verticalSides[0];
    horizontalSides[2] = verticalSides[2];
    if (mounted) {
      _controller.reset();
      _controller.forward();
    }
    faceKey = nextVFace.key as ValueKey;
    getFaceValue(faceKey);
  }

  void rollLeft() {
    _action = Action.left;
    currentFace = face(horizontalSides[0]);
    nextHFace = face(horizontalSides[1]);
    CircularArray().shiftLeft(horizontalSides);
    verticalSides[0] = horizontalSides[0];
    verticalSides[2] = horizontalSides[2];
    if (mounted) {
      _controller.reset();
      _controller.forward();
    }
    faceKey = nextHFace.key as ValueKey;
    getFaceValue(faceKey);
  }

  void changeDieFace() {
    int value = math.Random().nextInt(3) + 1;
    if (mounted) {
      switch (value) {
        case 1:
          rollUp();
          break;
        case 2:
          rollDown();
          break;
        case 3:
          rollRight();
          break;
        case 4:
          rollLeft();
          break;
        default:
      }
    }
  }

  Widget _buildLR({required bool left}) {
    late double x1;
    late double x2;

    if (left) {
      x1 = ((widget.size / 2) * math.cos(_animation.value));
      x2 = -((widget.size / 2) * math.sin(_animation.value));
    } else {
      x1 = -((widget.size / 2) * math.cos(_animation.value));
      x2 = ((widget.size / 2) * math.sin(_animation.value));
    }
    return _stack = Stack(
      children: [
        Transform(
          alignment: FractionalOffset.center,
          // origin: const Offset(0.01, 0.0),
          transform: Matrix4.identity()
            ..setEntry(3, 2, (0.001 * math.sin(_animation.value)))
            ..translate(
                x1, 0.0, -((widget.size / 2) * math.sin(_animation.value)))
            ..rotateY(((math.pi / 2) - _animation.value)),
          child: Container(color: widget.color, child: nextHFace),
        ),
        Transform(
            alignment: FractionalOffset.center,
            //origin: const Offset(0.0, 0.0),
            transform: Matrix4.identity()
              ..setEntry(3, 2, (0.001 * math.cos(_animation.value)))
              ..translate(
                  x2, 0.0, -((widget.size / 2) * math.cos(_animation.value)))
              ..rotateY(_animation.value),
            child: Container(color: widget.color, child: currentFace)),
      ],
    );
  }

  Widget _buildUpDown({required bool up}) {
    late double y1;
    late double y2;
    if (up) {
      y1 = ((widget.size / 2) * math.cos(_animation.value));
      y2 = -((widget.size / 2) * math.sin(_animation.value));
    } else {
      y1 = -((widget.size / 2) * math.cos(_animation.value));
      y2 = ((widget.size / 2) * math.sin(_animation.value));
    }
    return _stack = Stack(
      children: [
        Transform(
          alignment: FractionalOffset.center,
          // origin: const Offset(0.01, 0.0),
          transform: Matrix4.identity()
            ..setEntry(3, 2, (0.001 * math.sin(_animation.value)))
            ..translate(
                0.0, y1, -((widget.size / 2) * math.sin(_animation.value)))
            ..rotateX(((math.pi / 2) - _animation.value)),
          child: Container(color: widget.color, child: nextVFace),
        ),
        Transform(
          alignment: FractionalOffset.center,
          //origin: const Offset(0.0, 0.0),
          transform: Matrix4.identity()
            ..setEntry(3, 2, (0.001 * math.cos(_animation.value)))
            ..translate(
                0.0, y2, -((widget.size / 2) * math.cos(_animation.value)))
            ..rotateX((_animation.value)),
          child: Container(color: widget.color, child: currentFace),
        )
      ],
    );
  }

  void getFaceValue(ValueKey? faceKey) {
    if (faceKey == ValueKey(CustomIcon.dice_1.codePoint)) {
      faceNum = 1;
    } else if (faceKey == ValueKey(CustomIcon.dice_2.codePoint)) {
      faceNum = 2;
    } else if (faceKey == ValueKey(CustomIcon.dice_3.codePoint)) {
      faceNum = 3;
    } else if (faceKey == ValueKey(CustomIcon.dice_4.codePoint)) {
      faceNum = 4;
    } else if (faceKey == ValueKey(CustomIcon.dice_5.codePoint)) {
      faceNum = 5;
    } else if (faceKey == ValueKey(CustomIcon.dice_6.codePoint)) {
      faceNum = 6;
    } else {
      faceNum = 0;
    }
    //widget.selectedFace!(faceNum);
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(child: _stack));
  }

  @override
  void dispose() {
    _controller.dispose();
    _timingcontroller.dispose();
    super.dispose();
  }
}

enum Action { up, down, left, right }

class CircularArray {
  List<T> shiftLeft<T>(List<T> arr) {
    if (arr.isEmpty) {
      return arr;
    }
    T firstElement = arr.first;
    arr.removeAt(0);
    arr.add(firstElement);
    return arr;
  }

  List<T> shiftRight<T>(List<T> arr) {
    if (arr.isEmpty) {
      return arr;
    }
    T lastElement = arr.last;
    arr.removeLast();
    arr.insert(0, lastElement);
    return arr;
  }
}
