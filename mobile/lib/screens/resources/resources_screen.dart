import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/resource_card.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Immediate Help',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ResourceCard(
          title: 'National DV Hotline',
          description: '1-800-799-7233 (24/7)',
          icon: Icons.phone,
          color: AppTheme.dangerColor,
          onTap: () => _showResourceDetail(
            context,
            'National Domestic Violence Hotline',
            '1-800-799-7233\n\nAvailable 24 hours a day, 7 days a week.\nSupport in 200+ languages.\nText "START" to 88788.',
          ),
        ),
        const SizedBox(height: 12),
        ResourceCard(
          title: 'Crisis Text Line',
          description: 'Text HOME to 741741',
          icon: Icons.message,
          color: AppTheme.warningColor,
          onTap: () => _showResourceDetail(
            context,
            'Crisis Text Line',
            'Text "HOME" to 741741\n\nFree, confidential support via text message.\nAvailable 24/7.',
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Safety Planning',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ResourceCard(
          title: 'Create Safety Plan',
          description: 'Prepare for emergencies',
          icon: Icons.checklist,
          color: AppTheme.successColor,
          onTap: () => _showResourceDetail(
            context,
            'Safety Planning',
            '1. Identify safe places\n2. Code words\n3. Trusted contacts\n4. Important documents\n5. Emergency fund\n6. Secure communication\n7. Memorized numbers',
          ),
        ),
        const SizedBox(height: 12),
        ResourceCard(
          title: 'Important Documents',
          description: 'What to keep safe',
          icon: Icons.folder_open,
          color: Color(0xFF9C27B0),
          onTap: () => _showResourceDetail(
            context,
            'Important Documents',
            '• Birth certificates\n• Passports/IDs\n• Social Security cards\n• Bank info\n• Insurance documents\n• Custody orders\n• Protection orders\n• Medical records',
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Legal Support',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ResourceCard(
          title: 'Find Legal Aid',
          description: 'Free legal assistance',
          icon: Icons.gavel,
          color: Color(0xFF2196F3),
          onTap: () => _showResourceDetail(
            context,
            'Legal Aid',
            'lawhelp.org - Find legal aid\nlocalcourts.org - Court info\n\nVictim services may offer free consultation.',
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Mental Health Support',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ResourceCard(
          title: 'RAINN',
          description: '1-800-656-4673 (Sexual Assault)',
          icon: Icons.favorite,
          color: Color(0xFFF44336),
          onTap: () => _showResourceDetail(
            context,
            'RAINN',
            '1-800-656-4673\n\nRape, Abuse & Incest National Network\nFree, confidential support.',
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showResourceDetail(BuildContext context, String title, String details) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(details),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
