import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_settings.dart';
import 'package:universal_glass_example/settings/widgets/appearance/glass_style_adapter.dart';


class HomePhoneInputPreview extends ConsumerStatefulWidget {
  final PhoneInputController phoneController;
  final AppearanceSettings settings; // <- AJOUT
  final bool? useAquaStyle;
  const HomePhoneInputPreview({super.key, required this.phoneController,required this.settings, this.useAquaStyle});

  @override
  ConsumerState<HomePhoneInputPreview> createState()=>_HomePhoneInputPreviewState();
}

class _HomePhoneInputPreviewState extends ConsumerState<HomePhoneInputPreview>{
  late final TextEditingController _phoneController;
  late final FocusNode _phoneFocusNode;
  late final TextEditingController _nameController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  List<PhoneCountry> _allCountries=const[];
  PhoneCountry? _country;
  String _normalizedPhone='';
  String _submittedPhone='';
  PhoneOperator? _operator;
  AutovalidateMode _autoValidate=AutovalidateMode.disabled;

  @override
  void initState(){
    super.initState();
    _phoneController=TextEditingController();
    _phoneFocusNode=FocusNode();
    _nameController=TextEditingController();
    _nameFocusNode=FocusNode();
    _emailFocusNode=FocusNode();
    _loadCountries();
  }

  Future<void> _loadCountries()async{
    final countries=await PhoneCountryDatabase.defaultCountries;
    if(!mounted)return;
    setState((){
      _allCountries=countries;
      _country=countries.firstWhere((c)=>c.isoCode=='BF',orElse:()=>countries.first);
    });
  }

  void _onCountryChanged(PhoneCountry newCountry){
    if(!mounted)return;
    setState((){
      _country=newCountry;
      _normalizedPhone='';
      _operator=null;
      _autoValidate=AutovalidateMode.disabled;
    });
    _phoneController.clear();
  }

  PhoneOperator? _detectOperator(String digits){
    if(_country==null)return null;
    return _country!.operatorForPrefix(digits);
  }

  String? _validatePhone(String? value){
    if(value==null||value.isEmpty)return'Numéro requis';
    final digits=value.replaceAll(RegExp(r'\D'),'');
    if(_country==null)return null;
    if(!_country!.acceptsLength(digits.length))return'${_country!.phoneDigits} chiffres requis';
    if(_country!.prefixes.isNotEmpty&&!_country!.acceptsPrefix(digits))return'Préfixe invalide';
    if(_isFakeNumber(digits))return'Numéro invalide';
    return null;
  }

  bool _isFakeNumber(String digits){
    if(digits.length<4)return false;
    if(RegExp(r'^(\d)\1+$').hasMatch(digits))return true;
    bool isSeq=true;
    for(int i=1;i<digits.length;i++){if(int.parse(digits[i])!=int.parse(digits[i-1])+1){isSeq=false;break;}}
    if(isSeq)return true;
    bool isRevSeq=true;
    for(int i=1;i<digits.length;i++){if(int.parse(digits[i])!=int.parse(digits[i-1])-1){isRevSeq=false;break;}}
    if(isRevSeq)return true;
    return false;
  }

  void _handlePhoneChanged(String value){
    if(!mounted)return;
    final digits=value.replaceAll(RegExp(r'\D'),'');
    setState((){
      _normalizedPhone=digits;
      _operator=_detectOperator(digits);
    });
  }

  void _handlePhoneSubmitted(String value){
    if(!mounted)return;
    final digits=value.replaceAll(RegExp(r'\D'),'');
    setState((){
      _submittedPhone=digits;
      _autoValidate=AutovalidateMode.always;
    });
  }

  String? _validateName(String? value){
    return(value==null||value.trim().isEmpty)?'Nom requis':null;
  }

  void _clearPhone(){
    _phoneController.clear();
    if(!mounted)return;
    setState((){
      _normalizedPhone='';
      _submittedPhone='';
      _operator=null;
      _autoValidate=AutovalidateMode.disabled;
    });
    _phoneFocusNode.requestFocus();
  }

  @override
  void dispose(){
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _buildPhoneInput(GlassInputStyle inputStyle){
    return UniversalGlassPhoneInput(
      controller:_phoneController,
      focusNode:_phoneFocusNode,
      style: inputStyle.copyWith( // <- DYNAMIQUE + OVERRIDE LOCAL
        fieldHeight: 55,
        fontSize: 16,
        enableBlur: false,
      ),
      label:'Numéro de téléphone',
      initialCountryIsoCode:'BF',
      countryPickerEnabled:true,
      countries:_allCountries,
      onCountryChanged:_onCountryChanged,
      formatPhoneNumber:true,
      maxPhoneDigits:_country?.phoneDigits??8,
      suffixIcon:Icons.clear_rounded,
      onSuffixTap:_clearPhone,
      onChanged:_handlePhoneChanged,
      onSubmitted:_handlePhoneSubmitted,
      textInputAction:TextInputAction.done,
      width:double.infinity,
      validator:_validatePhone,
      autovalidateMode:_autoValidate,
    );
  }

  Widget _buildPhoneBlock(GlassColorPalette palette, GlassInputStyle inputStyle){
    return Column(
      mainAxisSize:MainAxisSize.min,
      crossAxisAlignment:CrossAxisAlignment.stretch,
      children:[
        _buildPhoneInput(inputStyle),
        if(_operator!=null||_normalizedPhone.isNotEmpty)
          Padding(padding:const EdgeInsets.only(top:12),child:Row(mainAxisAlignment:MainAxisAlignment.end,children:[_buildOperatorBadge(_operator,palette.accent)])),
        if(_normalizedPhone.isNotEmpty||_submittedPhone.isNotEmpty)
          Padding(padding:const EdgeInsets.only(top:14),child:Column(children:[
            _buildValue('Numéro normalisé',_normalizedPhone,palette),
            const SizedBox(height:8),
            _buildValue('Numéro soumis',_submittedPhone,palette),
          ])),
      ],
    );
  }

  Widget _buildNameField(GlassInputStyle inputStyle){
    return UniversalGlassTextFieldOutlined(
      controller:_nameController,
      focusNode:_nameFocusNode,
      style: inputStyle.copyWith( // <- DYNAMIQUE
        fieldHeight: 55,
        fontSize: 16,
        enableBlur: false,
      ),
      label:'Nom complet',
      hintText:'Entrez votre nom',
      prefixIcon:Icons.person_outline_rounded,
      textInputAction:TextInputAction.next,
      validator:_validateName,
      autovalidateMode:AutovalidateMode.onUserInteraction,
      onChanged:(_)=>setState((){}),
      onSubmitted:(_)=>_emailFocusNode.requestFocus(),
      textCase:GlassTextCase.capitalize,
    );
  }

  @override
  Widget build(BuildContext context){
    final glass=ref.watchGlassContext(context);
    final palette=glass.palette;

    // <- DYNAMIQUE COMME APPEARANCESECTIONBUILDERS
    final inputStyle = widget.settings.input.toGlassStyle();

    return GlassSurfaceContainer(
      style:glass.effectiveGlassStyle,
      effects:glass.effects,
      borderRadius:BorderRadius.circular(glass.theme.borderRadius),
      padding:glass.dynamicPadding,
      child:Column(
        mainAxisSize:MainAxisSize.min,
        crossAxisAlignment:CrossAxisAlignment.stretch,
        children:[
          GlassResponsiveGrid(
            spacing:16,
            runSpacing:16,
            mobileColumns:1,
            tabletColumns:2,
            desktopColumns:2,
            children:[
              _buildPhoneBlock(palette, inputStyle),
              _buildNameField(inputStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorBadge(PhoneOperator? operator,Color focusColor){
    final isFake=_normalizedPhone.isNotEmpty&&_isFakeNumber(_normalizedPhone);
    final badgeColor=isFake?Colors.redAccent:operator?.color??focusColor;
    return AnimatedContainer(
      duration:const Duration(milliseconds:200),
      padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
      decoration:BoxDecoration(
        color:badgeColor.withValues(alpha:0.15),
        borderRadius:BorderRadius.circular(20),
        border:Border.all(color:badgeColor.withValues(alpha:0.4)),
      ),
      child:Text(isFake?'Invalide':operator?.shortName??'—',style:TextStyle(color:badgeColor,fontSize:11,fontWeight:FontWeight.w700)),
    );
  }

  Widget _buildValue(String label,String value,GlassColorPalette palette){
    return Container(
      width:double.infinity,
      padding:const EdgeInsets.symmetric(horizontal:12,vertical:10),
      decoration:BoxDecoration(
        color:Colors.white.withValues(alpha:0.03),
        borderRadius:BorderRadius.circular(12),
        border:Border.all(color:Colors.white.withValues(alpha:0.05),width:0.8),
      ),
      child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
        Expanded(child:Text(label,style:TextStyle(color:palette.textSecondary,fontSize:13))),
        const SizedBox(width:12),
        Flexible(child:Text(value.isEmpty?'—':value,textAlign:TextAlign.right,overflow:TextOverflow.ellipsis,style:TextStyle(color:palette.textPrimary,fontSize:14,fontWeight:FontWeight.w700))),
      ]),
    );
  }
}