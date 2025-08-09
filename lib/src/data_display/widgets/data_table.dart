import 'package:flutter/material.dart';

class AnimatedDataTable extends StatefulWidget {
  const AnimatedDataTable({super.key});

  @override
  State<AnimatedDataTable> createState() => _AnimatedDataTableState();
}

class _AnimatedDataTableState extends State<AnimatedDataTable>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  final List<UserData> _users = [
    UserData('Alice Johnson', 'alice@example.com', 28, 'Designer', 'New York',
        '2020-01-15'),
    UserData('Bob Smith', 'bob@example.com', 35, 'Developer', 'San Francisco',
        '2019-03-22'),
    UserData('Carol Brown', 'carol@example.com', 42, 'Manager', 'Chicago',
        '2018-07-10'),
    UserData('David Wilson', 'david@example.com', 31, 'Developer', 'Austin',
        '2021-05-08'),
    UserData('Emma Davis', 'emma@example.com', 26, 'Designer', 'Seattle',
        '2022-02-12'),
    UserData('Frank Miller', 'frank@example.com', 39, 'Analyst', 'Boston',
        '2019-11-30'),
    UserData('Grace Lee', 'grace@example.com', 33, 'Product Manager',
        'Los Angeles', '2020-09-18'),
    UserData('Henry Clark', 'henry@example.com', 29, 'UX Designer', 'Portland',
        '2021-12-05'),
    UserData('Ivy Rodriguez', 'ivy@example.com', 37, 'Senior Developer',
        'Miami', '2018-04-25'),
    UserData('Jack Thompson', 'jack@example.com', 41, 'Tech Lead', 'Denver',
        '2017-08-14'),
    UserData('Kelly Martinez', 'kelly@example.com', 24, 'Junior Designer',
        'Phoenix', '2023-01-20'),
    UserData('Liam Anderson', 'liam@example.com', 45, 'Engineering Manager',
        'Atlanta', '2016-10-03'),
    UserData('Maya Patel', 'maya@example.com', 32, 'Data Analyst', 'San Diego',
        '2020-06-17'),
    UserData('Noah Garcia', 'noah@example.com', 27, 'Frontend Developer',
        'Nashville', '2022-08-09'),
    UserData('Olivia Wright', 'olivia@example.com', 36, 'Backend Developer',
        'Orlando', '2019-12-11'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sort<T>(
      Comparable<T> Function(UserData user) getField, int columnIndex) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = !_sortAscending;
      _users.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return _sortAscending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: Container(
              height: 280, // Fixed height for vertical scrolling
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dataTableTheme: DataTableThemeData(
                          headingRowColor:
                              WidgetStateProperty.all(Colors.grey.shade50),
                        ),
                      ),
                      child: DataTable(
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        columns: [
                          DataColumn(
                            label: const Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onSort: (columnIndex, ascending) =>
                                _sort<String>((user) => user.name, columnIndex),
                          ),
                          DataColumn(
                            label: const Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (user) => user.email, columnIndex),
                          ),
                          DataColumn(
                            label: const Text(
                              'Age',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            numeric: true,
                            onSort: (columnIndex, ascending) =>
                                _sort<num>((user) => user.age, columnIndex),
                          ),
                          DataColumn(
                            label: const Text(
                              'Role',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onSort: (columnIndex, ascending) =>
                                _sort<String>((user) => user.role, columnIndex),
                          ),
                          DataColumn(
                            label: const Text(
                              'Location',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (user) => user.location, columnIndex),
                          ),
                          DataColumn(
                            label: const Text(
                              'Join Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (user) => user.joinDate, columnIndex),
                          ),
                        ],
                        rows: _users.asMap().entries.map((entry) {
                          final index = entry.key;
                          final user = entry.value;

                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.blue.shade50;
                                }
                                return index.isEven
                                    ? Colors.grey.shade50
                                    : Colors.white;
                              },
                            ),
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          _getAvatarColor(user.name),
                                      child: Text(
                                        user.name.substring(0, 1).toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(user.name),
                                  ],
                                ),
                              ),
                              DataCell(Text(user.email)),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.age.toString(),
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(user.role),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    user.role,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(user.location),
                                  ],
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    user.joinDate,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[name.hashCode % colors.length];
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'designer':
        return Colors.purple;
      case 'developer':
        return Colors.blue;
      case 'manager':
        return Colors.green;
      case 'analyst':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class UserData {
  final String name;
  final String email;
  final int age;
  final String role;
  final String location;
  final String joinDate;

  UserData(
      this.name, this.email, this.age, this.role, this.location, this.joinDate);
}
