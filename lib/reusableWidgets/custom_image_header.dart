import 'package:flutter/material.dart';
import 'package:ftf/utils/general.dart';

class CustomImageHeader extends StatelessWidget {
  final bool backRequired;
  final Function? onPressed;
  final String imagePath;
  final bool networkImage;

  const CustomImageHeader(
      {super.key,
      required this.backRequired,
      this.onPressed,
      required this.imagePath,
      this.networkImage = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/illustrations/boxing_ring.jpg',
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 170.0),
            child: CircleAvatar(
                radius: 90,
                backgroundImage: networkImage == false
                    ? AssetImage(
                        imagePath,
                      )
                    : NetworkImage(imagePath) as ImageProvider),
          ),
        ),
        backRequired == true
            ? AppBar(
                leading: BackButton(
                  onPressed: () =>
                      onPressed != null ? onPressed!() : Navigator.pop(context),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : const SizedBox(),
      ],
    );
  }
}
