import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/enquiry_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/status_chip.dart';
import '../common/providers/app_providers.dart';

class AdminEnquiriesScreen extends ConsumerStatefulWidget {
  const AdminEnquiriesScreen({super.key});

  @override
  ConsumerState<AdminEnquiriesScreen> createState() => _AdminEnquiriesScreenState();
}

class _AdminEnquiriesScreenState extends ConsumerState<AdminEnquiriesScreen> with SingleTickerProviderStateMixin {
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
    final clean = phone.replaceAll(' ', '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _whatsappCustomer(String phone, String customerName) async {
    final clean = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent("Hello $customerName, thank you for contacting Murlidhar Ceramic.")}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Pending'),
                Tab(text: 'Contacted'),
                Tab(text: 'Closed'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildList(enquiries),
              _buildList(enquiries.where((e) => e.status == EnquiryStatus.pending).toList()),
              _buildList(enquiries.where((e) => e.status == EnquiryStatus.contacted).toList()),
              _buildList(enquiries.where((e) => e.status == EnquiryStatus.closed).toList()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(List<EnquiryModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No enquiries found in this section.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];

        return GlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.customerName,
                    style: AppTypography.dynamicBody(item.customerName, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  StatusChip(status: item.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.customerPhone,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              if (item.generalMessage.isNotEmpty)
                Text(
                  'Message: ${item.generalMessage}',
                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                ),
              if (item.items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Items: ${item.items.map((i) => "${i.productNameEnglish} (${i.selectedSize})").join(", ")}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone_outlined, color: AppColors.textPrimary, size: 20),
                    onPressed: () => _callCustomer(item.customerPhone),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.whatsappGreen, size: 20),
                    onPressed: () => _whatsappCustomer(item.customerPhone, item.customerName),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<EnquiryStatus>(
                    value: item.status,
                    underline: const SizedBox(),
                    items: EnquiryStatus.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.name.toUpperCase(), style: const TextStyle(fontSize: 11)),
                      );
                    }).toList(),
                    onChanged: (val) async {
                      if (val != null) {
                        await ref.read(enquiryRepositoryProvider).updateEnquiryStatus(item.id, val);
                        setState(() {});
                      }
                    },
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
