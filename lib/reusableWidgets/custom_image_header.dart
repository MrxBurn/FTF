import 'package:flutter/material.dart';

class CustomImageHeader extends StatelessWidget {
  final bool backRequired;
  final Function? onPressed;
  final String imagePath;
  final bool networkImage;
  final Function()? onTap;

  const CustomImageHeader(
      {super.key,
      required this.backRequired,
      this.onPressed,
      required this.imagePath,
      this.networkImage = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/illustrations/boxing_ring.jpg',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 170.0),
          child: Center(
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
        onTap != null
            ? Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: Center(
                  child: TextButton(
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory),
                    onPressed: onTap,
                    child: const Text('Tap to change',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.yellow,
                            backgroundColor: Colors.black)),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
