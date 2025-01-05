import 'package:animated_dock/dock_item.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

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

  // Reorder items in the dock
  void reorderItems(int oldIndex, int newIndex) {
    setState(() {
      final item = dockItems.removeAt(oldIndex);
      dockItems.insert(newIndex, item);
    });
  }

  // Remove an item from the dock
  void removeItem(String id) {
    setState(() {
      dockItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFFB8C4A9),
          Color(0xFFF0F0F0),
        ])),
        child: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "- To rearrange icon drag and drop or move horizontally",
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  Text(
                    "- To remove item hold icon for a while(300ms) ",
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ],
              ),
            ),
            // Dock at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Container(
                  height: 160, // Fixed height for the ReorderableListView
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.sizeOf(context).width * .15,
                  ),
                  child: Container(
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
                    child: ReorderableWrap(
                      alignment: WrapAlignment.center,
                      spacing: 20.0,
                      runSpacing: 10.0,
                      padding: const EdgeInsets.all(8),
                      onReorder: reorderItems,
                      enableReorder: true,
                      runAlignment: WrapAlignment.center,
                      header: [
                        DragTarget<String>(
                          onAcceptWithDetails: (id) {
                            removeItem(
                                id.data); // Remove the item when dropped here
                          },
                          builder: (context, candidates, rejects) {
                            return Container(
                              height: 40,
                              color: candidates.isNotEmpty
                                  ? Colors.red.withOpacity(0.3)
                                  : Colors.transparent,
                              alignment: Alignment.center,
                              child: const Text(
                                'Drag here to remove',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            );
                          },
                        )
                      ],
                      needsLongPressDraggable: false,
                      buildDraggableFeedback: (context, constraints, child) {
                        return child;
                      },
                      onNoReorder: (int index) {
                        //this callback is optional
                        debugPrint(
                            '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
                      },
                      onReorderStarted: (int index) {
                        //this callback is optional
                        debugPrint(
                            '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
                      },
                      children: List.generate(
                        dockItems.length,
                        (index) {
                          final item = dockItems[index];
                          return MouseRegion(
                            onEnter: (_) =>
                                setState(() => hoveredIndex = index),
                            onExit: (_) => setState(() => hoveredIndex = null),
                            child: LongPressDraggable<String>(
                              data: item.id,
                              delay: const Duration(milliseconds: 300),
                              feedback: _buildDragFeedback(item),
                              childWhenDragging: _buildPlaceholder(),
                              child: Material(
                                color: Colors.transparent,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 60,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedScale(
                                        scale:
                                            hoveredIndex == index ? 1.4 : 1.0,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Icon(
                                          item.icon,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (hoveredIndex == index) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          item.label,
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
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drag feedback widget
  Widget _buildDragFeedback(DockItem item) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 60,
        height: 90,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: Colors.white),
            Text(
              item.label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder widget when dragging
  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.transparent,
    );
  }
}
