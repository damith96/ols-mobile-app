import 'package:flutter/material.dart';
import 'package:test_app/size_config.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key key,
    @required this.text,
    @required this.onChanged,
    @required this.hintText
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    final isMobileLandsCape = MediaQuery.of(context).size.height < 650 && !isPortrait;
    SizedConfig().init(context);
    final styleActive = TextStyle(color: Colors.black,fontSize: isMobileLandsCape ? 4.5*SizedConfig.heightMultiplier : 3*SizedConfig.heightMultiplier);
    final styleHint = TextStyle(color: Colors.black54,fontSize: isMobileLandsCape ? 4.5*SizedConfig.heightMultiplier : 3*SizedConfig.heightMultiplier);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      alignment: Alignment.center,
      height: isPortrait?8 * SizedConfig.heightMultiplier: 12 * SizedConfig.heightMultiplier,
      margin: EdgeInsets.only(top:2*SizedConfig.heightMultiplier),
      padding: EdgeInsets.only(left: 4*SizedConfig.widthMultiplier,right: 2*SizedConfig.widthMultiplier),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
        color: Colors.white,
        border: Border.all(color: Color(0xFF282828),width: 0.5*SizedConfig.heightMultiplier),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: style.color,size: isMobileLandsCape ? 5*SizedConfig.heightMultiplier : 3.5*SizedConfig.heightMultiplier,),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color,size: isMobileLandsCape ? 5*SizedConfig.heightMultiplier : 3.5*SizedConfig.heightMultiplier),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black,fontSize: isMobileLandsCape ? 4.5*SizedConfig.heightMultiplier : 3*SizedConfig.heightMultiplier),
        cursorColor: Colors.black,
        onChanged: widget.onChanged,

      ),
    );
  }

}