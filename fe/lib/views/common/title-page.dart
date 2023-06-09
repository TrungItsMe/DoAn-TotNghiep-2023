// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'style.dart';

class TitlePage extends StatelessWidget {
  final dynamic listPreTitle;
  final String? content;
  final Widget? widgetBoxRight;

  const TitlePage({Key? key, this.listPreTitle, this.widgetBoxRight, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: white, boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 216, 216, 216).withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 12,
          offset: Offset(5, 5), // changes position of shadow
        )
      ]),
      height: listPreTitle.isEmpty ? 60 : 80,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          margin: const EdgeInsets.only(left: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (int i = 0; i < listPreTitle.length; i++)
                    Row(
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              // Provider.of<NavigationModel>(context, listen: false).add(pageUrl: listPreTitle[i]['url']);
                            },
                            child: Text(
                              listPreTitle[i]['title'],
                              style: const TextStyle(color: mainColor),
                            )),
                        i < listPreTitle.length - 1
                            ? Container(
                                margin: const EdgeInsets.only(left: 5, right: 5),
                                child: const Text(
                                  '/',
                                  style: TextStyle(color: mainColor),
                                ))
                            : Container()
                      ],
                    )
                ],
              ),
              content != null
                  ? Row(
                      children: [
                        Text(content!.toUpperCase(), style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w800)),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        widgetBoxRight != null ? Container(margin: const EdgeInsets.only(right: 20), child: widgetBoxRight!) : Container(),
      ]),
    );
  }
}
