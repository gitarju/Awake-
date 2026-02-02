import 'package:flutter/material.dart';
import 'package:ttt_alarm/core/database/database_helper.dart';
import 'package:intl/intl.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late Future<List<Map<String, dynamic>>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _logsFuture = DatabaseHelper.instance.queryAllRows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Insights')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _logsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final logs = snapshot.data ?? [];
          if (logs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bedtime_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No sleep records yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              final timestamp = log[DatabaseHelper.columnTimestamp] as int;
              final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
              final status = log[DatabaseHelper.columnStatus] as String;

              return ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(DateFormat.yMMMMEEEEd().format(date)),
                subtitle: Text('Woke up at ${DateFormat.jm().format(date)}'),
                trailing: Chip(
                  label: Text(status.replaceAll('_', ' ').toUpperCase()),
                  backgroundColor: _getStatusColor(status),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'desperate':
        return Colors.orange.withOpacity(0.2);
      case 'back_to_sleep':
        return Colors.red.withOpacity(0.2);
      case 'awake':
        return Colors.green.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
}
