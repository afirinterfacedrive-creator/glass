import 'package:flutter/material.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'phone_country.dart';
import 'phone_country_registry.dart';

class PhoneCountryPicker {
  static Future<PhoneCountry?> show({
    required BuildContext context,
    PhoneCountryRegistry? registry, // <- nullable maintenant
    List<PhoneCountry>? countries, // <- AJOUT
    required GlassColorPalette palette,
    PhoneCountry? selectedCountry,
    String title = 'Changer de pays',
    String subtitle = 'Sélectionnez votre indicatif',
  }) async {
    assert(registry!=null||countries!=null,'Il faut soit registry soit countries');
    final List<PhoneCountry> list = countries?? registry!.countries;

    return showModalBottomSheet<PhoneCountry>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: palette.black.withValues(alpha: 0.62),
      builder: (BuildContext context) {
        return _PhoneCountryPickerSheet(
          countries: list, // <- on passe la liste
          palette: palette,
          selectedCountry: selectedCountry,
          title: title,
          subtitle: subtitle,
        );
      },
    );
  }
}

class _PhoneCountryPickerSheet extends StatefulWidget {
  final List<PhoneCountry> countries; // <- au lieu de registry
  final GlassColorPalette palette;
  final PhoneCountry? selectedCountry;
  final String title;
  final String subtitle;

  const _PhoneCountryPickerSheet({
    required this.countries,
    required this.palette,
    required this.selectedCountry,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_PhoneCountryPickerSheet> createState() => _PhoneCountryPickerSheetState();
}

class _PhoneCountryPickerSheetState extends State<_PhoneCountryPickerSheet> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late List<PhoneCountry> _allCountries;
  List<PhoneCountry> _results = <PhoneCountry>[];

  GlassColorPalette get _palette => widget.palette;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _allCountries = widget.countries; // <- init avec la liste
    _results = _allCountries;
    _searchController.addListener(_handleSearchChanged);
  }

  void _handleSearchChanged() {
    final String query = _searchController.text.trim().toLowerCase();
    if(query.isEmpty){
      setState(()=>_results=_allCountries);
      return;
    }
    final List<PhoneCountry> results = _allCountries.where((PhoneCountry c){
      return c.name.toLowerCase().contains(query)
          || c.isoCode.toLowerCase().contains(query)
          || c.dialCode.contains(query);
    }).toList(growable:false);
    if(!mounted)return;
    setState(()=>_results=results);
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.requestFocus();
  }

  void _selectCountry(PhoneCountry country) {
    Navigator.of(context).pop(country);
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double maxHeight = media.size.height * 0.88;
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _palette.surface.withValues(alpha: 0.98),
            _palette.surfaceSecondary.withValues(alpha: 0.995),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: _palette.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: _palette.black.withValues(alpha: 0.48),
            blurRadius: 34,
            spreadRadius: 0,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHandle(),
            _buildHeader(),
            _buildSearch(),
            Expanded(child: _buildCountryList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2),
      child: Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _palette.white.withValues(alpha: 0.16),
              _palette.white.withValues(alpha: 0.34),
              _palette.white.withValues(alpha: 0.16),
            ],
          ),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final Color accent = _palette.aqua;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent.withValues(alpha: 0.22), accent.withValues(alpha: 0.07)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: accent.withValues(alpha: 0.24)),
              boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.10), blurRadius: 14)],
            ),
            child: Icon(Icons.public_rounded, color: accent, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: _palette.textPrimary, fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
                const SizedBox(height: 4),
                Text(widget.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: _palette.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _buildCountryCount(),
        ],
      ),
    );
  }

  Widget _buildCountryCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: _palette.white.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _palette.white.withValues(alpha: 0.09)),
      ),
      child: Text('${_results.length}', style: TextStyle(color: _palette.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildSearch() {
    final Color accent = _palette.aqua;
    final bool hasQuery = _searchController.text.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_palette.white.withValues(alpha: 0.075), _palette.white.withValues(alpha: 0.035)],
          ),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: _palette.white.withValues(alpha: 0.10)),
          boxShadow: [BoxShadow(color: _palette.black.withValues(alpha: 0.14), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          style: TextStyle(color: _palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
          cursorColor: accent,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
            prefixIcon: Icon(Icons.search_rounded, color: accent.withValues(alpha: 0.82), size: 22),
            hintText: 'Rechercher un pays...',
            hintStyle: TextStyle(color: _palette.textTertiary, fontSize: 13.5, fontWeight: FontWeight.w400),
            suffixIcon: hasQuery? IconButton(tooltip: 'Effacer', splashRadius: 20, onPressed: _clearSearch, icon: Icon(Icons.close_rounded, color: _palette.textSecondary, size: 19)) : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCountryList() {
    if (_results.isEmpty) return _buildEmptyState();
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 22),
      itemCount: _results.length,
      itemBuilder: (BuildContext context, int index) {
        final PhoneCountry country = _results[index];
        return _buildCountryTile(country);
      },
    );
  }

  Widget _buildEmptyState() {
    final Color accent = _palette.aqua;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: _palette.white.withValues(alpha: 0.045),
                shape: BoxShape.circle,
                border: Border.all(color: _palette.white.withValues(alpha: 0.08)),
              ),
              child: Icon(Icons.search_off_rounded, size: 31, color: accent.withValues(alpha: 0.52)),
            ),
            const SizedBox(height: 15),
            Text('Aucun pays trouvé', style: TextStyle(color: _palette.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Essayez un autre nom,\nun indicatif ou un code ISO.', textAlign: TextAlign.center, style: TextStyle(color: _palette.textTertiary, fontSize: 12, height: 1.45)),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryTile(PhoneCountry country) {
    final bool selected = widget.selectedCountry!= null && widget.selectedCountry!.isoCode.toUpperCase() == country.isoCode.toUpperCase();
    final Color accent = _palette.aqua;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          splashColor: accent.withValues(alpha: 0.08),
          highlightColor: accent.withValues(alpha: 0.045),
          onTap: () => _selectCountry(country),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              gradient: selected? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [accent.withValues(alpha: 0.14), accent.withValues(alpha: 0.045)]) : null,
              color: selected? null : _palette.white.withValues(alpha: 0.018),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: selected? accent.withValues(alpha: 0.27) : _palette.white.withValues(alpha: 0.045)),
              boxShadow: selected? [BoxShadow(color: accent.withValues(alpha: 0.08), blurRadius: 16, spreadRadius: 0)] : null,
            ),
            child: Row(
              children: [
                _buildFlag(country, selected: selected),
                const SizedBox(width: 13),
                Expanded(child: _buildCountryInformation(country, selected: selected)),
                const SizedBox(width: 10),
                _buildDialCode(country, selected: selected),
                if (selected)...[const SizedBox(width: 10), _buildSelectedIndicator()],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryInformation(PhoneCountry country, {required bool selected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(country.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: _palette.textPrimary, fontSize: 14, fontWeight: selected? FontWeight.w800 : FontWeight.w700)),
        const SizedBox(height: 4),
        Row(
          children: [
            _buildIsoBadge(country, selected: selected),
            const SizedBox(width: 6),
            Flexible(child: Text('Numéro national', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: _palette.textTertiary, fontSize: 10.5, fontWeight: FontWeight.w400))),
          ],
        ),
      ],
    );
  }

  Widget _buildIsoBadge(PhoneCountry country, {required bool selected}) {
    final Color accent = _palette.aqua;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: selected? accent.withValues(alpha: 0.12) : _palette.white.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(country.isoCode.toUpperCase(), style: TextStyle(color: selected? accent : _palette.textSecondary, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
    );
  }

  Widget _buildDialCode(PhoneCountry country, {required bool selected}) {
    final Color accent = _palette.aqua;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: selected? accent.withValues(alpha: 0.10) : _palette.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: selected? accent.withValues(alpha: 0.16) : _palette.white.withValues(alpha: 0.055)),
      ),
      child: Text(country.dialCode, style: TextStyle(color: selected? accent : _palette.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
    );
  }

  Widget _buildSelectedIndicator() {
    final Color accent = _palette.aqua;
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Icon(Icons.check_rounded, color: accent, size: 17),
    );
  }

  Widget _buildFlag(PhoneCountry country, {required bool selected}) {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final String? asset = country.effectiveFlagAsset;
    final Color accent = _palette.aqua;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_palette.white.withValues(alpha: selected? 0.10 : 0.065), _palette.white.withValues(alpha: selected? 0.045 : 0.025)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected? accent.withValues(alpha: 0.20) : _palette.white.withValues(alpha: 0.07)),
        boxShadow: selected? [BoxShadow(color: accent.withValues(alpha: 0.07), blurRadius: 12)] : null,
      ),
      alignment: Alignment.center,
      child: asset!= null && asset.trim().isNotEmpty? ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(asset, package: 'universal_glass', width: 30, height: 21, fit: BoxFit.cover, cacheWidth: 72, errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) { return _buildEmojiFlag(country); }),
      ) : _buildEmojiFlag(country),
    );
  }

  Widget _buildEmojiFlag(PhoneCountry country) {
    return Text(country.flag, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, height: 1));
  }
}