import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class ShowImagePage extends StatefulWidget {
  // const ShowImagePage({super.key});
  const ShowImagePage({super.key, required this.image});

  final String image;

  @override
  State<ShowImagePage> createState() => _ShowImagePageState();
}

class _ShowImagePageState extends State<ShowImagePage> {
  /*var img =
      'https://firebasestorage.googleapis.com/v0/b/dreamacademy-example.appspot.com/o/buktiFollow%2F3pfXOd7K9jT4JB73wwbEgxt3Rkr2%2FTangkapan%20Layar%202024-09-22%20pukul%2019.17.24.png?alt=media&token=ed8a1810-b0b7-4f34-a1bf-cbf1802a2abb';*/
  var hideAppbar = false;
  var hideBtn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              height: hideAppbar ? 0 : 50,
              width: lebar(context),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onEnd: () {
                if (!hideAppbar) {
                  hideBtn = !hideBtn;
                }
                setState(() {});
              },
              child: Wrap(
                children: [
                  if (!hideBtn)
                    TextButton.icon(
                      style: TextButton.styleFrom(backgroundColor: Colors.black.withOpacity(.1)),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.navigate_before_rounded, color: Colors.black),
                      label: Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                ],
              ),
            ),
            Expanded(
              child: InkWell(
                hoverColor: Colors.transparent,
                onTap: () {
                  hideAppbar = !hideAppbar;
                  if (hideAppbar) {
                    hideBtn = true;
                  }
                  setState(() {});
                },
                child: CachedNetworkImage(
                  height: tinggi(context),
                  width: lebar(context),
                  imageUrl: widget.image,
                  // fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
