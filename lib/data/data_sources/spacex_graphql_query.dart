/// GraphQL operations and queries for SpaceX API
class SpaceXGraphQueries {
  /// Query to get all launches
  static const String getAllLaunches = '''
    query GetLaunches(\$limit: Int, \$offset: Int) {
      launches(limit: \$limit, offset: \$offset) {
        id
        mission_name
        launch_date_local
        launch_success
        details
        rocket {
          rocket_name
          rocket_type
        }
        launch_site {
          site_id
          site_name
          site_name_long
        }
        links {
          mission_patch
          mission_patch_small
          article_link
          video_link
          flickr_images
        }
      }
    }
  ''';

  /// Query to get launch by ID
  static const String getLaunchById = '''
    query GetLaunch(\$id: ID!) {
      launch(id: \$id) {
        id
        mission_name
        launch_date_local
        launch_success
        details
        rocket {
          rocket_id
          rocket_name
          rocket_type
          description
          height {
            meters
            feet
          }
          mass {
            kg
            lb
          }
          engines {
            number
            type
            version
            propellant_1
            propellant_2
          }
        }
        launch_site {
          site_id
          site_name
          site_name_long
        }
        links {
          mission_patch
          mission_patch_small
          article_link
          video_link
          flickr_images
          wikipedia
        }
      }
    }
  ''';

  /// Query to get all rockets
  static const String getAllRockets = '''
    query GetRockets {
      rockets {
        id
        rocket_id
        rocket_name
        rocket_type
        active
        stages
        boosters
        cost_per_launch
        success_rate_pct
        first_flight
        country
        company
        height {
          meters
          feet
        }
        diameter {
          meters
          feet
        }
        mass {
          kg
          lb
        }
        engines {
          number
          type
          version
          layout
          engine_loss_max
          propellant_1
          propellant_2
          thrust_sea_level {
            kN
            lbf
          }
          thrust_vacuum {
            kN
            lbf
          }
        }
        landing_legs {
          number
          material
        }
        flickr_images
        wikipedia
        description
      }
    }
  ''';

  /// Query to get rocket by ID
  static const String getRocketById = '''
    query GetRocket(\$id: ID!) {
      rocket(id: \$id) {
        id
        rocket_id
        rocket_name
        rocket_type
        active
        stages
        boosters
        cost_per_launch
        success_rate_pct
        first_flight
        country
        company
        height {
          meters
          feet
        }
        diameter {
          meters
          feet
        }
        mass {
          kg
          lb
        }
        engines {
          number
          type
          version
          layout
          engine_loss_max
          propellant_1
          propellant_2
          thrust_sea_level {
            kN
            lbf
          }
          thrust_vacuum {
            kN
            lbf
          }
        }
        landing_legs {
          number
          material
        }
        flickr_images
        wikipedia
        description
      }
    }
  ''';

  /// Query to get upcoming launches
  static const String getUpcomingLaunches = '''
    query GetUpcomingLaunches(\$limit: Int) {
      launchesUpcoming(limit: \$limit) {
        id
        mission_name
        launch_date_local
        rocket {
          rocket_id
          rocket_name
          rocket_type
        }
        launch_site {
          site_id
          site_name
        }
        links {
          mission_patch_small
        }
      }
    }
  ''';

  /// Query to get past launches
  static const String getPastLaunches = '''
    query GetPastLaunches(\$limit: Int, \$offset: Int) {
      launchesPast(limit: \$limit, offset: \$offset, order: "desc", sort: "launch_date_local") {
        id
        mission_name
        launch_date_local
        launch_success
        rocket {
          rocket_id
          rocket_name
        }
        launch_site {
          site_name
        }
        links {
          mission_patch_small
          article_link
          video_link
        }
      }
    }
  ''';

  /// Query to get company info
  static const String getCompanyInfo = '''
    query GetCompanyInfo {
      company {
        name
        founder
        founded
        employees
        vehicles
        launch_sites
        test_sites
        ceo
        cto
        coo
        cto_propulsion
        valuation
        headquarters {
          address
          city
          state
        }
        summary
      }
    }
  ''';
}
