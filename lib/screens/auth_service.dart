// lib/services/auth_service.dart
// Personne 7 — Testeur / Intégration
// Service d'authentification complet avec simulation API

import 'package:flutter/foundation.dart';

/// Modèle utilisateur
class UserModel {
  final String id;
  final String nom;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.nom,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nom: json['nom'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'email': email,
        'photoUrl': photoUrl,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Résultat d'une opération d'authentification
class AuthResult {
  final bool success;
  final String? message;
  final UserModel? user;

  const AuthResult({
    required this.success,
    this.message,
    this.user,
  });

  factory AuthResult.success(UserModel user) =>
      AuthResult(success: true, user: user);

  factory AuthResult.failure(String message) =>
      AuthResult(success: false, message: message);
}

/// Service d'authentification
/// À connecter avec le vrai backend (Personne 5) via HTTP
class AuthService extends ChangeNotifier {
  // ─── État interne ────────────────────────────────────────────────────────
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // ─── Getters publics ─────────────────────────────────────────────────────
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  // ─── Base URL API (à modifier selon le backend de Personne 5) ────────────
  static const String _baseUrl = 'http://10.0.2.2:8000/api'; // Emulateur Android
  // static const String _baseUrl = 'http://localhost:8000/api'; // iOS Simulator

  // ─── Simulation base de données locale (en attendant Personne 6) ─────────
  final Map<String, Map<String, String>> _fakeDB = {
    'test@isn.mr': {'password': '123456', 'nom': 'Utilisateur Test', 'id': 'usr_001'},
  };

  // ─────────────────────────────────────────────────────────────────────────
  // CONNEXION
  // ─────────────────────────────────────────────────────────────────────────
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Validation locale avant l'appel réseau
      final validationError = _validateLoginInputs(email, password);
      if (validationError != null) {
        _setLoading(false);
        return AuthResult.failure(validationError);
      }

      // TODO (Personne 5) : Remplacer par vrai appel HTTP
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/auth/login'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'email': email, 'password': password}),
      // );

      // ── Simulation réseau (2 secondes) ──
      await Future.delayed(const Duration(seconds: 2));

      // Vérification dans la fausse BD
      final emailNormalise = email.trim().toLowerCase();
      if (!_fakeDB.containsKey(emailNormalise)) {
        _setLoading(false);
        return AuthResult.failure('Aucun compte trouvé avec cet email.');
      }

      final userData = _fakeDB[emailNormalise]!;
      if (userData['password'] != password) {
        _setLoading(false);
        return AuthResult.failure('Mot de passe incorrect. Veuillez réessayer.');
      }

      // Connexion réussie
      _currentUser = UserModel(
        id: userData['id']!,
        nom: userData['nom']!,
        email: emailNormalise,
        createdAt: DateTime.now(),
      );

      _setLoading(false);
      notifyListeners();
      return AuthResult.success(_currentUser!);
    } catch (e) {
      _setLoading(false);
      return AuthResult.failure('Erreur de connexion. Vérifiez votre réseau.');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // INSCRIPTION
  // ─────────────────────────────────────────────────────────────────────────
  Future<AuthResult> register({
    required String nom,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Validation complète
      final validationError =
          _validateRegisterInputs(nom, email, password, confirmPassword);
      if (validationError != null) {
        _setLoading(false);
        return AuthResult.failure(validationError);
      }

      // TODO (Personne 5) : Remplacer par vrai appel HTTP
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/auth/register'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'nom': nom, 'email': email, 'password': password}),
      // );

      // ── Simulation réseau ──
      await Future.delayed(const Duration(seconds: 2));

      final emailNormalise = email.trim().toLowerCase();

      // Vérifier si email déjà utilisé
      if (_fakeDB.containsKey(emailNormalise)) {
        _setLoading(false);
        return AuthResult.failure('Un compte existe déjà avec cet email.');
      }

      // Créer le compte
      final newId = 'usr_${DateTime.now().millisecondsSinceEpoch}';
      _fakeDB[emailNormalise] = {
        'password': password,
        'nom': nom.trim(),
        'id': newId,
      };

      _currentUser = UserModel(
        id: newId,
        nom: nom.trim(),
        email: emailNormalise,
        createdAt: DateTime.now(),
      );

      _setLoading(false);
      notifyListeners();
      return AuthResult.success(_currentUser!);
    } catch (e) {
      _setLoading(false);
      return AuthResult.failure('Erreur lors de l\'inscription. Réessayez.');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DÉCONNEXION
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // VALIDATIONS PRIVÉES
  // ─────────────────────────────────────────────────────────────────────────
  String? _validateLoginInputs(String email, String password) {
    if (email.trim().isEmpty) return 'L\'email est obligatoire.';
    if (!_isValidEmail(email)) return 'Format d\'email invalide.';
    if (password.isEmpty) return 'Le mot de passe est obligatoire.';
    if (password.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères.';
    return null;
  }

  String? _validateRegisterInputs(
      String nom, String email, String password, String confirmPassword) {
    if (nom.trim().isEmpty) return 'Le nom est obligatoire.';
    if (nom.trim().length < 2) return 'Le nom doit contenir au moins 2 caractères.';
    if (email.trim().isEmpty) return 'L\'email est obligatoire.';
    if (!_isValidEmail(email)) return 'Format d\'email invalide (ex: nom@exemple.com).';
    if (password.isEmpty) return 'Le mot de passe est obligatoire.';
    if (password.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères.';
    if (password != confirmPassword) return 'Les mots de passe ne correspondent pas.';
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email.trim());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS PRIVÉS
  // ─────────────────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}