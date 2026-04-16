import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// 
// MODÈLES
// 

enum StatutCommande {
  enAttente,
  enPreparation,
  enLivraison,
  livree,
  annulee,
}

class EtapeSuivi {
  final String titre;
  final String description;
  final DateTime date;
  final EtatEtape etat; // done, active, pending

  const EtapeSuivi({
    required this.titre,
    required this.description,
    required this.date,
    required this.etat,
  });
}

enum EtatEtape { done, active, pending }

class Commande {
  final String id;
  final DateTime dateCommande;
  final double montant;
  final StatutCommande statut;
  final int nombreProduits;
  final String transporteur;
  final String numeroSuivi;
  final DateTime? dateLivraisonEstimee;
  final List<EtapeSuivi> etapes;

  const Commande({
    required this.id,
    required this.dateCommande,
    required this.montant,
    required this.statut,
    required this.nombreProduits,
    this.transporteur = '',
    this.numeroSuivi = '',
    this.dateLivraisonEstimee,
    required this.etapes,
  });

  double get progressionLivraison {
    if (etapes.isEmpty) return 0;
    final faites = etapes.where((e) => e.etat == EtatEtape.done).length;
    return faites / etapes.length;
  }
}

// 
// DONNÉES FICTIVES
// 

final List<Commande> _donneesTest = [
  Commande(
    id: '#CMD-20260412-7845',
    dateCommande: DateTime(2026, 4, 12),
    montant: 24500,
    statut: StatutCommande.enLivraison,
    nombreProduits: 4,
    transporteur: 'DHL Djibouti',
    numeroSuivi: 'DL784512345DJ',
    dateLivraisonEstimee: DateTime(2026, 4, 18),
    etapes: [
      EtapeSuivi(
        titre: 'Commande confirmée',
        description: 'Paiement validé avec succès',
        date: DateTime(2026, 4, 12, 10, 30),
        etat: EtatEtape.done,
      ),
      EtapeSuivi(
        titre: 'En préparation',
        description: 'Colis emballé et prêt',
        date: DateTime(2026, 4, 13, 14, 0),
        etat: EtatEtape.done,
      ),
      EtapeSuivi(
        titre: 'Expédiée',
        description: 'Remis à DHL Djibouti',
        date: DateTime(2026, 4, 14, 9, 15),
        etat: EtatEtape.done,
      ),
      EtapeSuivi(
        titre: 'En cours de livraison',
        description: 'Centre de tri de Djibouti',
        date: DateTime(2026, 4, 14, 11, 0),
        etat: EtatEtape.active,
      ),
      EtapeSuivi(
        titre: 'Livraison prévue',
        description: '',
        date: DateTime(2026, 4, 18),
        etat: EtatEtape.pending,
      ),
    ],
  ),
  Commande(
    id: '#CMD-20260401-3312',
    dateCommande: DateTime(2026, 4, 1),
    montant: 8200,
    statut: StatutCommande.livree,
    nombreProduits: 2,
    transporteur: 'DHL Djibouti',
    numeroSuivi: 'DL332100011DJ',
    dateLivraisonEstimee: DateTime(2026, 4, 8),
    etapes: [
      EtapeSuivi(
        titre: 'Commande confirmée',
        description: 'Paiement validé',
        date: DateTime(2026, 4, 1, 9, 0),
        etat: EtatEtape.done,
      ),
      EtapeSuivi(
        titre: 'En préparation',
        description: 'Colis préparé',
        date: DateTime(2026, 4, 2, 10, 0),
        etat: EtatEtape.done,
      ),
      EtapeSuivi(
        titre: 'Expédiée',
        description: 'Remis au transporteur',
        date: DateTime(2026, 4, 4, 8, 30),
        etat: EtatEtape.done,
      ),
      EtapeSuivi(
        titre: 'Livrée',
        description: 'Livraison effectuée',
        date: DateTime(2026, 4, 8, 14, 0),
        etat: EtatEtape.done,
      ),
    ],
  ),
  Commande(
    id: '#CMD-20260415-9901',
    dateCommande: DateTime(2026, 4, 15),
    montant: 3900,
    statut: StatutCommande.enPreparation,
    nombreProduits: 1,
    transporteur: 'DHL Djibouti',
    numeroSuivi: '',
    dateLivraisonEstimee: DateTime(2026, 4, 20),
    etapes: [
      EtapeSuivi(
        titre: 'Commande confirmée',
        description: 'Paiement validé',
        date: DateTime(2026, 4, 15, 11, 0),
        etat: EtatEtape.done,
      ),
      EtapeSuivi(
        titre: 'En préparation',
        description: 'Colis en cours d\'emballage',
        date: DateTime(2026, 4, 15, 14, 0),
        etat: EtatEtape.active,
      ),
      EtapeSuivi(
        titre: 'Expédition prévue',
        description: '',
        date: DateTime(2026, 4, 17),
        etat: EtatEtape.pending,
      ),
    ],
  ),
  Commande(
    id: '#CMD-20260310-0055',
    dateCommande: DateTime(2026, 3, 10),
    montant: 15750,
    statut: StatutCommande.annulee,
    nombreProduits: 3,
    transporteur: '',
    numeroSuivi: '',
    etapes: [
      EtapeSuivi(
        titre: 'Commande confirmée',
        description: 'Paiement validé',
        date: DateTime(2026, 3, 10, 9, 0),
        etat: EtatEtape.done,
      ),
      EtapeSuivi(
        titre: 'Annulée',
        description: 'Commande annulée sur demande',
        date: DateTime(2026, 3, 11, 10, 30),
        etat: EtatEtape.done,
      ),
    ],
  ),
];

// 
// THÈME & COULEURS
// 

class _Couleurs {
  static const primary = Color(0xFF1A1A2E);
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF8F9FA);
  static const border = Color(0xFFEEEEEE);

  static const orange = Color(0xFFE65100);
  static const orangeLight = Color(0xFFFFF3E0);
  static const vert = Color(0xFF2E7D32);
  static const vertLight = Color(0xFFE8F5E9);
  static const bleu = Color(0xFF1565C0);
  static const bleuLight = Color(0xFFE3F2FD);
  static const gris = Color(0xFF616161);
  static const grisLight = Color(0xFFF5F5F5);

  static Color statutBackground(StatutCommande s) {
    switch (s) {
      case StatutCommande.enLivraison:
        return orangeLight;
      case StatutCommande.livree:
        return vertLight;
      case StatutCommande.enPreparation:
        return bleuLight;
      case StatutCommande.enAttente:
        return const Color(0xFFFFFDE7);
      case StatutCommande.annulee:
        return grisLight;
    }
  }

  static Color statutForeground(StatutCommande s) {
    switch (s) {
      case StatutCommande.enLivraison:
        return orange;
      case StatutCommande.livree:
        return vert;
      case StatutCommande.enPreparation:
        return bleu;
      case StatutCommande.enAttente:
        return const Color(0xFFF57F17);
      case StatutCommande.annulee:
        return gris;
    }
  }

  static Color progressColor(StatutCommande s) {
    switch (s) {
      case StatutCommande.enLivraison:
        return orange;
      case StatutCommande.livree:
        return vert;
      case StatutCommande.enPreparation:
        return bleu;
      default:
        return gris;
    }
  }
}

// 
// PAGE PRINCIPALE
// 

class CommandeSuiviePage extends StatefulWidget {
  const CommandeSuiviePage({super.key});

  @override
  State<CommandeSuiviePage> createState() => _CommandeSuiviePageState();
}

class _CommandeSuiviePageState extends State<CommandeSuiviePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = ['Toutes', 'En cours', 'Livraison', 'Terminées'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Commande> get _commandesFiltrees {
    switch (_tabController.index) {
      case 1:
        return _donneesTest
            .where((c) =>
                c.statut == StatutCommande.enAttente ||
                c.statut == StatutCommande.enPreparation)
            .toList();
      case 2:
        return _donneesTest
            .where((c) => c.statut == StatutCommande.enLivraison)
            .toList();
      case 3:
        return _donneesTest
            .where((c) =>
                c.statut == StatutCommande.livree ||
                c.statut == StatutCommande.annulee)
            .toList();
      default:
        return _donneesTest;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Couleurs.background,
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          _tabs.length,
          (_) => _buildListe(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _Couleurs.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Mes commandes',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _Couleurs.primary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: _Couleurs.primary),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded,
              color: _Couleurs.primary),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: _Couleurs.border),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: _Couleurs.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.5, color: _Couleurs.primary),
              insets: EdgeInsets.symmetric(horizontal: 8),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            tabAlignment: TabAlignment.start,
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildListe() {
    final commandes = _commandesFiltrees;
    if (commandes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Aucune commande',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: commandes.length,
      itemBuilder: (context, i) => _CommandeCard(
        commande: commandes[i],
        onSuivre: () => _ouvrirDetails(context, commandes[i]),
      ),
    );
  }

  void _ouvrirDetails(BuildContext context, Commande commande) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailsSheet(commande: commande),
    );
  }
}

// 
// CARTE COMMANDE
// 

class _CommandeCard extends StatelessWidget {
  final Commande commande;
  final VoidCallback onSuivre;

  const _CommandeCard({required this.commande, required this.onSuivre});

  String get _statutTexte {
    switch (commande.statut) {
      case StatutCommande.enLivraison:
        return 'En livraison';
      case StatutCommande.livree:
        return 'Livrée';
      case StatutCommande.enPreparation:
        return 'En préparation';
      case StatutCommande.enAttente:
        return 'En attente';
      case StatutCommande.annulee:
        return 'Annulée';
    }
  }

  String get _progressionTexteGauche {
    switch (commande.statut) {
      case StatutCommande.enLivraison:
        return 'Expédiée';
      case StatutCommande.livree:
        return 'Livrée le ${DateFormat('d MMM', 'fr').format(commande.dateLivraisonEstimee ?? DateTime.now())}';
      case StatutCommande.enPreparation:
        return 'Emballage';
      case StatutCommande.enAttente:
        return 'En attente';
      case StatutCommande.annulee:
        return 'Annulée';
    }
  }

  String get _progressionTexteDroite {
    if (commande.statut == StatutCommande.livree) return ' Complète';
    if (commande.statut == StatutCommande.annulee) return '';
    if (commande.dateLivraisonEstimee != null) {
      return 'Prévu le ${DateFormat('d MMM', 'fr').format(commande.dateLivraisonEstimee!)}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final couleurStatut = _Couleurs.statutForeground(commande.statut);
    final bgStatut = _Couleurs.statutBackground(commande.statut);
    final couleurProgress = _Couleurs.progressColor(commande.statut);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _Couleurs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _Couleurs.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onSuivre,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID + Badge statut
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commande.id,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _Couleurs.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('d MMMM yyyy', 'fr').format(commande.dateCommande),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: bgStatut,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: couleurStatut,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _statutTexte,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: couleurStatut,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Miniatures produits
                    _ProduitsRow(nombreProduits: commande.nombreProduits),

                    const SizedBox(height: 14),

                    // Barre de progression
                    if (commande.statut != StatutCommande.annulee) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _progressionTexteGauche,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            _progressionTexteDroite,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: commande.progressionLivraison,
                          backgroundColor: const Color(0xFFEEEEEE),
                          valueColor: AlwaysStoppedAnimation<Color>(couleurProgress),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Bannière transporteur (si en livraison)
              if (commande.statut == StatutCommande.enLivraison &&
                  commande.transporteur.isNotEmpty)
                _TransporteurBanner(commande: commande),

              const Divider(height: 1, color: _Couleurs.border),

              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${NumberFormat('#,###', 'fr').format(commande.montant)} DJF',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _Couleurs.primary,
                      ),
                    ),
                    Row(
                      children: [
                        // Bouton recommander
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Commande ajoutée au panier !'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh_rounded, size: 14),
                          label: const Text('Recommander'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Bouton suivre / détails
                        ElevatedButton(
                          onPressed: onSuivre,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _Couleurs.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(commande.statut == StatutCommande.livree
                              ? 'Détails'
                              : 'Suivre'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 
// PRODUITS ROW (miniatures)
// 

class _ProduitsRow extends StatelessWidget {
  final int nombreProduits;
  static const _icons = [
    Icons.shopping_bag_outlined,
    Icons.laptop_outlined,
    Icons.favorite_outline,
    Icons.watch_outlined,
    Icons.headphones_outlined,
  ];

  const _ProduitsRow({required this.nombreProduits});

  @override
  Widget build(BuildContext context) {
    final visibles = nombreProduits.clamp(0, 3);
    final reste = nombreProduits - visibles;

    return Row(
      children: [
        ...List.generate(
          visibles,
          (i) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _Couleurs.border),
              ),
              child: Icon(
                _icons[i % _icons.length],
                size: 22,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ),
        if (reste > 0)
          Text(
            '+$reste',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
      ],
    );
  }
}

// 
// BANNIÈRE TRANSPORTEUR
// 

class _TransporteurBanner extends StatelessWidget {
  final Commande commande;
  const _TransporteurBanner({required this.commande});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _Couleurs.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined,
              size: 18, color: _Couleurs.bleu),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                children: [
                  TextSpan(
                    text: '${commande.transporteur}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _Couleurs.primary,
                    ),
                  ),
                  if (commande.numeroSuivi.isNotEmpty)
                    TextSpan(text: '  ${commande.numeroSuivi}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 
// BOTTOM SHEET DÉTAILS
// 

class _DetailsSheet extends StatelessWidget {
  final Commande commande;
  const _DetailsSheet({required this.commande});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: _Couleurs.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête
                      Text(
                        'Commande ${commande.id}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _Couleurs.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Commandée le ${DateFormat('d MMMM yyyy à HH\'h\'mm', 'fr').format(commande.dateCommande)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Section timeline
                      const _SectionLabel(label: 'Suivi de livraison'),
                      const SizedBox(height: 12),
                      _Timeline(etapes: commande.etapes),

                      // Section transporteur
                      if (commande.transporteur.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const _SectionLabel(label: 'Informations transporteur'),
                        const SizedBox(height: 4),
                        _InfoLigne(
                          icone: Icons.local_shipping_outlined,
                          label: 'Transporteur',
                          valeur: commande.transporteur,
                        ),
                        if (commande.numeroSuivi.isNotEmpty)
                          _InfoLigne(
                            icone: Icons.qr_code_scanner_rounded,
                            label: 'Numéro de suivi',
                            valeur: commande.numeroSuivi,
                            actionLabel: 'Copier',
                            onAction: () {
                              Clipboard.setData(ClipboardData(text: commande.numeroSuivi));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Numéro copié !'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        if (commande.dateLivraisonEstimee != null)
                          _InfoLigne(
                            icone: Icons.calendar_today_outlined,
                            label: 'Livraison estimée',
                            valeur: DateFormat('d MMMM yyyy', 'fr').format(commande.dateLivraisonEstimee!),
                          ),
                      ],

                      const SizedBox(height: 28),

                      // Boutons d'action
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              label: 'Facture PDF',
                              icone: Icons.download_outlined,
                              couleurFond: _Couleurs.bleuLight,
                              couleurTexte: _Couleurs.bleu,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ActionButton(
                              label: 'Contacter',
                              icone: Icons.chat_bubble_outline_rounded,
                              couleurFond: _Couleurs.vertLight,
                              couleurTexte: _Couleurs.vert,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 
// SECTION LABEL
// 

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 0.8,
      ),
    );
  }
}

// 
// TIMELINE
// 

class _Timeline extends StatelessWidget {
  final List<EtapeSuivi> etapes;
  const _Timeline({required this.etapes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(etapes.length, (i) {
        final etape = etapes[i];
        final estDernier = i == etapes.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colonne indicateur + trait
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    _TLDot(etat: etape.etat),
                    if (!estDernier)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          color: etape.etat == EtatEtape.done
                              ? _Couleurs.vert.withOpacity(0.35)
                              : _Couleurs.border,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Contenu
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: estDernier ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        etape.titre,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: etape.etat == EtatEtape.active
                              ? _Couleurs.orange
                              : etape.etat == EtatEtape.pending
                                  ? Colors.grey
                                  : _Couleurs.primary,
                        ),
                      ),
                      if (etape.description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          etape.description,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                      const SizedBox(height: 3),
                      Text(
                        DateFormat('dd/MM/yyyy  HH\'h\'mm', 'fr').format(etape.date),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TLDot extends StatelessWidget {
  final EtatEtape etat;
  const _TLDot({required this.etat});

  @override
  Widget build(BuildContext context) {
    switch (etat) {
      case EtatEtape.done:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: _Couleurs.vert,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
        );
      case EtatEtape.active:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: _Couleurs.orange,
            shape: BoxShape.circle,
            border: Border.all(
              color: _Couleurs.orangeLight,
              width: 3,
            ),
          ),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      case EtatEtape.pending:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
        );
    }
  }
}

// 
// INFO LIGNE
// 

class _InfoLigne extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _InfoLigne({
    required this.icone,
    required this.label,
    required this.valeur,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, size: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  valeur,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _Couleurs.primary,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: _Couleurs.bleu,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

// 
// BOUTON D'ACTION (PDF / Contacter)
// 

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icone;
  final Color couleurFond;
  final Color couleurTexte;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icone,
    required this.couleurFond,
    required this.couleurTexte,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: couleurFond,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 16, color: couleurTexte),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: couleurTexte,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
