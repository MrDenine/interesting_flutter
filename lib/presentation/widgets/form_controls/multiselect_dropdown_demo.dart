import 'package:flutter/material.dart';
import 'multiselect_dropdown.dart';

class MultiselectDropdownDemo extends StatefulWidget {
  const MultiselectDropdownDemo({super.key});

  @override
  State<MultiselectDropdownDemo> createState() =>
      _MultiselectDropdownDemoState();
}

class Country {
  final String name;
  final String code;
  final String flag;

  const Country(this.name, this.code, this.flag);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country && other.name == name && other.code == code;
  }

  @override
  int get hashCode => name.hashCode ^ code.hashCode;
}

class _MultiselectDropdownDemoState extends State<MultiselectDropdownDemo> {
  List<Country> selectedCountries = [];
  List<String> selectedSkills = [];

  static const List<Country> countries = [
    Country('United States', 'US', '🇺🇸'),
    Country('Canada', 'CA', '🇨🇦'),
    Country('United Kingdom', 'GB', '🇬🇧'),
    Country('Germany', 'DE', '🇩🇪'),
    Country('France', 'FR', '🇫🇷'),
    Country('Japan', 'JP', '🇯🇵'),
    Country('South Korea', 'KR', '🇰🇷'),
    Country('Australia', 'AU', '🇦🇺'),
    Country('Brazil', 'BR', '🇧🇷'),
    Country('India', 'IN', '🇮🇳'),
    Country('China', 'CN', '🇨🇳'),
    Country('Russia', 'RU', '🇷🇺'),
    Country('Italy', 'IT', '🇮🇹'),
    Country('Spain', 'ES', '🇪🇸'),
    Country('Netherlands', 'NL', '🇳🇱'),
    Country('Sweden', 'SE', '🇸🇪'),
    Country('Norway', 'NO', '🇳🇴'),
    Country('Denmark', 'DK', '🇩🇰'),
    Country('Finland', 'FI', '🇫🇮'),
    Country('Switzerland', 'CH', '🇨🇭'),
  ];

  static const List<String> skills = [
    'Frontend Development',
    'Backend Development',
    'Mobile Development',
    'DevOps',
    'Cloud Computing',
    'Machine Learning',
    'Data Science',
    'Database Design',
    'UI/UX Design',
    'System Architecture',
    'API Development',
    'Testing & QA',
    'Project Management',
    'Agile Methodology',
    'Version Control (Git)',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Countries dropdown
        MultiselectDropdown<Country>(
          label: 'Countries',
          hint: 'Select countries you want to visit',
          items: countries.take(15).toList(), // More items to showcase height
          selectedValues: selectedCountries,
          displayStringForOption: (country) => country.name,
          searchHint: 'Search countries...',
          // No maxHeight specified - will use dynamic sizing
          onChanged: (selected) {
            setState(() {
              selectedCountries = selected;
            });
          },
          itemBuilder: (country) => Row(
            children: [
              Text(
                country.flag,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  country.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Programming languages dropdown
        MultiselectDropdown<String>(
          label: 'Skills',
          hint: 'Select your skills',
          items: skills, // Show all skills
          selectedValues: selectedSkills,
          displayStringForOption: (skill) => skill,
          searchHint: 'Search skills...',
          // No maxHeight specified - will use dynamic sizing
          maxSelections: 5,
          onChanged: (selected) {
            setState(() {
              selectedSkills = selected;
            });
          },
        ),

        const SizedBox(height: 16),

        // Summary
        if (selectedCountries.isNotEmpty || selectedSkills.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selection Summary',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                if (selectedCountries.isNotEmpty)
                  Text(
                    'Countries: ${selectedCountries.map((c) => c.name).join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (selectedSkills.isNotEmpty)
                  Text(
                    'Skills: ${selectedSkills.join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
