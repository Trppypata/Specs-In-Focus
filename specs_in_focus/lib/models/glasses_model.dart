class Glasses {
  final String id;
  final String name;
  final String description;
  final List<String> imageAssets;
  final String modelAsset;
  final double price;
  final List<String>? faceShapeRecommendations;
  final String? frameStyle;
  final String? frameColor;

  Glasses({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAssets,
    required this.modelAsset,
    this.price = 99.99,
    this.faceShapeRecommendations,
    this.frameStyle,
    this.frameColor,
  });

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrls': imageAssets,
      'price': price,
      'faceShapeRecommendations': faceShapeRecommendations,
      'frameStyle': frameStyle,
      'frameColor': frameColor,
    };
  }

  // Create from JSON
  factory Glasses.fromJson(Map<String, dynamic> json) {
    return Glasses(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageAssets: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : ['assets/images/glasses1.png'],
      modelAsset: 'assets/models/glasses1.glb', // Default model asset
      price: json['price']?.toDouble() ?? 99.99,
      faceShapeRecommendations: json['faceShapeRecommendations'] != null
          ? List<String>.from(json['faceShapeRecommendations'])
          : null,
      frameStyle: json['frameStyle'],
      frameColor: json['frameColor'],
    );
  }
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
        faceShapeRecommendations: ['round', 'heart'],
        frameStyle: 'Rectangle',
        frameColor: 'Blue',
      ),
      Glasses(
        id: '2',
        name: 'Classic Black',
        description: 'Timeless black frame for any occasion.',
        imageAssets: ['assets/images/astrid1.png'],
        modelAsset: 'assets/models/glasses2.glb',
        faceShapeRecommendations: ['round', 'diamond'],
        frameStyle: 'Square',
        frameColor: 'Black',
      ),
      Glasses(
        id: '3',
        name: 'Daria',
        description: 'Lightweight black frame for all occasions.',
        imageAssets: ['assets/images/daria1.png'],
        modelAsset: 'assets/models/glasses1.glb',
        faceShapeRecommendations: ['heart', 'diamond'],
        frameStyle: 'Cat Eye',
        frameColor: 'Black',
      ),
      Glasses(
        id: '4',
        name: 'Eleanor',
        description: 'Round frames perfect for vintage lovers.',
        imageAssets: ['assets/images/eleanor1.png'],
        modelAsset: 'assets/models/glasses2.glb',
        faceShapeRecommendations: ['oval', 'square'],
        frameStyle: 'Round',
        frameColor: 'Tortoise',
      ),
      Glasses(
        id: '5',
        name: 'Enid',
        description: 'Bright blue frames for a pop of color.',
        imageAssets: ['assets/images/enid1.png'],
        modelAsset: 'assets/models/glasses1.glb',
        faceShapeRecommendations: ['heart', 'oval'],
        frameStyle: 'Rectangle',
        frameColor: 'Blue',
      ),
      Glasses(
        id: '6',
        name: 'Greta',
        description: 'Minimalist clear frame design.',
        imageAssets: ['assets/images/greta1.png'],
        modelAsset: 'assets/models/glasses2.glb',
        faceShapeRecommendations: ['square', 'oval'],
        frameStyle: 'Round',
        frameColor: 'Clear',
      ),
      Glasses(
        id: '7',
        name: 'Noah',
        description: 'Bold tortoise pattern for a classic look.',
        imageAssets: ['assets/images/noah1.png'],
        modelAsset: 'assets/models/glasses1.glb',
        faceShapeRecommendations: ['round', 'heart'],
        frameStyle: 'Square',
        frameColor: 'Tortoise',
      ),
      Glasses(
        id: '8',
        name: 'Oliver',
        description: 'Soft pink frames, fun and stylish.',
        imageAssets: ['assets/images/oliver1.png'],
        modelAsset: 'assets/models/glasses2.glb',
        faceShapeRecommendations: ['heart', 'square'],
        frameStyle: 'Round',
        frameColor: 'Pink',
      ),
    ];
  }
}
