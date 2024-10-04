import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget footerDesk({required BuildContext context}) => Container(
    height: 200,
    width: lebar(context),
    color: secondaryWhite,
    child: Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/logo1.svg', width: 300, height: 60),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/facebook.svg', width: 20),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/linkedin.svg', width: 20),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/youtube.svg', width: 20),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/instagram.svg', width: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                    TextButton(onPressed: () {}, child: Text('Topic', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
