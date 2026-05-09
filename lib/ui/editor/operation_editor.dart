import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/routes/routes.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class OperationEditor extends StatelessWidget {
  
  final String title;
  final List<Widget> Function(BuildContext context) fieldListBuilder;
  final String? Function()? validator;
  final VoidCallback? onSave;
  final bool Function()? canPopUp;

  const OperationEditor({
    super.key, 
    required this.title, 
    required this.fieldListBuilder,
    this.onSave,
    this.validator,
    this.canPopUp,
  });

  void _showMenu(BuildContext context) async {
    await showDialog(
      context: context, 
      builder:(ctx) {
        return SimpleDialog(
          title: Text('Save options'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                ctx.pop();
                _saveAndExit(context);
              },
              padding: const EdgeInsets.all(16),
              child: Text('Save & Exit'),
            ),
            SimpleDialogOption(
              onPressed: () {
                ctx.pop();
                _saveAndExit(context, needToCreateNew: true);
              },
              padding: const EdgeInsets.all(16),
              child: Text('Save & Create new'),
            )
          ],
        );
      },
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        elevation: 8,
        behavior: SnackBarBehavior.floating,
      )
    );
  }

  void _saveAndExit(BuildContext context, {bool needToCreateNew = false}) {
    final error = validator?.call();
    if (error != null) {
      _showToast(context, error);
      return;
    }
    onSave?.call();    
    context.pop(needToCreateNew? CreateNewTransaction() : null);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult:(didPop, result) {
        if (didPop) return;
        final canPop = canPopUp?.call() ?? true;
        if (canPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.colorScheme.surfaceContainer,
          title: Text(title),
        ),
        backgroundColor: context.colorScheme.surfaceContainer,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView( 
            children: fieldListBuilder(context)
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsetsGeometry.all(24),
          child: Row(
            spacing: 2,
            children: [
              Expanded(
                child: FilledButton(                  
                  style: FilledButton.styleFrom(      
                    fixedSize: Size(0, 56),
                    elevation: 8,
                    padding: const EdgeInsets.all(0),     
                    textStyle: context.textTheme.bodyLarge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        bottomLeft: Radius.circular(24.0),
                        topRight: Radius.circular(4.0),
                        bottomRight: Radius.circular(4.0),
                      )
                    )
                  ),
                  onPressed: () => _saveAndExit(context),
                  child: Text('Save')
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  fixedSize: Size(56, 56),
                  elevation: 8,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      bottomLeft: Radius.circular(4.0),
                      topRight: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    )
                  )
                ),
                onPressed: () {
                  _showMenu(context);
                },
                child: UiIcon(UiIcons.more, color: context.colorScheme.onPrimary, width: 32,)
              ),
            ],
          ),
        ),
      )
    );
  }


}