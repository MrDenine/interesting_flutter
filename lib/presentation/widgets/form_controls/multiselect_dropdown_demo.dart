import 'package:flutter/material.dart';
import 'package:interesting_flutter/domain/entity/skill_entity.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Country> selectedCountries = [];
  List<String> selectedSkills = [];
  List<SkillEntity> selectedCustomSkills = [
    SkillEntity(
      skillCode: 'flutter_dev',
      skillType: 'Mobile Development',
      skillLevel: 3,
      name: 'Flutter Developer',
      description: 'Expert in building mobile applications using Flutter.',
    )
  ];

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

  List<SkillEntity> customSkill = [
    SkillEntity(
      skillCode: 'flutter_dev',
      skillType: 'Mobile Development',
      skillLevel: 3,
      name: 'Flutter Developer',
      description: 'Expert in building mobile applications using Flutter.',
    ),
    SkillEntity(
      skillCode: 'web_dev',
      skillType: 'Web Development',
      skillLevel: 4,
      name: 'Web Developer',
      description: 'Experienced in building responsive web applications.',
    ),
    SkillEntity(
      skillCode: 'data_sci',
      skillType: 'Data Science',
      skillLevel: 5,
      name: 'Data Scientist',
      description: 'Skilled in data analysis and machine learning.',
    ),
    SkillEntity(
      skillCode: 'ui_ux',
      skillType: 'UI/UX Design',
      skillLevel: 2,
      name: 'UI/UX Designer',
      description: 'Proficient in creating user-friendly interfaces.',
    ),
    SkillEntity(
      skillCode: 'backend_dev',
      skillType: 'Backend Development',
      skillLevel: 4,
      name: 'Backend Developer',
      description: 'Experienced in server-side development and API design.',
    ),
    SkillEntity(
      skillCode: 'devops_eng',
      skillType: 'DevOps',
      skillLevel: 3,
      name: 'DevOps Engineer',
      description: 'Skilled in CI/CD pipelines and cloud infrastructure.',
    ),
    SkillEntity(
      skillCode: 'ml_eng',
      skillType: 'Machine Learning',
      skillLevel: 5,
      name: 'ML Engineer',
      description:
          'Expert in machine learning algorithms and model deployment.',
    ),
    SkillEntity(
      skillCode: 'sys_arch',
      skillType: 'System Architecture',
      skillLevel: 4,
      name: 'System Architect',
      description: 'Experienced in designing scalable system architectures.',
    ),
    SkillEntity(
      skillCode: 'db_admin',
      skillType: 'Database Design',
      skillLevel: 3,
      name: 'Database Administrator',
      description: 'Proficient in database design and optimization.',
    ),
  ];

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Show results
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Form Submitted Successfully'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedCountries.isNotEmpty)
                Text(
                    'Countries: ${selectedCountries.map((c) => c.name).join(', ')}'),
              if (selectedSkills.isNotEmpty)
                Text('Skills: ${selectedSkills.join(', ')}'),
              if (selectedCustomSkills.isNotEmpty)
                Text(
                    'Custom Skills: ${selectedCustomSkills.map((c) => c.name).join(', ')}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Example 1: Regular MultiselectDropdown (for comparison)
          Text(
            'Regular MultiselectDropdown:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          MultiselectDropdown<Country>(
            label: 'Countries (Regular)',
            hint: 'Select countries you want to visit',
            items: countries.take(15).toList(),
            selectedValues: selectedCountries,
            displayStringForOption: (country) => country.name,
            searchHint: 'Search countries...',
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

          const SizedBox(height: 24),

          // Example 2: MultiselectDropdownFormField with validation
          Text(
            'MultiselectDropdownFormField Examples:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Skills dropdown with form field
          MultiselectDropdownFormField<String>(
            label: 'Skills (Required)',
            hint: 'Select your technical skills',
            items: skills,
            displayStringForOption: (skill) => skill,
            searchHint: 'Search skills...',
            maxSelections: 5,
            minSelections: 2,
            minSelectionsErrorMessage: 'Please select at least 2 skills',
            initialValue: selectedSkills,
            validator: (values) {
              if (values == null || values.length < 2) {
                return 'At least 2 skills are required';
              }
              if (values.length > 5) {
                return 'Maximum 5 skills allowed';
              }
              return null;
            },
            onSaved: (values) => selectedSkills = values ?? [],
            // autovalidateMode: AutovalidateMode.onUserInteraction,
          ),

          const SizedBox(height: 16),

          // Custom skills dropdown with form field
          MultiselectDropdownFormField<SkillEntity>(
            label: 'Specialized Skills (Required)',
            hint: 'Select specialized skills',
            items: customSkill,
            displayStringForOption: (skill) => skill.name,
            searchHint: 'Search specialized skills...',
            focusSearchOnOpen: false,
            showSelectAll: false,
            minSelections: 1,
            maxSelections: 4,
            showNumberOfSelected: false,
            innerPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            showClearSelectedItemButton: false,
            initialValue: selectedCustomSkills,
            validator: (values) {
              if (values == null || values.isEmpty) {
                return 'Please select at least one specialized skill';
              }
              return null;
            },
            onSaved: (values) => selectedCustomSkills = values ?? [],
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            itemBuilder: (skill) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  skill.skillType,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Form action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('Submit Form'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetForm,
                  child: const Text('Reset Form'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Summary
          if (selectedCountries.isNotEmpty ||
              selectedSkills.isNotEmpty ||
              selectedCustomSkills.isNotEmpty) ...[
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
                    'Current Selection Summary',
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
                  if (selectedCustomSkills.isNotEmpty) ...[
                    Text(
                      'Specialized Skills: ${selectedCustomSkills.map((c) => c.name).join(', ')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ]
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
