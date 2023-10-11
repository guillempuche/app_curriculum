import 'package:guillem_curriculum/ui/common/markdown_renderer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common_libs.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final text1 =
      '''This application is more than just a resume, it\'s a journey through my skills in software development, UX and marketing.
      \r\nSend me a message to discuss how can I help you:''';
  final text2 =
      '''I've built this app (+150 hours) to be not just responsive and multi-platform, but also immersive with captivating animations.
      \r\nCurious about the behind-the-scenes magic? Explore the open-source code [here](https://github.com/guillempuche/app_curriculum). And a nod to the inspirational designs from [this repository](https://github.com/gskinnerTeam/flutter-wonderous-app).
      \r\nThe app is also iPhone/iPad compatible, but Apple doesn't allow it to be published because apps need to provide "some sort of lasting entertainment value or adequate utility". Read more in [App Store Review Guidelines - Minimum Functionality Section](https://developer.apple.com/app-store/review/guidelines/#design).
      \r\n### Privacy    
      \r\nRead about the Privacy Policy [here](https://www.guillempuche.com/privacy).
      \r\n### Licenses
      ${PlatformInfo.isDesktopOrWeb ? '\r\n- Google Play and the Google Play logo are trademarks of Google LLC.' : ''}
      \r\n- Illustrations by [dekob2](https://icons8.com/illustrations/author/A7iGlOUD5Neq) from [Ouch!](https://icons8.com/illustrations).''';

  @override
  Widget build(BuildContext context) => VerticalSwipeNavigator(
        backDirection: TransitionDirection.bottomToTop,
        goBackPath: ScreenPaths.projects,
        child: Container(
          color: $styles.colors.black,
          child: SafeArea(
            child: Animate(
              delay: 500.ms,
              effects: const [FadeEffect()],
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: Container(
                    width: 600,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 120),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              '${ImagePaths.icons}/app-icon.png',
                              height: 180,
                            ),
                          ),
                        ),
                        Gap($styles.insets.md),
                        Center(
                          child: Text(
                            'Behind The Scenes',
                            style: $styles.text.h2.copyWith(color: $styles.colors.offWhite),
                          ),
                        ),
                        Gap($styles.insets.md),
                        //       const MarkdownRenderer('''
                        // This application is more than just a resume, it's a journey through my skills in software development, UX and marketing.

                        // Send me a message to discuss how can I help you:
                        // '''),
                        MarkdownRenderer(text1),
                        Gap($styles.insets.md),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: $styles.insets.md,
                            runSpacing: $styles.insets.sm,
                            runAlignment: WrapAlignment.center,
                            children: [
                              FilledBtn(
                                icon: Icons.email,
                                text: 'Send email',
                                onPressed: () => _launchUrl(
                                    'mailto:app_stores.nullify296@simplelogin.com?subject=About%20Guillem%20Curriculum'),
                              ),
                              FilledBtn(
                                icon: Icons.three_p_sharp,
                                text: 'Message via LinkedIn',
                                onPressed: () => _launchUrl('https://www.linkedin.com/in/guillempuche'),
                              ),
                            ],
                          ),
                        ),
                        Gap($styles.insets.xl),
                        MarkdownRenderer(text2),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
