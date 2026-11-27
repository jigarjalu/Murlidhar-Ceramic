import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/enquiry_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/status_chip.dart';
import '../common/providers/app_providers.dart';

class AdminEnquiriesScreen extends ConsumerStatefulWidget {
  const AdminEnquiriesScreen({super.key});

  @override
  ConsumerState<AdminEnquiriesScreen> createState() =>
      _AdminEnquiriesScreenState();
}

class _AdminEnquiriesScreenState extends ConsumerState<AdminEnquiriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _callCustomer(String phone) async {
    final clean = phone.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _whatsappCustomer(String phone, String customerName) async {
    final clean = phone.replaceAll(RegExp(r'\D'), '');
    final message = Uri.encodeComponent(
      'Hello $customerName, thank you for your enquiry with Murlidhar Ceramic. How can we help you?',
    );
    final uri = Uri.parse('https://wa.me/$clean?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _changeStatus(
    EnquiryModel item,
    EnquiryStatus newStatus,
  ) async {
    await ref
        .read(enquiryRepositoryProvider)
        .updateEnquiryStatus(item.id, newStatus);
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to ${newStatus.name.toUpperCase()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EnquiryModel>>(
      future: ref.read(enquiryRepositoryProvider).getAllEnquiriesForAdmin(),
      builder: (context, snapshot) {
        final enquiries = snapshot.data ?? [];

        return Scaffold(
          backgroundColor: AppColors.creamBackground,
          appBar: AppBar(
            title: const Text('Enquiry Management'),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.goldDark,
              indicatorColor: AppColors.goldStart,
              isScrollable: true,
              tabs: [
                Tab(text: 'All (${enquiries.length})'),
                Tab(
                  text:
                      'Pending (${enquiries.where((e) => e.status == EnquiryStatus.pending).length})',
                ),
                Tab(
                  text:
                      'Contacted (${enquiries.where((e) => e.status == EnquiryStatus.contacted).length})',
                ),
                Tab(
                  text:
                      'Closed (${enquiries.where((e) => e.status == EnquiryStatus.closed).length})',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildList(enquiries),
              _buildList(
                enquiries
                    .where((e) => e.status == EnquiryStatus.pending)
                    .toList(),
              ),
              _buildList(
                enquiries
                    .where((e) => e.status == EnquiryStatus.contacted)
                    .toList(),
              ),
              _buildList(
                enquiries
                    .where((e) => e.status == EnquiryStatus.closed)
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(List<EnquiryModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No enquiries in this section.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        final dateStr =
            DateFormat('dd MMM yyyy, hh:mm a').format(item.createdAt);

        return GlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.goldStart,
                        child: Icon(Icons.person,
                            size: 20, color: AppColors.goldButtonText),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.customerName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item.customerPhone,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  StatusChip(status: item.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const Divider(height: 16),
              if (item.isGeneralInquiry)
                Text(
                  item.generalMessage,
                  style: const TextStyle(fontSize: 13),
                )
              else
                ...item.items.map(
                  (it) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• ${it.productNameEnglish} (${it.selectedSize}, ${it.selectedFinish})',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Change Status Popup
                  PopupMenuButton<EnquiryStatus>(
                    onSelected: (st) => _changeStatus(item, st),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: EnquiryStatus.pending,
                        child: Text('Mark as Pending'),
                      ),
                      PopupMenuItem(
                        value: EnquiryStatus.contacted,
                        child: Text('Mark as Contacted'),
                      ),
                      PopupMenuItem(
                        value: EnquiryStatus.closed,
                        child: Text('Mark as Closed'),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.creamBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.creamCardBorder),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_note, size: 16),
                          SizedBox(width: 4),
                          Text('Update Status', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  // Call & WhatsApp Customer Actions
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Call Customer',
                        icon: const Icon(Icons.phone,
                            size: 20, color: AppColors.goldDark),
                        onPressed: () => _callCustomer(item.customerPhone),
                      ),
                      IconButton(
                        tooltip: 'WhatsApp Customer',
                        icon: const Icon(Icons.chat,
                            size: 20, color: AppColors.statusContacted),
                        onPressed: () => _whatsappCustomer(
                          item.customerPhone,
                          item.customerName,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
