import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class XDComponent11 extends StatelessWidget {
  XDComponent11({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 172.0, 51.0),
          size: Size(184.0, 52.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child: Text(
            'Courier',
            style: TextStyle(
              fontFamily: 'Corbel',
              fontSize: 42,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
