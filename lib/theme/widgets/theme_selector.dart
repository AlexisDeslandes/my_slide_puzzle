import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

/// {@template theme_selector}
/// Give the possibility to select between default theme
/// and my theme.
/// {@endtemplate}
class ThemeSelector extends StatelessWidget {
  /// {@macro theme_selector}
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: BlocSelector<ThemeBloc, ThemeState, PuzzleTheme>(
          selector: (state) => state.theme,
          builder: (context, state) => Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                context.l10n.applybackgroundImage,
                style: PuzzleTextStyle.headline5,
              ),
              Switch(
                value: state is MyTheme,
                onChanged: (value) => context
                    .read<ThemeBloc>()
                    .add(ThemeChanged(themeIndex: value ? 1 : 0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
