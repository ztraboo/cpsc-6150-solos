/// Used ChatGPT to help build out this Slider widget.
/// I had issues showing the percent labels under the slider ticks.

import 'package:flutter/material.dart';
import '../utils/app_palletes.dart';

/// A discrete slider that snaps to given tip percentages.
/// - tipOptions: e.g., [10, 15, 18, 20, 25]
/// - initialIndex: starting index into tipOptions
/// - onChangedIndex: callback with the new selected index
class TipSlider extends StatefulWidget {
  final List<int> tipOptions;
  final int initialIndex;
  final ValueChanged<int> onChangedIndex;
  final bool showTipPercent;
  final Palette? currentPalette;

  const TipSlider({
    super.key,
    required this.tipOptions,
    this.initialIndex = 0,
    required this.onChangedIndex,
    this.showTipPercent = false,
    this.currentPalette,
  });

  @override
  State<TipSlider> createState() => _TipSliderState();
}

class _TipSliderState extends State<TipSlider> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.tipOptions.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final divisions = widget.tipOptions.length - 1;
    final label = '${widget.tipOptions[_index]}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: label + current percent
        Visibility(
          visible: widget.showTipPercent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(
                'Tip %',
                style: widget.currentPalette?.titleMedium.copyWith(  // Theme.of(context).textTheme.titleMedium?.copyWith(
                    // color: Colors.black,
                  ),
                ),
              Text(label, style: widget.currentPalette?.titleMedium.copyWith( // Theme.of(context).textTheme.titleMedium?.copyWith(
                    // color: Colors.indigo,
                  ),
              ),
            ],
          ),
        ),
        Slider(
          value: _index.toDouble(),
          min: 0,
          max: divisions.toDouble(),
          divisions: divisions,
          label: label,
          onChanged: (double v) {
            final newIndex = v.round().clamp(0, divisions);
            debugPrint('TipSlider: onChanged: newIndex=$newIndex _index=$_index');
            if (newIndex != _index) {
              setState(() => _index = newIndex);

              // Notifiy parent of change in selected index
              widget.onChangedIndex(newIndex);
            }
          },
          activeColor: widget.currentPalette?.sliderActiveColor,
          inactiveColor: widget.currentPalette?.sliderInactiveColor,
        ),
        // Optional tick labels under the slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.tipOptions
                .map((p) => Text('$p%', style: widget.currentPalette?.bodyMedium.copyWith( // const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
                  // fontSize: 14,
                  // fontWeight: FontWeight.w600,
                )))
                .toList(),
          ),
        ),
      ],
    );
  }
}