import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../app/di/dependency_injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class FriendCodeSheet extends StatefulWidget {
  const FriendCodeSheet({super.key});

  @override
  State<FriendCodeSheet> createState() => _FriendCodeSheetState();
}

class _FriendCodeSheetState extends State<FriendCodeSheet> {
  final _friendCodeController = TextEditingController();
  String? _myFriendCode;
  String? _partnerName;

  @override
  void initState() {
    super.initState();
    _friendCodeController.addListener(_formatFriendCode);
    _loadData();
  }

  @override
  void dispose() {
    _friendCodeController.removeListener(_formatFriendCode);
    _friendCodeController.dispose();
    super.dispose();
  }

  void _formatFriendCode() {
    final text = _friendCodeController.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length && i < 8; i++) {
      if (i == 4) buffer.write('-');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    if (_friendCodeController.text != formatted) {
      _friendCodeController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<void> _loadData() async {
    final localStorage = getIt<LocalStorageService>();
    final friendCode = await localStorage.getString(AppConstants.friendCodeKey);
    final partnerName = await localStorage.getString(AppConstants.partnerNameKey);
    setState(() {
      _myFriendCode = friendCode;
      _partnerName = partnerName;
    });
  }

  void _copyFriendCode() {
    if (_myFriendCode != null) {
      Clipboard.setData(ClipboardData(text: _myFriendCode!));
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.friendCodeCopiedMessage,
            style: GoogleFonts.dmSans(),
          ),
          backgroundColor: AppColors.of(context).gold,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _addPartner() {
    final code = _friendCodeController.text.trim();
    final l10n = AppLocalizations.of(context);
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.friendCodeEmptyValidation,
            style: GoogleFonts.dmSans(),
          ),
          backgroundColor: AppColors.of(context).error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(AddPartnerRequested(friendCode: code));
  }

  void _removePartner() {
    context.read<AuthBloc>().add(const RemovePartnerRequested());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) {
        if (curr is AuthPartnerLinked && prev is! AuthPartnerLinked) return true;
        if (curr is AuthError && curr.isPartnerError) return true;
        return false;
      },
      listener: (context, state) {
        if (state is AuthPartnerLinked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.friendCodeLinkedMessage(state.partnerName),
                style: GoogleFonts.dmSans(),
              ),
              backgroundColor: AppColors.of(context).success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pop(context);
        } else if (state is AuthError && state.isPartnerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.dmSans(),
              ),
              backgroundColor: AppColors.of(context).error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: palette.textHint,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.friendCodeSheetTitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: palette.gold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_partnerName != null) ...[
                    _buildPartnerSection(palette, l10n),
                  ] else ...[
                    _buildMyCodeSection(palette, l10n),
                    const SizedBox(height: 24),
                    _buildAddFriendSection(palette, l10n, isLoading: isLoading),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPartnerSection(dynamic palette, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: palette.gold.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.people_alt,
                color: palette.gold,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.friendCodePartnerLabel,
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: palette.gold.withValues(alpha: 0.6),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _partnerName!,
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildMyCodeSection(palette, l10n),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: _removePartner,
            style: OutlinedButton.styleFrom(
              foregroundColor: palette.error,
              side: BorderSide(color: palette.error.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              l10n.friendCodeUnlinkButton,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyCodeSection(dynamic palette, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.friendCodeMyCodeLabel,
          style: GoogleFonts.dmSans(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: palette.gold.withValues(alpha: 0.6),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _copyFriendCode,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: palette.backgroundElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: palette.gold.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _myFriendCode ?? '---',
                  style: GoogleFonts.dmMono(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: palette.gold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.copy_rounded,
                  color: palette.gold.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            l10n.friendCodeTapToCopy,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: palette.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddFriendSection(dynamic palette, AppLocalizations l10n, {bool isLoading = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: palette.gold.withValues(alpha: 0.15),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.friendCodeLinkFriendSection,
          style: GoogleFonts.dmSans(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: palette.gold.withValues(alpha: 0.6),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.friendCodeLinkFriendDescription,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: palette.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _friendCodeController,
          textCapitalization: TextCapitalization.characters,
          maxLength: 9,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          style: GoogleFonts.dmMono(
            fontSize: 18,
            color: palette.textPrimary,
            letterSpacing: 3,
          ),
          decoration: InputDecoration(
            hintText: 'XXXX-XXXX',
            hintStyle: GoogleFonts.dmMono(
              fontSize: 18,
              color: palette.textHint,
              letterSpacing: 3,
            ),
            prefixIcon: Icon(
              Icons.person_add_outlined,
              color: palette.gold.withValues(alpha: 0.5),
            ),
            counterText: '',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : _addPartner,
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.gold,
              foregroundColor: palette.background,
              disabledBackgroundColor: palette.gold.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: palette.background,
                    ),
                  )
                : Text(
                    l10n.friendCodeLinkButton,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
