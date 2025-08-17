/// SpaceX Launch Site model
class SpaceXLaunchSite {
  final String siteId;
  final String siteName;
  final String? siteNameLong;

  const SpaceXLaunchSite({
    required this.siteId,
    required this.siteName,
    this.siteNameLong,
  });

  factory SpaceXLaunchSite.fromJson(Map<String, dynamic> json) {
    return SpaceXLaunchSite(
      siteId: json['site_id'] ?? '',
      siteName: json['site_name'] ?? '',
      siteNameLong: json['site_name_long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site_id': siteId,
      'site_name': siteName,
      'site_name_long': siteNameLong,
    };
  }
}

/// SpaceX Links model
class SpaceXLinks {
  final String? missionPatch;
  final String? missionPatchSmall;
  final String? articleLink;
  final String? videoLink;
  final String? wikipedia;
  final List<String>? flickrImages;

  const SpaceXLinks({
    this.missionPatch,
    this.missionPatchSmall,
    this.articleLink,
    this.videoLink,
    this.wikipedia,
    this.flickrImages,
  });

  factory SpaceXLinks.fromJson(Map<String, dynamic> json) {
    return SpaceXLinks(
      missionPatch: json['mission_patch'],
      missionPatchSmall: json['mission_patch_small'],
      articleLink: json['article_link'],
      videoLink: json['video_link'],
      wikipedia: json['wikipedia'],
      flickrImages: json['flickr_images'] != null
          ? List<String>.from(json['flickr_images'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mission_patch': missionPatch,
      'mission_patch_small': missionPatchSmall,
      'article_link': articleLink,
      'video_link': videoLink,
      'wikipedia': wikipedia,
      'flickr_images': flickrImages,
    };
  }
}
