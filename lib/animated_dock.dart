import 'package:animated_dock/dock_item.dart';
import 'package:flutter/material.dart';


class MacDock extends StatefulWidget {
  const MacDock({super.key});

  @override
  State<MacDock> createState() => _MacDockState();
}

class _MacDockState extends State<MacDock> {
  int? hoveredIndex;
  List<DockItem> dockItems = [
    DockItem(id: '1', icon: Icons.web, label: 'Browser'),
    DockItem(id: '2', icon: Icons.mail, label: 'Mail'),
    DockItem(id: '3', icon: Icons.calendar_today, label: 'Calendar'),
    DockItem(id: '4', icon: Icons.settings, label: 'Settings'),
    DockItem(id: '5', icon: Icons.folder, label: 'Finder'),
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            dockItems.length,
            (index) => Draggable<String>(
              data: dockItems[index].id,
              feedback: Material(
                color: Colors.transparent,
                child: Icon(
                  dockItems[index].icon,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              childWhenDragging: const SizedBox(width: 60),
              onDragStarted: () {
                setState(() {
                  hoveredIndex = null;
                });
              },
              onDraggableCanceled: (_, __) {
                // Handle drag cancel if needed
              },
              onDragCompleted: () {
                setState(() {
                  dockItems.removeAt(index);
                });
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 60,
                  height: hoveredIndex == index ? 90 : 70,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        transform: Matrix4.identity()
                          ..scale(hoveredIndex == index ? 1.2 : 1.0),
                        child: Icon(
                          dockItems[index].icon,
                          size: hoveredIndex == index ? 40 : 30,
                          color: Colors.white,
                        ),
                      ),
                      if (hoveredIndex == index) ...[
                        const SizedBox(height: 4),
                        Text(
                          dockItems[index].label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
