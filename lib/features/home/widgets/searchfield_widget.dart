import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Colorclass_widget.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: ColorClass.boxShadowColor,
                blurRadius: 15.0,
              ),
            ],
            border: Border.all(
              width: 2,
              color: ColorClass.borderColor,
            ),
            borderRadius: BorderRadius.circular(8),
            color: ColorClass.white),
        child: TextFormField(
          onChanged: (val) {},
          cursorColor: Colors.blue,
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.blue,
              ),
              hintText: 'search...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      width: 2, color: ColorClass.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      width: 2, color: ColorClass.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      width: 2, color: ColorClass.transparent)),
              fillColor: ColorClass.greyFillColor,
              isDense: true,
              filled: true),
        ),
      ),
    );
  }
}
