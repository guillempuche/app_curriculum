import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_decorated_text/flutter_decorated_text.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common_libs.dart';

class MarkdownRenderer extends StatelessWidget {
  MarkdownRenderer(
    this.markdownData, {
    Key? key,
    this.style,
  }) : super(key: key);

  final String markdownData;
  final MarkdownStyleSheet? style;

  final _webviewController = WebViewController();

  @override
  Widget build(BuildContext context) {
    String formattedMarkdown = markdownData.replaceAllMapped(RegExp(r'\\n'), (match) => '\n');

    // Use regex to replace URLs with a placeholder
    final urlPattern = RegExp(r'https?:\/\/(?:(?!png|jpg|jpeg|gif).)+');
    String replacedMarkdown = formattedMarkdown.replaceAllMapped(urlPattern, (match) {
      String url = match.group(0)!;
      return '[Link Placeholder]($url)'; // Using the markdown link format
    });

    return Markdown(
      data: replacedMarkdown,
      styleSheet: style,
      selectable: true,
      onTapLink: (text, url, title) {
        if (url != null) {
          _webviewController.loadRequest(Uri.parse(url));
          WebViewWidget(controller: _webviewController);
        }
      },
      // builders: {
      //   "a": Markdown(
      //     selectable:true,

      //     String? href = node.attributes['href'];
      //     if (text == "Link Placeholder") {
      //       return AnyLinkPreview(
      //         link: href!,
      //         displayDirection: UIDirection.UIDirectionHorizontal,
      //         showMultimedia: true,
      //         bodyTextColor: Colors.grey,
      //         titleTextColor: Colors.black,
      //         bodyTextOverflow: TextOverflow.ellipsis,
      //         bodyMaxLines: 5,
      //         titleTextOverflow: TextOverflow.ellipsis,
      //         titleMaxLines: 2,
      //       );
      //     } else {
      //       // Regular link handling
      //       return InkWell(
      //         onTap: () {
      //           if (href != null && href.isNotEmpty) {
      //             launch(href);
      //           }
      //         },
      //         child: Text(text, style: style),
      //       );
      //     }
      //   );
      // },
      // },
    );
  }
}
