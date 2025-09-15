import 'package:flutter/material.dart';
import 'package:solo_01/ui/services/zodiac_sign.dart';

class ZodiacDetailsPage extends StatelessWidget {
  final ZodiacSign zodiacSign;

  const ZodiacDetailsPage({super.key, required this.zodiacSign});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final avatarSize = screen.width * 0.85; // ~50% of width (tweak or clamp)  

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade800,
        title: Text('${zodiacSign.name} Details'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey.shade800,
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Swipe up/down to see more',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: PageView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              children: [
              Image.asset(
                zodiacSign.imagePath(imageCategory: 'frame', size: 1),
                width: avatarSize,
                // height: double.infinity,
                fit: BoxFit.contain,
              ),
              Container(
                color: Colors.grey.shade400,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, // center horizontally
                            children: [
                              Text(
                                'Date Range: ',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '${zodiacSign.dateRange}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // center horizontally
                          children: [
                            Text(
                              'Element: ',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '${zodiacSign.element}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // center horizontally
                          children: [
                            Text(
                              'Symbol: ',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '${zodiacSign.symbol}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // center horizontally
                          children: [
                            Text(
                              'Ruling Planet: ',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '${zodiacSign.rulingPlanet}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // center horizontally
              children: [
                Container(
                  color: Colors.grey.shade400,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      zodiacSign.description,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // align to start (left)
                    children: [
                      Text(
                        'Daily Quote',
                        style: TextStyle(
                          fontSize: 25,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'More details coming soon...',
                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // align to start (left)
                    children: [
                      Text(
                        'Monthly Quote',
                        style: TextStyle(
                          fontSize: 25,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'More details coming soon...',
                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // align to start (left)
                    children: [
                      Text(
                        'Yearly Quote',
                        style: TextStyle(
                          fontSize: 25,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'More details coming soon...',
                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}
