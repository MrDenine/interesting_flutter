import 'package:flutter/material.dart';

class SwipeToDelete extends StatefulWidget {
  const SwipeToDelete({super.key});

  @override
  State<SwipeToDelete> createState() => _SwipeToDeleteState();
}

class _SwipeToDeleteState extends State<SwipeToDelete>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetCard() {
    setState(() {
      _isDeleted = false;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Item Deleted!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetCard,
              child: const Text('Restore'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Container(
        width: 250,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Delete background
              Container(
                color: Colors.red,
                child: const Center(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              // Swipeable card
              SlideTransition(
                position: _slideAnimation,
                child: Dismissible(
                  key: const Key('swipe_card'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _isDeleted = true;
                    });
                  },
                  confirmDismiss: (direction) async {
                    _controller.forward();
                    return true;
                  },
                  child: Container(
                    color: Colors.white,
                    child: const ListTile(
                      leading: Icon(Icons.email, color: Colors.blue),
                      title: Text('Swipe to delete'),
                      subtitle: Text('Swipe left to reveal delete action'),
                      trailing: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
