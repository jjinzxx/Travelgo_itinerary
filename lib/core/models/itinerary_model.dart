class Author {
  final String name;
  final String? profileImage;

  Author({required this.name, this.profileImage});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] ?? 'Unknown User',
      profileImage: json['profile_image_url'],
    );
  }
}

class Itinerary {
  final int id;
  final String userId;
  final String title;
  final String? description;
  final String? coverImageUrl; 
  final DateTime? startDate;
  final DateTime? endDate;
  final String? theme;
  final int viewCount;
  final int likeCount;
  final int placeCount;
  final String postOption;   
  final Author? author;      
  final List<Author> members; 

  Itinerary({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.coverImageUrl,
    this.startDate,
    this.endDate,
    this.theme,
    this.viewCount = 0,
    this.likeCount = 0,
    this.placeCount = 0,
    required this.postOption,
    this.author,
    this.members = const [],
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    var membersList = <Author>[];
    if (json['ItineraryMember'] != null) {
      membersList = (json['ItineraryMember'] as List).map((m) {
        return Author.fromJson(m['Users']);
      }).toList();
    }

    return Itinerary(
      id: json['itinerary_id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      description: json['description'],
      coverImageUrl: json['Itinerary_image_url'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      theme: json['theme'],
      viewCount: json['view_count'] ?? 0,
      likeCount: (json['ItineraryLikes'] as List?)?.isNotEmpty == true ? json['ItineraryLikes'][0]['count'] as int : 0,
      placeCount: (json['ItineraryPlace'] as List?)?.isNotEmpty == true ? json['ItineraryPlace'][0]['count'] as int : 0,

      // JSON의 'post_option' 값을 Dart의 postOption 변수에 저장, 값이 없으면 안전하게 'private'을 기본값으로 사용
      postOption: json['post_option'] ?? 'private',

      author: json['Users'] != null ? Author.fromJson(json['Users']) : null,
      members: membersList, // 멤버 리스트 매핑
    );
  }
}

// 장소 정보 (DB의 'Place' 테이블)
class Place {
  final int id;
  final String name;
  final String? nameKr;
  final String? nameEn;
  final String? description;
  final String? description_en;
  final String? description_kr;
  final String? category;

  Place({
    required this.id,
    required this.name,
    this.nameKr,
    this.nameEn,
    this.description,
    this.description_en,
    this.description_kr,
    this.category,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['place_id'],
      name: json['name_en'] ?? json['name_kr'] ?? json['name'] ?? 'Unknown',
      nameKr: json['name_kr'],
      nameEn: json['name_en'],
      description: json['description_en']?? json['description_kr'] ?? json['description'] ?? 'Unknown',
      description_en: json['description_en'],
      description_kr: json['description_kr'],
      category: json['category'],
    );
  }
}

// 일정에 등록된 장소 항목 (DB의 'ItineraryPlace' 테이블 + Join된 Place)
class ItineraryItem {
  final int routeId;      // 고유 ID (PK)
  final int itineraryId;  // 어느 여행인지
  final Place? place;     // 어떤 장소인지 (Place 객체가 여기 쏙 들어감)
  final int dayId;        // 몇 일차인지 (Day 1, Day 2...)
  final int dayNum;       // 몇 일차인지 (1, 2, 3...)

  ItineraryItem({
    required this.routeId,
    required this.itineraryId,
    this.place,
    required this.dayId,
    this.dayNum = 1,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    int parsedDayNum = 1;
    if (json['ItineraryDay'] != null) {
      parsedDayNum = json['ItineraryDay']['day_num'] ?? 1;
    }

    return ItineraryItem(
      routeId: json['route_id'], // itinerary_place 테이블의 PK
      itineraryId: json['itinerary_id'],
      dayId: json['day_id'] ?? 1,
      dayNum: parsedDayNum,
      place: json['Place'] != null ? Place.fromJson(json['Place']) : null,
    );
  }
}

class Region {
  final int id;
  final String nameEn;
  final String? nameKr;

  Region({required this.id, required this.nameEn, this.nameKr});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['region_id'],
      nameEn: json['city_name_en'],
      nameKr: json['city_name_kr'],
    );
  }
}
