import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/data/other_contents_data.dart';
import 'package:BellyDelivery/models/other_content_model.dart';
import 'package:BellyDelivery/ui/widgets/custom_close_app_bar.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool _dataLoaded = false;
  OtherContentModel data;
  OtherContentsData _otherContentsData = new OtherContentsData();

  @override
  void initState() {
    super.initState();
    _dataLoaded = false;
    getData();
  }

  void getData() async {
    data = await _otherContentsData.getHelpContents();

    if (data != null)
      setState(() {
        _dataLoaded = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCloseAppBar(
        title: help,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _dataLoaded
                        ? buildInfoDetail()
                        : Center(child: CupertinoActivityIndicator()),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 12.0),
        Container(
          width: double.infinity,
          color: cloudsColor,
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.0, right: 24.0, top: 20.0, bottom: 20.0),
            child: Text(data.desc != null ? data.desc : "",
                style: CustomFontStyle.mediumTextStyle(greyColor)),
          ),
        ),
        data.levelone == null
            ? Container()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: data.levelone.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      child: ExpansionTile(
                        title: Text(
                          data.levelone[index].title,
                          style: CustomFontStyle.mediumTextStyle(blackColor),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        backgroundColor: whiteColor,
                        children: [
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: Html(
                                    data:
                                        """${data.levelone[index].content} """),
                              ),
                            ],
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lightGrey,
                            width: 1.0,
                          ),
                        ),
                      ));
                },
              ),
      ],
    );
  }
}
