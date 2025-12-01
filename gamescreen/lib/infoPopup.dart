import 'package:flutter/material.dart';

class InfoPopup extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onClose;
  final Widget? customContent;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const InfoPopup({
    super.key,
    required this.title,
    required this.content,
    this.onClose,
    this.customContent,
    this.backgroundColor = const Color.fromARGB(255, 45, 40, 55),
    this.textColor = Colors.green,
    this.borderColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            constraints: const BoxConstraints(
              maxHeight: 500,
              minHeight: 200,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: textColor),
                        onPressed: () {
                          onClose?.call();
                          Navigator.of(context).pop();
                        },
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),

                // Content area
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: customContent ??
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main content
                            Text(
                              content,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ), // Details if provided
                          ]
                        ),
                  ),
                ),

                // Action buttons
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            onClose?.call();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: borderColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: backgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to show the info popup
void showInfoPopup({
  required BuildContext context,
  required String title,
  required String content,
  VoidCallback? onClose,
  List<String>? details,
  Widget? customContent,
  Color backgroundColor = const Color.fromARGB(255, 45, 40, 55),
  Color textColor = Colors.green,
  Color borderColor = Colors.green,
}) {
  showDialog(
    context: context,
    builder: (context) => InfoPopup(
      title: title,
      content: content,
      onClose: onClose,
      customContent: customContent,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
    ),
  );
}
