import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_libs.dart';
import 'modals/fullscreen_url_img_viewer.dart';

MarkdownStyleSheet generatorMarkdownStyle(Color color) => MarkdownStyleSheet(
      h1: $styles.text.h1.copyWith(color: color),
      h2: $styles.text.h2.copyWith(color: color),
      h3: $styles.text.h3.copyWith(color: color),
      h4: $styles.text.h4.copyWith(color: color),
      p: $styles.text.body.copyWith(color: color),
      listBullet: $styles.text.body.copyWith(color: color),
    );

/// It renders the basic markdown formats in https://github.github.com/gfm.
///
/// Markdown elements aesthetically tested are: bold, italic, heading (h1, h2, h3, h4), lists, images and links.
///
/// Other formats aren't aesteticlly tested, nonetheless mostly will be displayed.
///
/// ## About links
///
/// There are three kind of links to consider:
/// 1. Clickable and beautified link using image, title and description.
///   Links that will be beutified should be in this format.
///   ```md
///   Add extra break line between the text and the URL. This small bug could be improved.
///
///   http://example.cat
///
///   The next text.
///   ```
///
/// 2. Clickable link showing the markdown text:
/// ```md
/// This is [markdown way, text without starting with a URL](http://example.cat)
/// ```
///
/// 3. Only text, non clickable.
/// ```md
/// This is `http://example.cat`
/// ```
class MarkdownRenderer extends StatelessWidget {
  const MarkdownRenderer(
    this.markdownData, {
    Key? key,
    this.style,
    this.scroller,
  }) : super(key: key);

  final String markdownData;
  final MarkdownStyleSheet? style;
  final ScrollController? scroller;

  @override
  Widget build(BuildContext context) {
    String formattedMarkdown = markdownData.replaceAllMapped(RegExp(r'\\n'), (match) => '\n');

    return Markdown(
      data: formattedMarkdown,
      styleSheet: style,
      selectable: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      softLineBreak: true,
      onTapLink: (text, url, title) async {
        if (url?.startsWith('https') == true && await canLaunchUrl(Uri.parse(url!))) {
          // Open the first kind of link new tab on the browser. Read more in the component's description.
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
        }
      },
      imageBuilder: (uri, title, alt) => AppBtn.basic(
        semanticLabel: $strings.projectDetailsSemanticThumbnail,
        onPressed: () => _handleImagePressed(context, uri),
        child: SafeArea(
          bottom: false,
          minimum: EdgeInsets.symmetric(vertical: $styles.insets.sm),
          child: Hero(
            tag: uri.toString(),
            child: AppImage(
              image: NetworkImage(uri.toString()),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(16),
              distractor: true,
              // The image won't be reloaded.
              scale: FullscreenUrlImgViewer.imageScale,
            ),
          ),
        ),
      ),
      builders: {"a": LinkElementBuilder()},
    );
  }

  void _handleImagePressed(BuildContext context, Uri uri) {
    appLogic.showFullscreenDialogRoute(context, FullscreenUrlImgViewer(urls: [uri.toString()]));
  }
}

class LinkElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(element, TextStyle? preferredStyle) {
    String? link = element.attributes['href'];

    // `element.textContent` as `[Text without starting with a URL](url)` won't be beautified.
    if (!element.textContent.startsWith('http') ||
        link == null ||
        !AnyLinkPreview.isValidLink(link, protocols: ['http', 'https'])) {
      return null;
    }
    return Material(
      borderRadius: BorderRadius.circular(16),
      child: AnyLinkPreview(
        link: link,
        urlLaunchMode: LaunchMode.externalApplication,
        showMultimedia: true,
        displayDirection: UIDirection.uiDirectionHorizontal,
        titleStyle: $styles.text.h4.copyWith(color: $styles.colors.black),
        bodyStyle: $styles.text.body.copyWith(color: $styles.colors.black),
        backgroundColor: $styles.colors.offWhite.withOpacity(0.1),
        bodyTextOverflow: TextOverflow.ellipsis,
        bodyMaxLines: 5,
        removeElevation: false,
        borderRadius: 15,
      ),
    );
  }
}
