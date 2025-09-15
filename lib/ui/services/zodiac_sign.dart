
class ZodiacSign {
    final String name;
    final String dateRange;
    final String element;
    final String symbol;
    final String rulingPlanet;
    final String description;
    
    ZodiacSign({
        required this.name,
        required this.dateRange,
        required this.element,
        required this.symbol,
        required this.rulingPlanet,
        required this.description,
    });

    get imagePath => ( { int size = 1, String imageCategory = 'frame' } ) {
        String basePath = 'assets/images/${name.toLowerCase()}';

        switch (size) {
            case 2: return '$basePath/2.0x/${name.toLowerCase()}_$imageCategory.png';
            case 3: return '$basePath/3.0x/${name.toLowerCase()}_$imageCategory.png';
            default: return '$basePath/${name.toLowerCase()}_$imageCategory.png';
        }
    };
}