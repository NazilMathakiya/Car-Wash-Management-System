import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingHistoryScreen extends StatefulWidget {
  final String userId; // Current user ki ID (optional, empty ho sakti hai)

  const BookingHistoryScreen({Key? key, this.userId = ''}) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String searchQuery = '';
  String selectedStatus = 'all';
  String sortBy = 'date_desc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[700],
        title: const Text('Booking History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stats Card
          _buildStatsCard(),

          // Filters
          _buildFilters(),

          // Bookings List
          Expanded(
            child: _buildBookingsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    // Get current user ID
    final String currentUserId = widget.userId.isNotEmpty
        ? widget.userId
        : FirebaseAuth.instance.currentUser?.uid ?? '';

    if (currentUserId.isEmpty) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('uid', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final bookings = snapshot.data!.docs;
        final total = bookings.length;
        final completed = bookings.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['status'] == 'Completed' &&
              (data.containsKey('isDeleted') ? data['isDeleted'] != true : true);
        }).length;
        final pending = bookings.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['status'] == 'Pending' &&
              (data.containsKey('isDeleted') ? data['isDeleted'] != true : true);
        }).length;
        final cancelled = bookings.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['status'] == 'Cancelled' ||
              (data.containsKey('isDeleted') && data['isDeleted'] == true);
        }).length;
        final revenue = bookings
            .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['status'] == 'Completed' &&
              (data.containsKey('isDeleted') ? data['isDeleted'] != true : true);
        })
            .fold<double>(0, (sum, doc) {
          final data = doc.data() as Map<String, dynamic>;
          return sum + (data['totalAmount'] ?? 0).toDouble();
        });

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildStatItem('Total', total.toString(), Colors.blue),
                  _buildStatItem('Completed', completed.toString(), Colors.green),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatItem('Pending', pending.toString(), Colors.orange),
                  _buildStatItem('Cancelled', cancelled.toString(), Colors.red),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.currency_rupee, color: Colors.indigo, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Total Revenue: ${revenue.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search by service name...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Status Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.filter_list),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Status')),
                    DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                    DropdownMenuItem(value: 'deleted', child: Text('Deleted')),
                  ],
                  onChanged: (value) => setState(() => selectedStatus = value!),
                ),
              ),
              const SizedBox(width: 12),
              // Sort
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: sortBy,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.sort),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'date_desc', child: Text('Latest First')),
                    DropdownMenuItem(value: 'date_asc', child: Text('Oldest First')),
                    DropdownMenuItem(value: 'amount_desc', child: Text('Highest Amount')),
                    DropdownMenuItem(value: 'amount_asc', child: Text('Lowest Amount')),
                  ],
                  onChanged: (value) => setState(() => sortBy = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    // Get current user ID if widget.userId is empty
    final String currentUserId = widget.userId.isNotEmpty
        ? widget.userId
        : FirebaseAuth.instance.currentUser?.uid ?? '';

    if (currentUserId.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Please login to view booking history',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('uid', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No bookings found',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // Filter bookings
        var bookings = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final serviceName = (data['serviceName'] ?? '').toString().toLowerCase();
          final status = data['status'] ?? '';
          final isDeleted = data.containsKey('isDeleted') ? data['isDeleted'] == true : false;

          // Search filter
          if (searchQuery.isNotEmpty && !serviceName.contains(searchQuery)) {
            return false;
          }

          // Status filter
          if (selectedStatus != 'all') {
            if (selectedStatus == 'deleted') {
              return isDeleted;
            } else {
              return status == selectedStatus && !isDeleted;
            }
          }

          return true;
        }).toList();

        // Sort bookings
        bookings.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;

          if (sortBy == 'date_desc') {
            final aTime = aData['timestamp'] as Timestamp?;
            final bTime = bData['timestamp'] as Timestamp?;
            return (bTime?.compareTo(aTime ?? Timestamp.now()) ?? 0);
          } else if (sortBy == 'date_asc') {
            final aTime = aData['timestamp'] as Timestamp?;
            final bTime = bData['timestamp'] as Timestamp?;
            return (aTime?.compareTo(bTime ?? Timestamp.now()) ?? 0);
          } else if (sortBy == 'amount_desc') {
            return (bData['totalAmount'] ?? 0).compareTo(aData['totalAmount'] ?? 0);
          } else {
            return (aData['totalAmount'] ?? 0).compareTo(bData['totalAmount'] ?? 0);
          }
        });

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No bookings match your filters',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final doc = bookings[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildBookingCard(data, doc.id);
          },
        );
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, String docId) {
    final serviceName = booking['serviceName'] ?? 'Unknown Service';
    final date = booking['date'] ?? '';
    final time = booking['time'] ?? '';
    final price = booking['price'] ?? 0;
    final discount = booking['discount'] ?? 0;
    final totalAmount = booking['totalAmount'] ?? 0;
    final status = booking['status'] ?? 'Pending';
    final isDeleted = booking.containsKey('isDeleted') ? booking['isDeleted'] == true : false;
    final timestamp = booking['timestamp'] as Timestamp?;
    final deletedAt = booking.containsKey('deletedAt') ? booking['deletedAt'] as Timestamp? : null;

    Color statusColor;
    IconData statusIcon;

    if (isDeleted) {
      statusColor = Colors.grey;
      statusIcon = Icons.delete;
    } else {
      switch (status) {
        case 'Completed':
          statusColor = Colors.green;
          statusIcon = Icons.check_circle;
          break;
        case 'Cancelled':
          statusColor = Colors.red;
          statusIcon = Icons.cancel;
          break;
        default:
          statusColor = Colors.orange;
          statusIcon = Icons.pending;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDeleted ? Border.all(color: Colors.grey[300]!, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: $docId',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    isDeleted ? 'Deleted' : status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(Icons.calendar_today, date),
                ),
                Expanded(
                  child: _buildInfoRow(Icons.access_time, time),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(Icons.currency_rupee, '₹$price'),
                ),
                Expanded(
                  child: _buildInfoRow(Icons.local_offer, '-₹$discount'),
                ),
              ],
            ),
            if (isDeleted && deletedAt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.delete, size: 16, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(
                    'Deleted on ${DateFormat('MMM dd, yyyy').format(deletedAt.toDate())}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '₹$totalAmount',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}