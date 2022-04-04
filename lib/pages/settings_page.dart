import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

double currentTextSize = 22;
Color currentColor = Colors.red;
Color currentThemeColor = Colors.deepOrange;

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // set the background color
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('PICK COLOR',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: currentTextSize,
                                  color: currentColor)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.width * 0.6,
                                child: MaterialColorPicker(
                                  shrinkWrap: true,
                                  onColorChange: (Color color) {
                                    setState(() {
                                      currentColor = color;
                                    });
                                  },
                                  selectedColor: currentColor,
                                ),
                              ),
                              Container(
                                child: TextButton(
                                  child: Text(
                                    'SELECT',
                                    style: TextStyle(
                                        fontSize: currentTextSize,
                                        color: currentColor),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                        ));
              },
              child: Text('CHANGE COLOR',
                  style: TextStyle(
                      fontSize: currentTextSize, color: currentColor)),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.white, // set the background color
            //   ),
            //   onPressed: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //               title: Text('PICK TEXT SIZE',
            //                   textAlign: TextAlign.center,
            //                   style: TextStyle(
            //                       fontSize: currentTextSize,
            //                       color: currentColor)),
            //               content: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //
            //                   Container(
            //                     width: MediaQuery.of(context).size.width * 0.8,
            //                     height: MediaQuery.of(context).size.width * 0.6,
            //                     child:   StatefulBuilder(
            //                       builder: (context, state) => Slider(
            //                         value: currentTextSize,
            //                         activeColor: currentColor,
            //                         inactiveColor: currentThemeColor,
            //                         onChanged: (double s) {
            //                           setState(() {
            //                             currentTextSize = s;
            //                           });
            //                           Navigator.of(context).pop();
            //                         },
            //                         divisions: 15,
            //                         min: 10.0,
            //                         max: 25.0,
            //                       ),
            //                     ),
            //
            //                   ),
            //                   Container(
            //                     child: TextButton(
            //                       child: Text(
            //                         'SELECT',
            //                         style: TextStyle(
            //                             fontSize: currentTextSize,
            //                             color: currentColor),
            //                       ),
            //                       onPressed: () => Navigator.of(context).pop(currentTextSize),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ));
            //   },
            //   child: Text('CHANGE FONT SIZE',
            //       style: TextStyle(
            //           fontSize: currentTextSize, color: currentColor)),
            // ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // set the background color
              ),
              onPressed: () {

              },
              child: Text('CHANGE FONT SIZE',
                  style: TextStyle(
                      fontSize: currentTextSize, color: currentColor)),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Slider(
                value: currentTextSize,
                activeColor: currentColor,
                inactiveColor: currentThemeColor,
                onChanged: (double s) {
                  setState(() {
                    currentTextSize = s;
                  });
                },
                divisions: 15,
                min: 10.0,
                max: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
