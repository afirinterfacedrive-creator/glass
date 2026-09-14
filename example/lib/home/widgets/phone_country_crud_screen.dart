
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/home/widgets/glass_country_list_selector.dart';
import 'package:universal_glass_example/home/widgets/glass_operator_config_panel.dart';
import 'package:universal_glass_example/routes/app_router.dart';

class PhoneCountryCrudPage extends ConsumerStatefulWidget {
  const PhoneCountryCrudPage({super.key});

  @override
  ConsumerState<PhoneCountryCrudPage> createState() =>
      _PhoneCountryCrudPageState();
}

class _PhoneCountryCrudPageState
    extends ConsumerState<PhoneCountryCrudPage> {
  PhoneCountry? _selectedCountry;
  PhoneOperator? _selectedOperator;

  bool _saving = false;

  final TextEditingController _prefixTextController =
      TextEditingController();

  final FocusNode _prefixFocusNode = FocusNode();

  // ===========================================================================
  // GLASS CONTEXT
  // ===========================================================================
  //
  // Ce contexte provient du Builder placé à l'intérieur du GlassLayoutScope.
  // Il est utilisé par UniversalGlassToast afin que le toast puisse accéder
  // correctement au contexte Glass.
  //
  BuildContext? _glassContext;

  PhoneInputController get _phoneController =>
      AppRouter.sharedPhoneController;

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(_refreshState);

    _setupInitialCountry();
  }

  // ===========================================================================
  // STATE
  // ===========================================================================

  void _refreshState() {
    if (!mounted) return;

    final countries = _phoneController.allCountries;

    if (countries.isEmpty) {
      return;
    }

    PhoneCountry? updatedCountry;

    if (_selectedCountry != null) {
      for (final country in countries) {
        if (country.isoCode == _selectedCountry!.isoCode) {
          updatedCountry = country;
          break;
        }
      }
    }

    updatedCountry ??= countries.firstWhere(
      (country) => country.isoCode == 'BF',
      orElse: () => countries.first,
    );

    PhoneOperator? updatedOperator;

    if (_selectedOperator != null) {
      for (final operator in updatedCountry.operatorsDetailed) {
        if (operator.id == _selectedOperator!.id) {
          updatedOperator = operator;
          break;
        }
      }
    }

    updatedOperator ??=
        updatedCountry.operatorsDetailed.isNotEmpty
            ? updatedCountry.operatorsDetailed.first
            : null;

    setState(() {
      _selectedCountry = updatedCountry;
      _selectedOperator = updatedOperator;
    });
  }

  Future<void> _setupInitialCountry() async {
    int attempts = 0;

    while (_phoneController.allCountries.isEmpty &&
        attempts < 10) {
      await Future.delayed(
        const Duration(milliseconds: 150),
      );

      attempts++;
    }

    if (!mounted) return;

    final countries = _phoneController.allCountries;

    if (countries.isEmpty) {
      return;
    }

    final country = countries.firstWhere(
      (item) => item.isoCode == 'BF',
      orElse: () => countries.first,
    );

    setState(() {
      _selectedCountry = country;

      _selectedOperator =
          country.operatorsDetailed.isNotEmpty
              ? country.operatorsDetailed.first
              : null;
    });
  }

  // ===========================================================================
  // TOAST
  // ===========================================================================

  void _showToast({
    required String title,
    required String message,
    required GlassToastType type,
    required GlassToastPosition position,
    GlassStyle? style,
    Color? backgroundColor,
  }) {
    if (!mounted) return;

    final toastContext = _glassContext;

    if (toastContext == null) {
      debugPrint(
        'UniversalGlassToast: GlassLayoutScope context indisponible.',
      );
      return;
    }

    UniversalGlassToast.show(
      toastContext,
      title: title,
      message: message,
      type: type,
      position: position,
      style: style,
      backgroundColor: backgroundColor,
    );
  }

  // ===========================================================================
  // EXPORT
  // ===========================================================================

  Future<void> _exportJson() async {
    if (_saving) return;

    setState(() {
      _saving = true;
    });

    try {
      final path = await _phoneController.exportToJson();

      if (!mounted) return;

      if (path.isNotEmpty) {
        // Sur desktop/mobile non-web, on copie également le chemin
        // dans le presse-papiers.
        if (!kIsWeb) {
          await Clipboard.setData(
            ClipboardData(text: path),
          );
        }

        _showToast(
          title: 'Export réussi',
          message: 'Fichier: ${path.split('/').last}',
          type: GlassToastType.success,
          position: GlassToastPosition.topCenter,
        );
      } else {
        _showToast(
          title: 'Export annulé',
          message: 'Aucun fichier sélectionné',
          type: GlassToastType.warning,
          position: GlassToastPosition.center,
        );
      }
    } catch (e, stackTrace) {
      if (!mounted) return;

      _showToast(
        title: 'Erreur',
        message: 'Export annulé ou échoué',
        type: GlassToastType.error,
        position: GlassToastPosition.topCenter,
      );

      debugPrint('Export error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ===========================================================================
  // IMPORT
  // ===========================================================================

  Future<void> _importJson() async {
    if (_saving) return;

    setState(() {
      _saving = true;
    });

    try {
      final success = await _phoneController.importFromJson();

      if (!mounted) return;

      if (success) {
        _refreshState();

        _showToast(
          title: 'Import réussi',
          message: 'Cache mis à jour',
          type: GlassToastType.success,
          position: GlassToastPosition.center,
        );
      } else {
        _showToast(
          title: 'Erreur',
          message: 'Fichier invalide',
          type: GlassToastType.error,
          position: GlassToastPosition.center,
        );
      }
    } catch (e, stackTrace) {
      if (!mounted) return;

      _showToast(
        title: 'Erreur',
        message: 'Import annulé',
        type: GlassToastType.error,
        position: GlassToastPosition.center,
      );

      debugPrint('Import error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ===========================================================================
  // RESET
  // ===========================================================================

  Future<void> _resetToDefault() async {
    if (_saving) return;

    setState(() {
      _saving = true;
    });

    try {
      await _phoneController.resetToDefault();

      if (!mounted) return;

      _refreshState();

      _showToast(
        title: 'Reset effectué',
        message: 'Retour au JSON d’asset',
        type: GlassToastType.warning,
        position: GlassToastPosition.center,
      );
    } catch (e, stackTrace) {
      if (!mounted) return;

      _showToast(
        title: 'Erreur',
        message: 'Reset échoué',
        type: GlassToastType.error,
        position: GlassToastPosition.center,
      );

      debugPrint('Reset error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _phoneController.removeListener(_refreshState);

    _prefixTextController.dispose();
    _prefixFocusNode.dispose();

    _glassContext = null;

    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final GlassThemeState theme = ref.watch(
      glassThemeProvider,
    );

    return GlassScaffold(
      title: 'Gestion des Préfixes Réseau',
      subtitle: 'PHONE CRUD PANEL',
      showLogo: true,
      showBackButton: true,
      blur: theme.blur,
      noise: theme.noise,
      hideNavigation: true,
      child: Builder(
        builder: (BuildContext innerContext) {
          // IMPORTANT :
          // innerContext est à l'intérieur du GlassLayoutScope créé par
          // GlassScaffold. On le conserve pour les appels aux toasts.
          _glassContext = innerContext;

          final glass = GlassLayoutScope.of(innerContext);
          final palette = glass.palette;

          return ListenableBuilder(
            listenable: _phoneController,
            builder: (context, _) {
              if (_phoneController.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 24,
                ),
                child: GlassResponsiveGrid(
                  spacing: 16,
                  runSpacing: 16,
                  mobileColumns: 1,
                  tabletColumns: 2,
                  desktopColumns: 2,
                  children: [
                    // =========================================================
                    // COUNTRY LIST
                    // =========================================================

                    GlassSurfaceContainer(
                      style: glass.effectiveGlassStyle,
                      effects: glass.effects,
                      borderRadius: BorderRadius.circular(
                        glass.theme.borderRadius,
                      ),
                      padding: glass.dynamicPadding,
                      child: GlassCountryListSelector(
                        countries:
                            _phoneController.allCountries,
                        selectedCountry: _selectedCountry,
                        onCountrySelected: (country) {
                          setState(() {
                            _selectedCountry = country;

                            _selectedOperator =
                                country.operatorsDetailed.isNotEmpty
                                    ? country.operatorsDetailed.first
                                    : null;

                            _prefixTextController.clear();
                          });
                        },
                      ),
                    ),

                    // =========================================================
                    // COUNTRY CONFIGURATION
                    // =========================================================

                    if (_selectedCountry != null)
                      GlassSurfaceContainer(
                        style: glass.effectiveGlassStyle,
                        effects: glass.effects,
                        borderRadius: BorderRadius.circular(
                          glass.theme.borderRadius,
                        ),
                        padding: glass.dynamicPadding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Configurer : '
                              '${_selectedCountry!.name} '
                              '${_selectedCountry!.flag}',
                              style: TextStyle(
                                fontSize: glass.fontSize(15),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // =================================================
                            // OPERATOR CONFIGURATION
                            // =================================================

                            GlassOperatorConfigPanel(
                              country: _selectedCountry!,
                              controller: _phoneController,
                              palette: palette,
                              selectedOperator:
                                  _selectedOperator,
                              prefixTextController:
                                  _prefixTextController,
                              prefixFocusNode:
                                  _prefixFocusNode,
                              inputStyle:
                                  GlassInputStyle.compact()
                                      .copyWith(
                                enableBlur: false,
                                shape: GlassShapeType.pill,
                              ),
                              saving: _saving,
                              onOperatorSelected: (operator) {
                                setState(() {
                                  _selectedOperator =
                                      operator;
                                });
                              },
                              onChanged: _refreshState,
                              onToast: _showToast,
                            ),

                            const SizedBox(height: 24),

                            // =================================================
                            // EXPORT
                            // =================================================

                            UniversalGlassButton(
                              buttonId: 'export_json_btn',
                              key: const ValueKey(
                                'export_json_btn',
                              ),
                              height: 48,
                              effects: glass.effects,
                              shape: GlassShapeType.pill,
                              style:
                                  GlassStyle.transparentAqua,
                              label: 'Exporter JSON',
                              icon: Icons.download_rounded,
                              iconSize: 20,
                              enabled: !_saving,
                              futureOnTap: _exportJson,
                            ),

                            const SizedBox(height: 12),

                            // =================================================
                            // IMPORT + RESET
                            // =================================================

                            Row(
                              children: [
                                Expanded(
                                  child: UniversalGlassButton(
                                    buttonId:
                                        'import_json_btn',
                                    key: const ValueKey(
                                      'import_json_btn',
                                    ),
                                    height: 48,
                                    effects: glass.effects,
                                    shape:
                                        GlassShapeType.pill,
                                    style: GlassStyle
                                        .transparentGreen,
                                    label: 'Importer JSON',
                                    icon: Icons.upload_rounded,
                                    iconSize: 20,
                                    enabled: !_saving,
                                    futureOnTap: _importJson,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: UniversalGlassButton(
                                    buttonId:
                                        'reset_json_btn',
                                    key: const ValueKey(
                                      'reset_json_btn',
                                    ),
                                    height: 48,
                                    effects: glass.effects,
                                    shape:
                                        GlassShapeType.pill,
                                    style: GlassStyle
                                        .transparentRed,
                                    label: 'Reset Défaut',
                                    icon:
                                        Icons.restore_rounded,
                                    iconSize: 20,
                                    enabled: !_saving,
                                    futureOnTap:
                                        _resetToDefault,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
