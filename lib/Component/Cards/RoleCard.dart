import 'package:flutter/material.dart';

import '../../Model/RoleModel/RoleModel.dart';
import '../../Styles/AppText.dart';
import '../../Styles/Color.dart';

class RoleCard extends StatelessWidget {
  final RoleModel role;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color.cardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              _permissionPreview(),
              const SizedBox(height: 12),
              _datesRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.badge_outlined,
            color: color.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role.name, style: AppText.SubHeadingText()),
              const SizedBox(height: 4),
              Text("ID: ${role.role_id}", style: AppText.BodyText()),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey[400]),
      ],
    );
  }

  Widget _permissionPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.security_outlined, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Permissions",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role.permission.join(", "),
                style: AppText.BodyText(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _datesRow() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 16, color: Colors.grey[500]),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  role.created_date ?? "Not set",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if ((role.updated_date?.isNotEmpty ?? false) &&
            role.updated_date != role.created_date)
          Expanded(
            child: Row(
              children: [
                Icon(Icons.update_outlined,
                    size: 16, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "Updated ${role.updated_date}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
