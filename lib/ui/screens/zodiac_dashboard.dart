import 'package:flutter/material.dart';
import 'package:solo_01/ui/services/zodiac_sign.dart';

class ZodiacDashboard extends StatelessWidget {
  const ZodiacDashboard({super.key});

  @override
  Widget build(BuildContext context) {

    // Define a list of zodiac signs for demonstration purposes.
    final List<ZodiacSign> locations = [
      ZodiacSign(
        name: 'Aries',
        dateRange: 'Mar 21 - Apr 19',
        element: 'Fire',
        symbol: 'Ram',
        rulingPlanet: 'Mars',
        description: 'Bold and pioneering; acts fast with courage and heat.',
      ),
      ZodiacSign(
        name: 'Taurus',
        dateRange: 'Apr 20 - May 20',
        element: 'Earth',
        symbol: 'Bull',
        rulingPlanet: 'Venus',
        description: 'Steady and sensual; loves comfort, beauty, and reliability.',
      ),
      ZodiacSign(
        name: 'Gemini',
        dateRange: 'May 21 - Jun 20',
        element: 'Air',
        symbol: 'Twins',
        rulingPlanet: 'Mercury',
        description: 'Curious and quick-minded; thrives on ideas and variety.',
      ),
      ZodiacSign(
        name: 'Cancer',
        dateRange: 'Jun 21 - Jul 22',
        element: 'Water',
        symbol: 'Crab',
        rulingPlanet: 'Moon',
        description: 'Nurturing and protective; intuitive with deep emotions.',
      ),
      ZodiacSign(
        name: 'Leo',
        dateRange: 'Jul 23 - Aug 22',
        element: 'Fire',
        symbol: 'Lion',
        rulingPlanet: 'Sun',
        description: 'Radiant and creative; leads with heart and generosity.',
      ),
      ZodiacSign(
        name: 'Virgo',
        dateRange: 'Aug 23 - Sep 22',
        element: 'Earth',
        symbol: 'Maiden',
        rulingPlanet: 'Mercury',
        description: 'Analytical and service-oriented; detail-minded and capable.',
      ),
      ZodiacSign(
        name: 'Libra',
        dateRange: 'Sep 23 - Oct 22',
        element: 'Air',
        symbol: 'Scales',
        rulingPlanet: 'Venus',
        description: 'Diplomatic and harmony-seeking; values balance and beauty.',
      ),
      ZodiacSign(
        name: 'Scorpio',
        dateRange: 'Oct 23 - Nov 21',
        element: 'Water',
        symbol: 'Scorpion',
        rulingPlanet: 'Pluto (Mars trad.)',
        description: 'Intense and transformative; loyal and emotionally powerful.',
      ),
      ZodiacSign(
        name: 'Sagittarius',
        dateRange: 'Nov 22 - Dec 21',
        element: 'Fire',
        symbol: 'Archer',
        rulingPlanet: 'Jupiter',
        description: 'Adventurous and big-picture; loves freedom and truth-seeking.',
      ),
      ZodiacSign(
        name: 'Capricorn',
        dateRange: 'Dec 22 - Jan 19',
        element: 'Earth',
        symbol: 'Sea-Goat',
        rulingPlanet: 'Saturn',
        description: 'Ambitious and disciplined; patient builder with long-term focus.',
      ),
      ZodiacSign(
        name: 'Aquarius',
        dateRange: 'Jan 20 - Feb 18',
        element: 'Air',
        symbol: 'Water-Bearer',
        rulingPlanet: 'Uranus (Saturn trad.)',
        description: 'Inventive and independent; humanitarian and future-minded.',
      ),
    ];

    final screen = MediaQuery.of(context).size;
    final avatarSize = screen.width * 0.28; // ~28% of width (tweak or clamp)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zodiac Dashboard'),
        backgroundColor: Colors.grey.shade800,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Color(0xFF2175c1),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Text(
                "The 12 Zodiac signs are arranged in order of their dates. Select any sign to see details.",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade200,
                )
              ),
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                    child: Card(
                        child: InkWell(
                          onTap: () {
                            // Navigate to Zodiac Detail screen
                            Navigator.pushNamed(context, '/zodiac_detail', arguments: {
                              'zodiacSign': locations[index]
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: 
                                  ColoredBox(
                                    color: Colors.indigo.shade800,     // your background value
                                    child: Image.asset(
                                        locations[index].imagePath(
                                          imageCategory: 'nobg',
                                          size: 2
                                        ),
                                        width: 125,   // make it huge
                                        height: 125,
                                        fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        locations[index].name,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        locations[index].dateRange,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                    ),
                  );
                }
            ),
          ),
        ],
      )
    );
  }
}
