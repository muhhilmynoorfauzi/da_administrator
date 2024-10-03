import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class TextEditorPage extends StatelessWidget {
  final QuillController _controller = QuillController.basic();

  /*String convertDeltaToHTML(Delta delta) {
    StringBuffer html = StringBuffer();

    for (var op in delta.toList()) {
      if (op.isInsert) {
        var insert = op.isInsert;
        if (insert is String) {
          if (op.attributes != null) {
            if (op.attributes!['bold'] == true) {
              html.write('<b>$insert</b>');
            } else if (op.attributes!['italic'] == true) {
              html.write('<i>$insert</i>');
            } else {
              html.write(insert);
            }
          } else {
            html.write(insert);
          }
        }
      }
    }

    return html.toString();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Quill Editor'),
      ),
      body: Column(
        children: [
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: _controller,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('id'),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {

              final converter = QuillDeltaToHtmlConverter(
                _controller.document.toDelta().toJson(),
                ConverterOptions.forEmail(),
              );

              final html = converter.convert();
              
              print(html);

            },
            child: Text('print'),
          ),
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                checkBoxReadOnly: false,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('id'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
