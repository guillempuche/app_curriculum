part of '../experience_detail_screen.dart';

class _TitleText extends StatelessWidget {
  const _TitleText(this.data, {Key? key, required this.scroller}) : super(key: key);
  // final WonderData data;
  final ExperienceData data;
  final ScrollController scroller;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: DefaultTextColor(
        color: $styles.colors.offWhite,
        child: StaticTextScale(
          child: Center(
            child: SizedBox(
              width: $styles.sizes.maxContentWidth1,
              child: Column(
                children: [
                  Gap($styles.insets.md),
                  const Gap(30),

                  /// Sub-title row
                  SeparatedRow(
                    padding: EdgeInsets.symmetric(horizontal: $styles.insets.sm),
                    separatorBuilder: () => Gap($styles.insets.sm),
                    children: [
                      Expanded(
                        child: Divider(
                          // color: data.type.fgColor,
                          color: Colors.red,
                        ).animate().scale(curve: Curves.easeOut, delay: 500.ms),
                      ),
                      Semantics(
                        header: true,
                        sortKey: OrdinalSortKey(1),
                        child: Text(
                          data.title.toUpperCase(),
                          style: $styles.text.title2,
                        ).animate().fade(delay: 100.ms),
                      ),
                      Expanded(
                        child: Divider(
                          // color: data.type.fgColor,
                          color: Colors.red,
                        ).animate().scale(curve: Curves.easeOut, delay: 500.ms),
                      ),
                    ],
                  ),
                  Gap($styles.insets.md),

                  /// Wonder title text
                  Semantics(
                    sortKey: OrdinalSortKey(0),
                    child: AnimatedBuilder(
                        animation: scroller,
                        builder: (_, __) {
                          final yPos = ContextUtils.getGlobalPos(context)?.dy ?? 0;
                          bool enableHero = yPos > -100;
                          return ExperienceTitleText(data, enableHero: enableHero);
                        }),
                  ),
                  // Gap($styles.insets.xs),
                  // /// Region
                  // Text(
                  //   data.regionTitle.toUpperCase(),
                  //   style: $styles.text.title1,
                  //   textAlign: TextAlign.center,
                  // ),
                  Gap($styles.insets.md),

                  /// Compass divider
                  ExcludeSemantics(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: $styles.insets.sm),
                      child: AnimatedBuilder(
                        animation: scroller,
                        builder: (_, __) => CompassDivider(
                          isExpanded: scroller.position.pixels <= 0,
                          // linesColor: data.type.fgColor,
                          linesColor: Colors.red,
                          compassColor: $styles.colors.offWhite,
                        ),
                      ),
                    ),
                  ),
                  Gap($styles.insets.sm),

                  /// Duration
                  if (data.startDate != null)
                    Text(
                      StringUtils.getDuration(data.startDate!, data.endDate),
                      style: $styles.text.h4,
                      textAlign: TextAlign.center,
                    ),
                  Gap($styles.insets.sm),

                  /// Date
                  Text(
                    $strings.titleLabelDate(
                        StringUtils.formatYrMth(data.startDate), StringUtils.formatYrMth(data.endDate)),
                    style: $styles.text.h4,
                    textAlign: TextAlign.center,
                  ),
                  Gap($styles.insets.sm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
