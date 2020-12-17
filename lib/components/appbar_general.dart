import 'package:flutter/material.dart';
import 'package:flutter_manage_state_basic/util/const.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleApp;
  final Alignment titleAlignment;
  final IconData iconLeft;
  final bool isShowIconLeft;
  final Function onTapLeft;
  final IconData iconRight;
  final bool isShowIconRight ;
  final Function onTapRight;

  const BuildAppBar({
    Key key,
    this.titleApp,
    this.titleAlignment = Alignment.centerLeft,
    this.iconLeft,
    this.isShowIconLeft = false,
    this.onTapLeft,
    this.iconRight,
    this.isShowIconRight = false,
    this.onTapRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      leading: Visibility(
        visible: isShowIconLeft,
        child: IconButton(
          icon: Icon(
            iconLeft,
            color: Colors.white,
          ),
          onPressed: onTapLeft,
        ),
      ),
      title: Align(
        alignment: titleAlignment,
        child: Text(
          titleApp,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        Visibility(
          visible: isShowIconRight,
          child: IconButton(
            icon: Icon(
              iconRight,
              size: 24,
              color: Colors.white,
            ),
            onPressed: onTapRight,
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(heightAppBar);
}
