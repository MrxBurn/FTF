import 'package:flutter/material.dart';

class CustomImageHeader extends StatelessWidget {
  final bool backRequired;
  final Function? onPressed;
  final String imagePath;
  final Function()? onTap;
  final bool? isNetworkImage;

  const CustomImageHeader(
      {super.key,
      required this.backRequired,
      this.onPressed,
      required this.imagePath,
      this.isNetworkImage = false,
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
              radius: 70,
              backgroundImage: isNetworkImage == false
                  ? AssetImage(imagePath) as ImageProvider
                  : NetworkImage(imagePath),
            ),
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
                padding: const EdgeInsets.only(top: 260.0),
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
