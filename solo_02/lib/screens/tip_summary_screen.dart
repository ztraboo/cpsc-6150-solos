import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:input_quantity/input_quantity.dart';
import '../widgets/tip_slider.dart';
import '../utils/app_palletes.dart';

class TipSummaryScreen extends StatefulWidget {
  const TipSummaryScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TipSummaryScreen> createState() => _TipSummaryScreenState();
}

class _TipSummaryScreenState extends State<TipSummaryScreen> {

  double _totalAmount = 0.0;
  double _totalPerPerson = 0.0;
  int _splitPeopleCount = 1;
  final int _splitPeopleCountMin = 1;
  final int _splitPeopleCountMax = 20;
  double _tipAmount = 0.0;
  int _selectedTipIndex = 3; // default to 20%

  // 5 theme “seed” colors (change to whatever you like)
  final List<Palette> _palettes = <Palette>[
    Palette(name: 'White (default)', swatch: Colors.white, luminance: Luminance.light),
    Palette(name: 'Indigo', swatch: Colors.indigo, luminance: Luminance.dark),
    Palette(name: 'Teal', swatch: Colors.teal, luminance: Luminance.dark),
    Palette(name: 'Deep Orange (Shade 200)', swatch: Colors.deepOrange.shade200, luminance: Luminance.light),
    Palette(name: 'Purple', swatch: Colors.purple, luminance: Luminance.dark),
    Palette(name: 'Blue Grey (Shade 200)', swatch: Colors.blueGrey.shade200, luminance: Luminance.light),
  ];
  late Palette? _currentPalette = _palettes.first;

  late final TextEditingController _controllerBillAmount;

  Color currentBgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _controllerBillAmount = TextEditingController();
  }

  @override
  void dispose() {
    _controllerBillAmount.dispose();
    super.dispose();
  }

  // Change the current color palette.
  void changePalette() {
    setState(() {
      _currentPalette = _palettes[(_palettes.indexOf(_currentPalette!) + 1) % _palettes.length];
      currentBgColor = _currentPalette!.swatch;
    });
  }

  void _updateTotalPerPerson({double billAmount = 0.0, int numPeople = 1, double tipPercent = 20.0}) {
    // debugPrint('_updateTotalPerPerson: billAmount=$billAmount numPeople=$numPeople tipPercent=$tipPercent');

    setState(() {
      // Perform calculation here to update _totalPerPerson
      // This includes tip calculation after subtotal is entered
      _splitPeopleCount = numPeople.clamp(_splitPeopleCountMin, _splitPeopleCountMax);
      _tipAmount = billAmount * (tipPercent / 100);
      _totalAmount = billAmount + _tipAmount;
      _totalPerPerson = _totalAmount / _splitPeopleCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // Form keys to validate the tip input fields
    final formKeyTip = GlobalKey<FormState>();

    // Tip options and current selection (index into the list).
    final List<int> tipOptions = const [10, 15, 18, 20, 25];

    final int tipPercent = tipOptions[_selectedTipIndex];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,  // Make entire area tappable
      onTap: () {
        // Dismiss keyboard when tapping outside of TextField
        // FocusScope.of(context).unfocus();

        changePalette();
      },
      child: Scaffold(
        backgroundColor: currentBgColor,
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/tip_summary/1x/background.png'),
              fit: BoxFit.cover,            // <-- key: preserves aspect, no squashing
              alignment: Alignment.center,
            ),
            // put gradient on TOP of the image:
            // (use foregroundDecoration so you don't replace the image)
          ),
          child: SafeArea(
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                //
                // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                // action in the IDE, or press "p" in the console), to see the
                // wireframe for each widget.
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    margin: const EdgeInsets.all(20.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100.withAlpha(50),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'The following amounts include tips.',
                              style: _currentPalette?.bodyMedium.copyWith( // Theme.of(context).textTheme.bodyMedium
                                // color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Total Amount',
                                  style: _currentPalette?.titleSmall, //Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  '\$${_totalAmount.toStringAsFixed(2)}',
                                  style: _currentPalette?.headlineLarge?.copyWith( // Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    // color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Total Per Person',
                                  style: _currentPalette?.titleSmall, //Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  '\$${_totalPerPerson.toStringAsFixed(2)}',
                                  style: _currentPalette?.headlineLarge?.copyWith( // Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    // color: Colors.amber.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100.withAlpha(50),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.indigo.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Form(
                      key: formKeyTip,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bill Amount',
                                style: _currentPalette?.titleMedium, // Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(
                                width: 150,
                                  child: TextField(
                                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                    ],
                                    controller: _controllerBillAmount,
                                    decoration: InputDecoration(
                                      prefixText: '\$ ',
                                      labelText: 'US Dollar Amount',
                                      labelStyle: _currentPalette?.bodyMedium, // Theme.of(context).textTheme.bodyMedium,
                                      hintText: 'e.g., 123.45',
                                      hintStyle: _currentPalette?.bodyMedium.copyWith( // Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        // color: Colors.grey,
                                      ),
                                    ),
                                    onSubmitted: (value) => _updateTotalPerPerson(
                                      billAmount: double.tryParse(value) ?? 0.0,
                                      numPeople: _splitPeopleCount,
                                      tipPercent: tipPercent.toDouble(),
                                    ),
                                    style: _currentPalette?.titleMedium.copyWith( // Theme.of(context).textTheme.titleMedium?.copyWith(
                                      // color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Split',
                                style: _currentPalette?.titleMedium, // Theme.of(context).textTheme.titleMedium,
                              ),
                              // https://pub.dev/packages/input_quantity
                              InputQty.int( 
                                  initVal: _splitPeopleCount,
                                  minVal: _splitPeopleCountMin,
                                  maxVal: _splitPeopleCountMax,
                                  qtyFormProps: QtyFormProps(
                                    style: _currentPalette?.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ), // Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  decoration: QtyDecorationProps(
                                      qtyStyle: QtyStyle.classic,
                                      isBordered: false,
                                      borderShape: BorderShapeBtn.square,
                                      width: 12,
                                      btnColor: _currentPalette?.inputSplitCounterColor as Color,
                                      iconColor: _currentPalette?.inputSplitCounterColor as Color,
                                  ),
                                  onQtyChanged: (newSplit) {
                                    _updateTotalPerPerson(
                                      billAmount: double.tryParse(_controllerBillAmount.text) ?? 0.0,
                                      numPeople: newSplit,
                                      tipPercent: tipOptions[_selectedTipIndex].toDouble(),
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Required field";
                                    } else if (value >= 200) {
                                      return "More than available quantity";
                                    }
                                    return null;
                                  },
                              ), 
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tip',
                                style: _currentPalette?.titleMedium, // Theme.of(context).textTheme.titleMedium,
                              ),
                              Text('\$ ${_tipAmount.toStringAsFixed(2)}',
                                  style: _currentPalette?.titleMedium.copyWith( // Theme.of(context).textTheme.titleMedium?.copyWith(
                                    // color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                              ),
                            ],
                          ),
                          TipSlider(
                            tipOptions: tipOptions,
                            initialIndex: _selectedTipIndex,
                            onChangedIndex: (idx) => setState(() {
                              _selectedTipIndex = idx;
                              _updateTotalPerPerson(
                                billAmount: double.tryParse(_controllerBillAmount.text) ?? 0.0,
                                numPeople: _splitPeopleCount,
                                tipPercent: tipOptions[_selectedTipIndex].toDouble(),
                              );
                            }),
                            showTipPercent: false,
                            currentPalette: _currentPalette,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}