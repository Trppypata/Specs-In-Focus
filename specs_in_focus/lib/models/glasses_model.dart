class Glasses {
  final String id;
  final String name;
  final String description;
  final List<String> imageAssets;
  final String modelAsset;
  final double price;

  Glasses({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAssets,
    required this.modelAsset,
    this.price = 99.99,
  });
}

class GlassesRepository {
  static List<Glasses> getAllGlasses() {
    return [
      Glasses(
        id: '1',
        name: 'Stylish Blue Frame',
        description: 'Modern blue frame with polarized lenses.',
        imageAssets: ['assets/images/andy1.png'],
        modelAsset: 'assets/models/glasses1.glb',
      ),
      Glasses(
        id: '2',
        name: 'Classic Black',
        description: 'Timeless black frame for any occasion.',
        imageAssets: ['assets/images/astrid1.png'],
        modelAsset: 'assets/models/glasses2.glb',
      ),
      Glasses(
        id: '3',
        name: 'Daria',
        description: 'Lightweight black frame for all occasions.',
        imageAssets: ['assets/images/daria1.png'],
        modelAsset: 'assets/models/glasses1.glb',
      ),
      Glasses(
        id: '4',
        name: 'Eleanor',
        description: 'Round frames perfect for vintage lovers.',
        imageAssets: ['assets/images/eleanor1.png'],
        modelAsset: 'assets/models/glasses2.glb',
      ),
      Glasses(
        id: '5',
        name: 'Enid',
        description: 'Bright blue frames for a pop of color.',
        imageAssets: ['assets/images/enid1.png'],
        modelAsset: 'assets/models/glasses1.glb',
      ),
      Glasses(
        id: '6',
        name: 'Greta',
        description: 'Minimalist clear frame design.',
        imageAssets: ['assets/images/greta1.png'],
        modelAsset: 'assets/models/glasses2.glb',
      ),
      Glasses(
        id: '7',
        name: 'Noah',
        description: 'Bold tortoise pattern for a classic look.',
        imageAssets: ['assets/images/noah1.png'],
        modelAsset: 'assets/models/glasses1.glb',
      ),
      Glasses(
        id: '8',
        name: 'Oliver',
        description: 'Soft pink frames, fun and stylish.',
        imageAssets: ['assets/images/oliver1.png'],
        modelAsset: 'assets/models/glasses2.glb',
      ),
    ];
  }
}
