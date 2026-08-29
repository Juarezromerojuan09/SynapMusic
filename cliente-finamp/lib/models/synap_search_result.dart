class SynapSearchResult {
  final String title;
  final String artist;
  final String album;
  final String duration;
  final String url;
  final String coverUrl;
  final String? source;
  final String? queryString;

  SynapSearchResult({
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.url,
    required this.coverUrl,
    this.source,
    this.queryString,
  });

  factory SynapSearchResult.fromJson(Map<String, dynamic> json) {
    return SynapSearchResult(
      title: json['title'] ?? 'Unknown Title',
      artist: json['artist'] ?? 'Unknown Artist',
      album: json['album'] ?? 'Unknown Album',
      duration: json['duration'] ?? '',
      url: json['url'] ?? '',
      coverUrl: json['cover_url'] ?? '',
      source: json['source'],
      queryString: json['query_string'],
    );
  }
}
