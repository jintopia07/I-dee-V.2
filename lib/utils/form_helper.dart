import 'package:flutter/material.dart';

class FormHelper {
  static Widget inputFieldWidget(BuildContext context, Icon icon,
      String keyNamme, String labelName, Function onValidate, Function onSaved,
      {String initialValue = "", obscureText: false, Widget suffixIcon}) {
    return Container(
      child: TextFormField(
        initialValue: initialValue,
        key: new Key(keyNamme),
        obscureText: obscureText,
        validator: (val) {
          return onValidate(val);
        },
        onSaved: (val) {
          return onSaved(val);
        },
        style: TextStyle(fontSize: 14, fontFamily: "Kanit"),
        decoration: InputDecoration(
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, fontFamily: "Kanit"),
            hintText: labelName,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 30, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
            )),
      ),
    );
  }

  static Widget saveButton(
    String buttonText,
    Function onTap,
  ) {
    return Container(
      height: 50,
      width: 150,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1.0),
            color: Colors.deepPurple[400],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "Kanit",
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            title,
            style: TextStyle(fontFamily: "Kanit", fontSize: 15),
          ),
          content: new Text(
            message,
            style: TextStyle(fontFamily: "Kanit", fontSize: 14),
          ),
          actions: [
            new FlatButton(
              onPressed: () {
                return onPressed();
              },
              child: new Text(
                buttonText,
                style: TextStyle(fontFamily: "Kanit"),
              ),
            )
          ],
        );
      },
    );
  }
}
