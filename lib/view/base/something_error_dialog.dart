import 'package:flutter/material.dart';
import 'package:template_provider/localization/language_constrants.dart';
import 'package:template_provider/util/color_resources.dart';
import 'package:template_provider/util/dimensions.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function onPressed;
  const ErrorDialog({Key key, this.title, this.content, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 36,
                ),
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).primaryColor,
                  size: 60,
                ),
                SizedBox(
                  height: 9,
                ),
                Text(
                  this.title,
                  style: TextStyle(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 9,
                ),
                Text(
                  this.content,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 1 - 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                child: Text(
                  // getTranslated('done', context),
                  "DONE",
                  style: TextStyle(color: ColorResources.COLOR_WHITE),
                ),
                onPressed: this.onPressed,
              ))
        ],
      ),
    );
  }
}
