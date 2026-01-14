import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../core/api_constants.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _commentController = TextEditingController();
  double _rating = 5;
  bool _isRegistering = false;
  bool _isSubmittingReview = false;

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final eventDate = DateTime(date.year, date.month, date.day);

    // Format time
    final timeFormat = DateFormat('h:mm a');
    final timeStr = timeFormat.format(date);

    // Check if it's today or tomorrow
    if (eventDate == today) {
      return 'Today at $timeStr';
    } else if (eventDate == tomorrow) {
      return 'Tomorrow at $timeStr';
    } else {
      // For other dates, show "January 15, 2026 at 2:30 PM"
      final dateFormat = DateFormat('MMMM d, y');
      return '${dateFormat.format(date)} at $timeStr';
    }
  }

  Future<void> _register() async {
    setState(() => _isRegistering = true);
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token!;
      await Provider.of<EventProvider>(context, listen: false)
          .registerForEvent(widget.event.id, token);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully registered!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRegistering = false);
      }
    }
  }

  Future<void> _submitReview() async {
    if (_commentController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a comment')),
        );
       return;
    }

    setState(() => _isSubmittingReview = true);
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token!;
      await Provider.of<EventProvider>(context, listen: false).addReview(
        widget.event.id,
        _rating.toInt(),
        _commentController.text,
        token,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted!')),
        );
        _commentController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmittingReview = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image or placeholder
            widget.event.bannerImageUrl != null && widget.event.bannerImageUrl!.isNotEmpty
                ? Image.network(
                    '${ApiConstants.baseUrl}${widget.event.bannerImageUrl}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey[300]!, Colors.grey[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.white70)),
                    ),
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey[300]!, Colors.grey[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.event, size: 64, color: Colors.white70),
                    ),
                  ),
            const SizedBox(height: 16),
            Text(widget.event.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(_formatDateTime(widget.event.date.toLocal())),
              ],
            ),
            const SizedBox(height: 4),
            if (widget.event.location.trim().isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.event.location,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Text(widget.event.description),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isRegistering ? null : _register,
                child: _isRegistering 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                  : const Text('Register for Event'),
              ),
            ),
            const Divider(height: 32),
            Text('Add Review', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Rating: '),
                Expanded(
                  child: Slider(
                    value: _rating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _rating.round().toString(),
                    onChanged: (value) => setState(() => _rating = value),
                  ),
                ),
                Text(_rating.round().toString()),
              ],
            ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmittingReview ? null : _submitReview,
                child: _isSubmittingReview
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}


