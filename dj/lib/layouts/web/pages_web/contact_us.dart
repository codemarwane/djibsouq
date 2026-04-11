import 'package:flutter/material.dart';
import 'package:dj/widgets/web_header.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

// Breakpoints
const double mobileBreakpoint = 700;
const double tabletBreakpoint = 1024;

// ─────────────────────────────────────────────
//  CONTACT US PAGE
// ─────────────────────────────────────────────
class ContactUsWeb extends StatefulWidget {
  const ContactUsWeb({super.key});

  @override
  State<ContactUsWeb> createState() => _ContactUsWebState();
}

class _ContactUsWebState extends State<ContactUsWeb> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message envoyé avec succès!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildHeader(currentPage: 'Contactez-nous'),
            _buildContactContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  CONTACT CONTENT
  // ─────────────────────────────────────────────
  Widget _buildContactContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isMobile = width < mobileBreakpoint;
        final bool isTablet = width < tabletBreakpoint;

        final double horizontalPadding = isMobile ? 20 : (isTablet ? 40 : 60);
        final double verticalPadding = isMobile ? 24 : 40;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              // ───── SECTION TITLE ─────
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contactez-nous',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nous serions ravis de vous entendre',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // ───── CONTENT ROW (Form + Info) ─────
              isMobile
                  ? Column(
                      children: [
                        _buildContactForm(isMobile: isMobile),
                        const SizedBox(height: 40),
                        _buildContactInfo(isMobile: isMobile),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildContactForm(isMobile: isMobile),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 1,
                          child: _buildContactInfo(isMobile: isMobile),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  CONTACT FORM
  // ─────────────────────────────────────────────
  Widget _buildContactForm({required bool isMobile}) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── NAME FIELD ─────
            const Text(
              'Nom complet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Votre nom',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // ───── EMAIL FIELD ─────
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'votre.email@exemple.com',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre email';
                } else if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Veuillez entrer un email valide';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // ───── SUBJECT FIELD ─────
            const Text(
              'Objet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Objet de votre message',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un objet';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // ───── MESSAGE FIELD ─────
            const Text(
              'Message',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Votre message ici...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre message';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),

            // ───── SUBMIT BUTTON ─────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Envoyer le message',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  CONTACT INFO
  // ─────────────────────────────────────────────
  Widget _buildContactInfo({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───── PHONE ─────
        _buildContactInfoCard(
          icon: Icons.phone_outlined,
          title: 'Téléphone',
          subtitle: '+253 21 35 67 89',
        ),
        const SizedBox(height: 20),

        // ───── EMAIL ─────
        _buildContactInfoCard(
          icon: Icons.email_outlined,
          title: 'Email',
          subtitle: 'support@djibsouq.com',
        ),
        const SizedBox(height: 20),

        // ───── ADDRESS ─────
        _buildContactInfoCard(
          icon: Icons.location_on_outlined,
          title: 'Adresse',
          subtitle: 'Djibouti, République de Djibouti',
        ),
        const SizedBox(height: 20),

        // ───── HOURS ─────
        _buildContactInfoCard(
          icon: Icons.access_time_outlined,
          title: 'Horaires',
          subtitle: 'Lun - Ven: 08:00 - 18:00\nSam: 09:00 - 13:00',
        ),
      ],
    );
  }

  Widget _buildContactInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  FOOTER
  // ─────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(40),
      color: const Color(0xFF0F172A),
      child: Center(
        child: Text(
          '© 2026 DJIBSOUQ. All rights reserved.',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
      ),
    );
  }
}

