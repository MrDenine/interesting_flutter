import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class DatePickerFields extends StatefulWidget {
  const DatePickerFields({super.key});

  @override
  State<DatePickerFields> createState() => _DatePickerFieldsState();
}

class _DatePickerFieldsState extends State<DatePickerFields> {
  DateTime? _selectedDate;
  DateTime? _selectedDateRange;
  DateTime? _selectedTime;
  DateTime? _selectedDateTime;
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date Picker Widgets',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Material Date Picker
          CustomDatePickerField(
            label: 'Select Date',
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 20),

          // Date Range Picker
          DateRangePickerField(
            label: 'Select Date Range',
            selectedRange: _dateRange,
            onRangeSelected: (range) {
              setState(() {
                _dateRange = range;
              });
            },
          ),
          const SizedBox(height: 20),

          // Time Picker
          TimePickerField(
            label: 'Select Time',
            selectedTime: _selectedTime,
            onTimeSelected: (time) {
              setState(() {
                _selectedTime = time;
              });
            },
          ),
          const SizedBox(height: 20),

          // DateTime Picker
          DateTimePickerField(
            label: 'Select Date & Time',
            selectedDateTime: _selectedDateTime,
            onDateTimeSelected: (dateTime) {
              setState(() {
                _selectedDateTime = dateTime;
              });
            },
          ),
          const SizedBox(height: 20),

          // iOS Style Date Picker (if on iOS or for demo)
          if (Platform.isIOS || true) ...[
            CupertinoDatePickerField(
              label: 'iOS Style Date Picker',
              selectedDate: _selectedDateRange,
              onDateSelected: (date) {
                setState(() {
                  _selectedDateRange = date;
                });
              },
            ),
            const SizedBox(height: 20),
          ],

          // Summary card
          if (_selectedDate != null ||
              _dateRange != null ||
              _selectedTime != null ||
              _selectedDateTime != null ||
              _selectedDateRange != null) ...[
            _buildSummaryCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Selected Values',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedDate != null) ...[
            _buildSummaryRow('Date', _formatDate(_selectedDate!)),
            const SizedBox(height: 8),
          ],
          if (_dateRange != null) ...[
            _buildSummaryRow(
              'Date Range',
              '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}',
            ),
            const SizedBox(height: 8),
          ],
          if (_selectedTime != null) ...[
            _buildSummaryRow('Time', _formatTime(_selectedTime!)),
            const SizedBox(height: 8),
          ],
          if (_selectedDateTime != null) ...[
            _buildSummaryRow(
                'Date & Time', _formatDateTime(_selectedDateTime!)),
            const SizedBox(height: 8),
          ],
          if (_selectedDateRange != null) ...[
            _buildSummaryRow('iOS Date', _formatDate(_selectedDateRange!)),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  }
}

// Custom Material Date Picker Field
class CustomDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hint;

  const CustomDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showDatePicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    selectedDate != null ? Colors.blue : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selectedDate != null
                  ? Colors.blue.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.05),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: selectedDate != null ? Colors.blue : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate!)
                        : hint ?? 'Select a date',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.black87
                          : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (selectedDate != null) ...[
                  IconButton(
                    onPressed: () => onDateSelected(null),
                    icon: const Icon(Icons.clear, size: 20),
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.blue,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}

// Date Range Picker Field
class DateRangePickerField extends StatelessWidget {
  final String label;
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange?) onRangeSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DateRangePickerField({
    super.key,
    required this.label,
    required this.selectedRange,
    required this.onRangeSelected,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showDateRangePicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    selectedRange != null ? Colors.green : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selectedRange != null
                  ? Colors.green.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.05),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range,
                  color: selectedRange != null ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedRange != null
                        ? '${_formatDate(selectedRange!.start)} - ${_formatDate(selectedRange!.end)}'
                        : 'Select date range',
                    style: TextStyle(
                      color: selectedRange != null
                          ? Colors.black87
                          : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (selectedRange != null) ...[
                  IconButton(
                    onPressed: () => onRangeSelected(null),
                    icon: const Icon(Icons.clear, size: 20),
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      initialDateRange: selectedRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.green,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onRangeSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Time Picker Field
class TimePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedTime;
  final Function(DateTime?) onTimeSelected;

  const TimePickerField({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showTimePicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    selectedTime != null ? Colors.orange : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selectedTime != null
                  ? Colors.orange.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.05),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: selectedTime != null ? Colors.orange : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedTime != null
                        ? _formatTime(selectedTime!)
                        : 'Select time',
                    style: TextStyle(
                      color: selectedTime != null
                          ? Colors.black87
                          : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (selectedTime != null) ...[
                  IconButton(
                    onPressed: () => onTimeSelected(null),
                    icon: const Icon(Icons.clear, size: 20),
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime != null
          ? TimeOfDay.fromDateTime(selectedTime!)
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.orange,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      onTimeSelected(dateTime);
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// Date Time Picker Field
class DateTimePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDateTime;
  final Function(DateTime?) onDateTimeSelected;

  const DateTimePickerField({
    super.key,
    required this.label,
    required this.selectedDateTime,
    required this.onDateTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showDateTimePicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedDateTime != null
                    ? Colors.purple
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selectedDateTime != null
                  ? Colors.purple.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.05),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event_available,
                  color: selectedDateTime != null ? Colors.purple : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDateTime != null
                        ? _formatDateTime(selectedDateTime!)
                        : 'Select date and time',
                    style: TextStyle(
                      color: selectedDateTime != null
                          ? Colors.black87
                          : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (selectedDateTime != null) ...[
                  IconButton(
                    onPressed: () => onDateTimeSelected(null),
                    icon: const Icon(Icons.clear, size: 20),
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    // First pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.purple,
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && context.mounted) {
      // Then pick time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedDateTime != null
            ? TimeOfDay.fromDateTime(selectedDateTime!)
            : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Colors.purple,
                  ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateTimeSelected(dateTime);
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${dateTime.day} ${months[dateTime.month]} ${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// iOS Style Cupertino Date Picker Field
class CupertinoDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;

  const CupertinoDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showCupertinoDatePicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    selectedDate != null ? Colors.cyan : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selectedDate != null
                  ? Colors.cyan.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.05),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.calendar,
                  color: selectedDate != null ? Colors.cyan : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate!)
                        : 'Select date (iOS style)',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.black87
                          : Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (selectedDate != null) ...[
                  IconButton(
                    onPressed: () => onDateSelected(null),
                    icon: const Icon(Icons.clear, size: 20),
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCupertinoDatePicker(BuildContext context) async {
    DateTime tempDate = selectedDate ?? DateTime.now();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(bottomSheetContext).pop(),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onDateSelected(tempDate);
                        Navigator.of(bottomSheetContext).pop();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Date Picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
