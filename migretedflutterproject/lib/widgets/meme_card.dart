
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:memix/providers/memes.dart';
import 'package:memix/widgets/consts.dart';
import '../providers/auth.dart';
import '../providers/meme.dart';
import 'package:provider/provider.dart';

class MemeCard extends StatefulWidget {
  @override
  _MemeCardState createState() => _MemeCardState();
}

class _MemeCardState extends State<MemeCard> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  final uid = Auth().uid;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

  }


  void showAnim(bool isFav) => isFav ? _controller.forward() : _controller.reverse();


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final meme = Provider.of<Meme>(context);
    showAnim(meme.checkMemeFav(uid));
    final screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return GestureDetector(
      onDoubleTap: () {
        meme.toggleFavourite(uid).catchError((e){
          ScaffoldMessenger.of(context).showSnackBar(Consts().getSnackBar(e.toString()));
          showAnim(meme.checkMemeFav(uid));
        }).then((_) => Provider.of<Memes>(context,listen: false).refreshState());
        showAnim(meme.checkMemeFav(uid));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: screenHeight / 2.3,
        width: double.infinity,
        child: Stack(
          children: [
            ClipRRect(
              child: Image.network(meme.photo.url,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: double.infinity, loadingBuilder:
                      (_, Widget child, ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  );
                }
              }),
              borderRadius: BorderRadius.circular(10),
            ),
            Align(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText(
                    meme.topText,
                    textAlign: meme.memeTextStyle.align,
                    maxLines: 3,
                    softWrap: true,
                    style: TextStyle(
                        color: meme.memeTextStyle.color,
                        fontSize: meme.memeTextStyle.maxFontSize,
                        fontWeight: meme.memeTextStyle.weight,
                        fontFamily: meme.memeTextStyle.fontFamily),
                  ),
                ),
              ),
              alignment: Alignment.topCenter,
            ),
            Align(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  width: double.infinity,
                  child: AutoSizeText(
                    meme.bottomText,
                    textAlign: meme.memeTextStyle.align,
                    maxLines: 3,
                    softWrap: true,
                    style: TextStyle(
                        color: meme.memeTextStyle.color,
                        fontSize: meme.memeTextStyle.maxFontSize,
                        fontWeight: meme.memeTextStyle.weight,
                        fontFamily: meme.memeTextStyle.fontFamily),
                  ),
                ),
              ),
              alignment: Alignment.bottomCenter,
            ),
            Align(
              alignment: Alignment.center,
              child: ScaleTransition(
                  scale: _animation,
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    color: Colors.white54,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
