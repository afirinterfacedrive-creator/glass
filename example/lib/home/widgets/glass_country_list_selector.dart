import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class GlassCountryListSelector extends ConsumerStatefulWidget {
  final List<PhoneCountry> countries;
  final PhoneCountry? selectedCountry;
  final ValueChanged<PhoneCountry> onCountrySelected;

  const GlassCountryListSelector({
    super.key,
    required this.countries,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  ConsumerState<GlassCountryListSelector> createState()=>_GlassCountryListSelectorState();
}

class _GlassCountryListSelectorState extends ConsumerState<GlassCountryListSelector>{
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late List<PhoneCountry> _allCountries;
  List<PhoneCountry> _results=<PhoneCountry>[];

  @override
  void initState(){
    super.initState();
    _searchController=TextEditingController();
    _searchFocusNode=FocusNode();
    _allCountries=widget.countries;
    _results=_allCountries;
    _searchController.addListener(_handleSearchChanged);
  }

  void _handleSearchChanged(){
    final query=_searchController.text.trim().toLowerCase();
    if(query.isEmpty){setState(()=>_results=_allCountries);return;}
    final results=_allCountries.where((c){
      return c.name.toLowerCase().contains(query)||c.isoCode.toLowerCase().contains(query)||c.dialCode.contains(query);
    }).toList(growable:false);
    if(!mounted)return;
    setState(()=>_results=results);
  }

  void _clearSearch(){
    _searchController.clear();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose(){
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final glass=ref.watchGlassContext(context);
    final palette=glass.palette;
    final accent=palette.aqua;

    // ignore: avoid_unnecessary_containers
    return Container(
      child:Column(
        mainAxisSize:MainAxisSize.min,
        children:[
          _buildSearch(palette,accent),
          const SizedBox(height:8),
          SizedBox(height:350,child:_buildCountryList(palette,accent)),
        ],
      ),
    );
  }

  Widget _buildSearch(GlassColorPalette palette,Color accent){
    final hasQuery=_searchController.text.trim().isNotEmpty;
    return Padding(
      padding:const EdgeInsets.fromLTRB(0,14,0,0),
      child:Container(
        height:52,
        decoration:BoxDecoration(
          gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[palette.white.withValues(alpha:0.075),palette.white.withValues(alpha:0.035)]),
          borderRadius:BorderRadius.circular(17),
          border:Border.all(color:palette.white.withValues(alpha:0.10)),
          boxShadow:[BoxShadow(color:palette.black.withValues(alpha:0.14),blurRadius:12,offset:const Offset(0,4))],
        ),
        child:TextField(
          controller:_searchController,
          focusNode:_searchFocusNode,
          style:TextStyle(color:palette.textPrimary,fontSize:14,fontWeight:FontWeight.w500),
          cursorColor:accent,
          decoration:InputDecoration(
            border:InputBorder.none,
            contentPadding:const EdgeInsets.symmetric(horizontal:4,vertical:15),
            prefixIcon:Icon(Icons.search_rounded,color:accent.withValues(alpha:0.82),size:22),
            hintText:'Rechercher un pays...',
            hintStyle:TextStyle(color:palette.textTertiary,fontSize:13.5),
            suffixIcon:hasQuery?IconButton(tooltip:'Effacer',splashRadius:20,onPressed:_clearSearch,icon:Icon(Icons.close_rounded,color:palette.textSecondary,size:19)):null,
          ),
        ),
      ),
    );
  }

  Widget _buildCountryList(GlassColorPalette palette,Color accent){
    if(_results.isEmpty)return Center(child:Padding(padding:const EdgeInsets.all(32),child:Text('Aucun pays trouvé',style:TextStyle(color:palette.textPrimary,fontSize:15,fontWeight:FontWeight.w700))));
    return ListView.builder(
      keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag,
      physics:const BouncingScrollPhysics(),
      padding:const EdgeInsets.only(left:0,right:0,bottom:16),
      itemCount:_results.length,
      itemBuilder:(context,index)=>_buildCountryTile(_results[index],palette,accent),
    );
  }

  Widget _buildCountryTile(PhoneCountry country,GlassColorPalette palette,Color accent){
    final selected=widget.selectedCountry?.isoCode.toUpperCase()==country.isoCode.toUpperCase();
    return Padding(
      padding:const EdgeInsets.symmetric(vertical:3),
      child:Material(
        color:Colors.transparent,
        borderRadius:BorderRadius.circular(17),
        child:InkWell(
          borderRadius:BorderRadius.circular(17),
          splashColor:accent.withValues(alpha:0.08),
          highlightColor:accent.withValues(alpha:0.045),
          onTap:()=>widget.onCountrySelected(country),
          child:AnimatedContainer(
            duration:const Duration(milliseconds:180),
            curve:Curves.easeOutCubic,
            padding:const EdgeInsets.symmetric(horizontal:12,vertical:10),
            decoration:BoxDecoration(
              gradient:selected?LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[accent.withValues(alpha:0.14),accent.withValues(alpha:0.045)]):null,
              color:selected?null:palette.white.withValues(alpha:0.018),
              borderRadius:BorderRadius.circular(17),
              border:Border.all(color:selected?accent.withValues(alpha:0.27):palette.white.withValues(alpha:0.045)),
              boxShadow:selected?[BoxShadow(color:accent.withValues(alpha:0.08),blurRadius:16)]:null,
            ),
            child:Row(children:[
              _buildFlag(country,palette,accent,selected),
              const SizedBox(width:13),
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children:[
                Text(country.name,maxLines:1,overflow:TextOverflow.ellipsis,style:TextStyle(color:palette.textPrimary,fontSize:14,fontWeight:selected?FontWeight.w800:FontWeight.w700)),
                const SizedBox(height:4),
                Row(children:[
                  Container(padding:const EdgeInsets.symmetric(horizontal:6,vertical:3),decoration:BoxDecoration(color:selected?accent.withValues(alpha:0.12):palette.white.withValues(alpha:0.055),borderRadius:BorderRadius.circular(6)),child:Text(country.isoCode.toUpperCase(),style:TextStyle(color:selected?accent:palette.textSecondary,fontSize:9.5,fontWeight:FontWeight.w800,letterSpacing:0.5))),
                  const SizedBox(width:6),
                  Flexible(child:Text('Numéro national',maxLines:1,overflow:TextOverflow.ellipsis,style:TextStyle(color:palette.textTertiary,fontSize:10.5))),
                ]),
              ])),
              const SizedBox(width:10),
              Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:6),decoration:BoxDecoration(color:selected?accent.withValues(alpha:0.10):palette.white.withValues(alpha:0.045),borderRadius:BorderRadius.circular(9),border:Border.all(color:selected?accent.withValues(alpha:0.16):palette.white.withValues(alpha:0.055))),child:Text(country.dialCode,style:TextStyle(color:selected?accent:palette.textSecondary,fontSize:11,fontWeight:FontWeight.w800))),
              if(selected)...[const SizedBox(width:10),Container(width:27,height:27,decoration:BoxDecoration(color:accent.withValues(alpha:0.16),shape:BoxShape.circle,border:Border.all(color:accent.withValues(alpha:0.25))),child:Icon(Icons.check_rounded,color:accent,size:17))],
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildFlag(PhoneCountry country,GlassColorPalette palette,Color accent,bool selected){
    final asset=country.effectiveFlagAsset;
    return Container(
      width:48,height:48,
      decoration:BoxDecoration(
        gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[palette.white.withValues(alpha:selected?0.10:0.065),palette.white.withValues(alpha:selected?0.045:0.025)]),
        borderRadius:BorderRadius.circular(14),
        border:Border.all(color:selected?accent.withValues(alpha:0.20):palette.white.withValues(alpha:0.07)),
        boxShadow:selected?[BoxShadow(color:accent.withValues(alpha:0.07),blurRadius:12)]:null,
      ),
      alignment:Alignment.center,
      // ignore: unnecessary_null_comparison, unnecessary_underscores
      child:asset!=null&&asset.trim().isNotEmpty?ClipRRect(borderRadius:BorderRadius.circular(6),child:Image.asset(asset,package:'universal_glass',width:30,height:21,fit:BoxFit.cover,cacheWidth:72,errorBuilder:(_,__,___)=>Text(country.flag,style:const TextStyle(fontSize:22)))):Text(country.flag,style:const TextStyle(fontSize:22)),
    );
  }
}