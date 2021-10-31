import 'package:flip/widget/dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Roll extends StatefulWidget {
  @override
  _RollState createState() => _RollState();
}

class _RollState extends State<Roll> {
  double index = 1.0;
  late List<int?> faceV = List.generate(1, (index) => null);
  late List<Function> rollD = List.generate(4, (index) => () {});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(index),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 2,
            //width: MediaQuery.of(context).size.width / 1.5,
            child: index == 1
                ? Dice3D(
                    size: 150,
                    selectedFace: (face) {
                      setState(() {
                        faceV[0] = face;
                      });
                    },
                    diceRoll: (roll) {
                      setState(() {
                        rollD[0] = roll;
                      });
                    },
                  )
                : GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: index.round(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (constraints.maxWidth / 150).floor(),
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      print(constraints.maxWidth);
                      return Align(
                        alignment: Alignment.center,
                        child: Dice3D(
                          size: 110,
                          selectedFace: (face) {
                            setState(() {
                              faceV[index] = face;
                            });
                          },
                          diceRoll: (roll) {
                            rollD[index] = roll;
                          },
                        ),
                      );
                    },
                  ),
          );
        }),
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return constraints.flipped.maxHeight < 500
              ? Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextButton.icon(
                        onPressed: () {
                          for (int i = 0; i < index; i++) {
                            rollD[i]();
                          }
                        },
                        icon: Icon(
                          Icons.play_arrow,
                          size: 50,
                        ),
                        label: Text('roll')),
                    SizedBox(
                      height: 20,
                    ),
                    if (faceV[0] != null) Text('rolled'),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: faceV.map((value) {
                        if (value != null) {
                          return Text('| $value |');
                        } else {
                          return Text('');
                        }
                      }).toList(),
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Slider(
                        value: index,
                        onChanged: (value) {
                          setState(() {
                            faceV =
                                List.generate(value.round(), (index) => null);
                            index = value;
                          });
                        },
                        max: 4.0,
                        min: 1.0,
                        divisions: 3,
                        label: '$index',
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        if (faceV[0] != null) Text('rolled'),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: faceV.map((value) {
                            if (value != null) {
                              return Text('| $value |');
                            } else {
                              return Text('');
                            }
                          }).toList(),
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        Expanded(
                          child: TextButton.icon(
                              onPressed: () {
                                for (int i = 0; i < index; i++) {
                                  rollD[i]();
                                }
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                size: 50,
                              ),
                              label: Text('roll')),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Slider(
                              value: index,
                              onChanged: (value) {
                                setState(() {
                                  faceV = List.generate(
                                      value.round(), (index) => null);
                                  index = value;
                                });
                              },
                              max: 4.0,
                              min: 1.0,
                              divisions: 3,
                              label: '$index',
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
        })
      ],
    );
  }
}
