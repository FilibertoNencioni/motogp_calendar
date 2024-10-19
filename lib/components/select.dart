import 'package:flutter/material.dart';
import 'package:motogp_calendar/components/app_card.dart';

class Select<T> extends StatefulWidget{
  /// Select label
  final String label;

  /// Selected value, must be in [items].
  /// Needs to be valorized
  final T value;

  /// List of items (select options)
  final List<T> items;

  /// Method used to display the selected item and the [items] list
  final String Function(T) displayItem;

  /// Callback when an item is selected
  final Function(T)? onChanged;

  /// Style of the item not selected
  final TextStyle? itemNotSelectedStyle;

  /// Style of the item selected (in the list and not)
  final TextStyle? itemSelectedStyle;
  
  const Select({super.key, required this.label, required this.value, required this.items, this.onChanged, required this.displayItem, this.itemNotSelectedStyle, this.itemSelectedStyle});
  
  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> with TickerProviderStateMixin{
  bool isExpanded = false;
  late AnimationController arrowAnimationController;

  @override
  void initState(){
    super.initState();
    arrowAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
  }
  @override
  Widget build(BuildContext context){
    return AppCard(
      onTap: toggleSelect,
      padding: EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex:1,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //LABEL
                Text(widget.label, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 12,),

                //SELECTED ITEM (always first and visible)
                Text(widget.displayItem(widget.value), style: widget.itemSelectedStyle ?? Theme.of(context).textTheme.bodyLarge),

                //OPTIONS
                AnimatedSize(
                  duration: Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: isExpanded ?
                    Column(
                      children: widget.items
                                  .where((e)=>e != widget.value)
                                  .map((e) => TextButton(
                                      style: Theme.of(context).textButtonTheme.style?.copyWith(padding: WidgetStateProperty.all(EdgeInsets.zero)),
                                      child: Text(widget.displayItem(e), style: widget.itemNotSelectedStyle ?? Theme.of(context).textTheme.bodyLarge),
                                      onPressed: () => handleItemSelect(e),
                                    )
                                  )
                                  .toList(),
                    )
                    :
                    SizedBox(width: double.infinity,)
                    
                )
              ],
            ),
          ),
          RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(arrowAnimationController),
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 32),
          )
        ]
      )
    );
  }

  void toggleSelect(){
    isExpanded? arrowAnimationController.reverse() : arrowAnimationController.forward();
    setState(()=>isExpanded = !isExpanded);
  }

  void handleItemSelect(T item){
    widget.onChanged?.call(item);
    toggleSelect();
  }  

    

}