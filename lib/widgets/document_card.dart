import 'package:flutter/material.dart';
import '../models/document.dart';
import '../utils/theme.dart';
import 'package:intl/intl.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (document.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        document.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Uploaded: ${DateFormat('MMM d, yyyy').format(document.uploadDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.download,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    if (document.type == DocumentType.exam) {
      iconData = Icons.assignment;
      iconColor = Colors.red;
    } else {
      iconData = Icons.book;
      iconColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 28,
      ),
    );
  }
}