import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motogp_calendar/components/accordion.dart';

class AccordionList extends StatefulWidget{
  final List<Accordion> items;
  const AccordionList({super.key, required this.items});

  @override
  AccordionListState createState() => AccordionListState();
}

class AccordionListState extends State<AccordionList> with TickerProviderStateMixin {
  List<String> openedAccordion = [];
  
  ///Contiene i controller per le animations. Ogniuno corrisponde ad un signolo accordion.
  List<AnimationController> iconsAnimationControllers = [];


  @override
  void initState() {
    super.initState();

    for (var i = 0; i<widget.items.length; i++) {
      iconsAnimationControllers.add(AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var e in iconsAnimationControllers) {
      e.dispose();
    }
  }


  toggleAccordion(Accordion accordion){
    List<String> tmpOpenedAccordion = openedAccordion;
    if(isAccordionOpened(accordion.title)){
      tmpOpenedAccordion.remove(accordion.title);
      iconsAnimationControllers[widget.items.indexOf(accordion)].reverse();
    }else{
      tmpOpenedAccordion.add(accordion.title);    
      iconsAnimationControllers[widget.items.indexOf(accordion)].forward();
    }
    setState(() => openedAccordion = tmpOpenedAccordion);
  }

  bool isAccordionOpened(String name) => openedAccordion.indexWhere((e) => e == name) != -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((e) => Column(
        children: [
          //HEADER
          GestureDetector(
            onTap: () => toggleAccordion(e),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.title, style: GoogleFonts.roboto(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16) ),),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(iconsAnimationControllers[widget.items.indexOf(e)]),
                    child: Icon(Icons.keyboard_arrow_up),
                  )
                ],
              ), 
            ) 
          ),
          
          //BODY
          AnimatedSize(
            duration: Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            child: isAccordionOpened(e.title) ?  
              Container(
                padding: EdgeInsets.only(bottom: 16),
                child: e.child,
              ) :
              SizedBox(width: double.infinity,),
          ),

          //SEPARATOR (if it's not the last item)
          Visibility(
            visible: widget.items.last != e,
            child: Divider(
              height: 1,
              color: Color.fromRGBO(240, 240, 240, 1),
            ) 
          )
          
        ],
      )).toList() 
    );
  }

}