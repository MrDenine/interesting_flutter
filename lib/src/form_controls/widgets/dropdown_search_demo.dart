import 'package:flutter/material.dart';
import 'dropdown_search.dart';

class DropdownSearchDemo extends StatefulWidget {
  const DropdownSearchDemo({super.key});

  @override
  State<DropdownSearchDemo> createState() => _DropdownSearchDemoState();
}

class _DropdownSearchDemoState extends State<DropdownSearchDemo> {
  String? selectedCountry;
  String? selectedLanguage;
  City? selectedCity;

  final List<String> countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'France',
    'Japan',
    'Australia',
    'Brazil',
    'India',
    'China',
    'Mexico',
    'Italy',
    'Spain',
    'Netherlands',
    'Sweden',
  ];

  final List<String> programmingLanguages = [
    'Dart',
    'Flutter',
    'JavaScript',
    'TypeScript',
    'Python',
    'Java',
    'C++',
    'C#',
    'Go',
    'Rust',
    'Swift',
    'Kotlin',
    'PHP',
    'Ruby',
    'Scala',
  ];

  final List<City> cities = [
    City('New York', 'USA', '🇺🇸'),
    City('London', 'UK', '🇬🇧'),
    City('Tokyo', 'Japan', '🇯🇵'),
    City('Paris', 'France', '🇫🇷'),
    City('Berlin', 'Germany', '🇩🇪'),
    City('Sydney', 'Australia', '🇦🇺'),
    City('Toronto', 'Canada', '🇨🇦'),
    City('Mumbai', 'India', '🇮🇳'),
    City('São Paulo', 'Brazil', '🇧🇷'),
    City('Seoul', 'South Korea', '🇰🇷'),
    City('Amsterdam', 'Netherlands', '🇳🇱'),
    City('Barcelona', 'Spain', '🇪🇸'),
    City('Rome', 'Italy', '🇮🇹'),
    City('Stockholm', 'Sweden', '🇸🇪'),
    City('Mexico City', 'Mexico', '🇲🇽'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Countries Dropdown
        SearchableDropdown<String>(
          label: 'Select Country',
          hint: 'Choose your country',
          items: countries,
          value: selectedCountry,
          displayStringForOption: (country) => country,
          onChanged: (value) {
            setState(() {
              selectedCountry = value;
            });
          },
        ),

        const SizedBox(height: 16),

        // Programming Languages Dropdown
        SearchableDropdown<String>(
          label: 'Programming Language',
          hint: 'Choose your favorite language',
          items: programmingLanguages,
          value: selectedLanguage,
          displayStringForOption: (language) => language,
          itemBuilder: (language) => Row(
            children: [
              _getLanguageIcon(language),
              const SizedBox(width: 8),
              Text(language),
            ],
          ),
          onChanged: (value) {
            setState(() {
              selectedLanguage = value;
            });
          },
        ),

        const SizedBox(height: 16),

        // Cities Dropdown with Custom Display
        SearchableDropdown<City>(
          label: 'Select City',
          hint: 'Choose a city',
          items: cities,
          value: selectedCity,
          displayStringForOption: (city) =>
              '${city.flag} ${city.name}, ${city.country}',
          itemBuilder: (city) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    city.flag,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    city.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 26),
                child: Text(
                  city.country,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
        ),

        const SizedBox(height: 24),

        // Selection Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Selections:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              _buildSelectionRow('Country', selectedCountry ?? 'Not selected'),
              _buildSelectionRow(
                  'Language', selectedLanguage ?? 'Not selected'),
              _buildSelectionRow(
                  'City',
                  selectedCity != null
                      ? '${selectedCity!.flag} ${selectedCity!.name}, ${selectedCity!.country}'
                      : 'Not selected'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: value == 'Not selected'
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLanguageIcon(String language) {
    final iconMap = {
      'Dart': '🎯',
      'Flutter': '💙',
      'JavaScript': '🟨',
      'TypeScript': '🔷',
      'Python': '🐍',
      'Java': '☕',
      'C++': '⚡',
      'C#': '🔵',
      'Go': '🔴',
      'Rust': '🦀',
      'Swift': '🍎',
      'Kotlin': '🟣',
      'PHP': '🐘',
      'Ruby': '💎',
      'Scala': '🔥',
    };

    return Text(
      iconMap[language] ?? '📝',
      style: const TextStyle(fontSize: 16),
    );
  }
}

class City {
  final String name;
  final String country;
  final String flag;

  const City(this.name, this.country, this.flag);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          country == other.country;

  @override
  int get hashCode => name.hashCode ^ country.hashCode;
}
