
class Presence {
  String id;
  String name;
  String info;
  String status;
  DateTime timestamp;
  String photo;

  Presence({
    required this.id,
    required this.name,
    required this.info,
    required this.status,
    required this.photo,
    required this.timestamp,


  });

  factory Presence.fromJson(Map<String, dynamic> json) => Presence(
    id: json["id"],
    name: json["name"],
    info: json["info"],
    status: json["status"],
    photo: json['photo'],
    timestamp: json['timestamp'],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "info": info,
    "status": status,
    "photo": photo,
    "timestamp": timestamp,

  };
}