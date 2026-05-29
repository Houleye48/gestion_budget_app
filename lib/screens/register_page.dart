// lib/screens/auth/register_page.dart
// Personne 7 — Testeur / Intégration
// Page d'inscription — suit et complète le travail de la Personne 2

import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // ─── Contrôleurs ───────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // ─── État ──────────────────────────────────────────────────────────────
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _acceptConditions = false;
  final AuthService _authService = AuthService();

  // ─── Force du mot de passe ─────────────────────────────────────────────
  double _passwordStrength = 0;
  String _passwordStrengthLabel = '';
  Color _passwordStrengthColor = Colors.transparent;

  // ─── Animation ─────────────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    _passwordController.addListener(_evaluerMotDePasse);
  }

  @override
  void dispose() {
    _animController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ─── Évaluation de la force du mot de passe ────────────────────────────
  void _evaluerMotDePasse() {
    final pwd = _passwordController.text;
    double score = 0;

    if (pwd.length >= 6) score += 0.25;
    if (pwd.length >= 10) score += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) score += 0.25;
    if (RegExp(r'[0-9]').hasMatch(pwd)) score += 0.15;
    if (RegExp(r'[!@#\$&*~%^()_\-+=]').hasMatch(pwd)) score += 0.10;

    String label = '';
    Color color = Colors.transparent;
    if (pwd.isEmpty) {
      score = 0;
    } else if (score <= 0.25) {
      label = 'Faible';
      color = Colors.red;
    } else if (score <= 0.5) {
      label = 'Moyen';
      color = Colors.orange;
    } else if (score <= 0.75) {
      label = 'Bien';
      color = Colors.lightGreen;
    } else {
      label = 'Fort';
      color = Colors.green;
    }

    setState(() {
      _passwordStrength = score.clamp(0.0, 1.0);
      _passwordStrengthLabel = label;
      _passwordStrengthColor = color;
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ACTION : INSCRIPTION
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_acceptConditions) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez accepter les conditions d\'utilisation.'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.register(
      nom: _nomController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      // ✅ Inscription réussie
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.green, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                'Bienvenue, ${result.user!.nom} !',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Votre compte a été créé avec succès.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context); // Retour à LoginPage
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Se connecter maintenant'),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // ❌ Erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Erreur inconnue.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── EN-TÊTE ─────────────────────────────────────────
                    const Text(
                      'Créer un compte',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rejoignez l\'application de gestion de budget',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 28),

                    // ── CARTE FORMULAIRE ────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── NOM ──
                          _buildLabel('Nom complet'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nomController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                                hint: 'Votre nom', icon: Icons.person_outline),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Le nom est obligatoire';
                              }
                              if (val.trim().length < 2) {
                                return 'Minimum 2 caractères';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // ── EMAIL ──
                          _buildLabel('Adresse email'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: _inputDecoration(
                                hint: 'exemple@email.com',
                                icon: Icons.email_outlined),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'L\'email est obligatoire';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(val)) {
                                return 'Format d\'email invalide';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // ── MOT DE PASSE ──
                          _buildLabel('Mot de passe'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              hint: 'Minimum 6 caractères',
                              icon: Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Le mot de passe est obligatoire';
                              }
                              if (val.length < 6) {
                                return 'Minimum 6 caractères';
                              }
                              return null;
                            },
                          ),

                          // ── BARRE FORCE MOT DE PASSE ──
                          if (_passwordController.text.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Row(children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _passwordStrength,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        _passwordStrengthColor),
                                    minHeight: 5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _passwordStrengthLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _passwordStrengthColor,
                                ),
                              ),
                            ]),
                          ],
                          const SizedBox(height: 20),

                          // ── CONFIRMATION ──
                          _buildLabel('Confirmer le mot de passe'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmController,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleRegister(),
                            decoration: _inputDecoration(
                              hint: 'Répéter le mot de passe',
                              icon: Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Veuillez confirmer le mot de passe';
                              }
                              if (val != _passwordController.text) {
                                return 'Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── CONDITIONS D'UTILISATION ─────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _acceptConditions,
                            activeColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) =>
                                setState(() => _acceptConditions = val!),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                                () => _acceptConditions = !_acceptConditions),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                                children: const [
                                  TextSpan(text: 'J\'accepte les '),
                                  TextSpan(
                                    text: 'conditions d\'utilisation',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: ' et la '),
                                  TextSpan(
                                    text: 'politique de confidentialité',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // ── BOUTON S'INSCRIRE ──────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              Colors.teal.withValues(alpha: 0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                              )
                            : const Text(
                                'Créer mon compte',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── LIEN CONNEXION ──────────────────────────────────
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Déjà un compte ? ',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Se connecter',
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── HELPERS UI ──────────────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
        letterSpacing: 0.2,
      ),
    );
  }

  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
    );
  }
}