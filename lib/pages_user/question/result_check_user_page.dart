import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';

class ResultCheckUserPage extends StatefulWidget {
  const ResultCheckUserPage({super.key, required this.question});

  final CheckModel question;

  @override
  State<ResultCheckUserPage> createState() => _ResultCheckUserPageState();
}

class _ResultCheckUserPageState extends State<ResultCheckUserPage> {
  var isLogin = true;
  var urlImage = 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp';

  late List<String> listJawaban;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=VVarRhSsznY')!,
      params: const YoutubePlayerParams(
        color: 'red',
        privacyEnhanced: true,
        showControls: true,
        strictRelatedVideos: true,
        enableKeyboard: true,
        showFullscreenButton: true,
        showVideoAnnotations: true,
        useHybridComposition: true,
        playsInline: true,
        enableJavaScript: true,
        autoPlay: false,
      ),
    );
    listJawaban = List.generate(widget.question.options.length, (index) => '');
  }

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 5 / 1,
                    child: CachedNetworkImage(
                      imageUrl: urlImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Text(widget.question.question, style: TextStyle(color: Colors.black, fontSize: h4)),
              ],
            ),
          ),
          Column(
            children: List.generate(
              widget.question.options.length,
              (index) {
                var options = widget.question.options[index];
                bool isTrue = widget.question.trueAnswer[index] == widget.question.options[index];
                bool isSelectedTrue = false;
                bool isSelectedFalse = false;

                for (String you in widget.question.yourAnswer) {
                  if (widget.question.trueAnswer.contains(you) && you == options) {
                    isSelectedTrue = true;
                  }
                  if (!widget.question.trueAnswer.contains(you) && you == options) {
                    isSelectedFalse = true;
                  }
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (isTrue || isSelectedTrue)
                              ? primary
                              : isSelectedFalse
                                  ? secondary
                                  : secondaryWhite,
                        ),
                        child: Text(options, style: TextStyle(color: (isTrue || isSelectedTrue) ? Colors.white : Colors.black, fontSize: h4), maxLines: 10),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Checkbox(value: (isSelectedTrue || isSelectedFalse), onChanged: (bool? value) {}),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: Text('Pembahasan', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold), maxLines: 1),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question.explanation,
                  style: TextStyle(color: Colors.black, fontSize: h4),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  width: lebar(context) * .4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: YoutubePlayerIFramePlus(controller: _controller, aspectRatio: 16 / 9),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
