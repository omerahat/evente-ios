import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card_widget.dart';
import 'event_detail_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshEvents();
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.token != null) {
      await Provider.of<EventProvider>(
        context,
        listen: false,
      ).fetchCategories(authProvider.token!);
    }
  }

  Future<void> _refreshEvents() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.token != null) {
      await Provider.of<EventProvider>(
        context,
        listen: false,
      ).fetchEvents(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          if (eventProvider.categories.isNotEmpty)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  // "All" chip
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: eventProvider.selectedCategoryId == null,
                      onSelected: (_) {
                        if (authProvider.token != null) {
                          eventProvider.clearFilter(authProvider.token!);
                        }
                      },
                    ),
                  ),
                  // Category chips
                  ...eventProvider.categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category.name),
                        selected:
                            eventProvider.selectedCategoryId == category.id,
                        onSelected: (_) {
                          if (authProvider.token != null) {
                            eventProvider.setSelectedCategory(
                              category.id,
                              authProvider.token!,
                            );
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          // Events list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshEvents,
              child: eventProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : eventProvider.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${eventProvider.error}'),
                          ElevatedButton(
                            onPressed: _refreshEvents,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : eventProvider.events.isEmpty
                  ? const Center(child: Text('No events found'))
                  : ListView.builder(
                      itemCount: eventProvider.events.length,
                      itemBuilder: (context, index) {
                        final event = eventProvider.events[index];
                        return EventCardWidget(
                          event: event,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailScreen(event: event),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
