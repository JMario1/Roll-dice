import 'package:flip/widget/coin.dart';
import 'package:flutter/material.dart';

class Flip extends StatefulWidget {
  @override
  _FlipState createState() => _FlipState();
}

class _FlipState extends State<Flip> {
  double index = 1.0;
  late List<String?> faceV = List.generate(1, (index) => null);
  late List<Function> tossD = List.generate(4, (index) => () {});
  //double _index = widget.index;
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
                ? Coin3D(
                    size: 150,
                    selectedFace: (face) {
                      setState(() {
                        faceV[0] = face;
                      });
                    },
                    coinToss: (toss) {
                      setState(() {
                        tossD[0] = toss;
                      });
                    },
                  )
                : GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: index.round(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (constraints.maxWidth / 150).floor(),
                        childAspectRatio: 1.2),
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.center,
                        child: Coin3D(
                          size: 100,
                          selectedFace: (face) {
                            setState(() {
                              faceV[index] = face;
                            });
                          },
                          coinToss: (toss) {
                            tossD[index] = toss;
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
                        onPressed: () => tossD.forEach((toss) {
                              if (mounted) {
                                toss();
                              }
                            }),
                        icon: Icon(
                          Icons.play_arrow,
                          size: 50,
                        ),
                        label: Text('toss')),
                    SizedBox(
                      height: 20,
                    ),
                    if (faceV[0] != null) Text('tossed'),
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
                        if (faceV[0] != null) Text('tossed'),
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
                              onPressed: () => tossD.forEach((element) {
                                    if (mounted) {
                                      element();
                                    }
                                  }),
                              icon: Icon(
                                Icons.play_arrow,
                                size: 50,
                              ),
                              label: Text('toss')),
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
