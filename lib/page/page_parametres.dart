import 'package:flutter/material.dart';

class PageParametres extends StatelessWidget {

  const PageParametres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined),
        onPressed:() {
          /*Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const FullScreenDialogCreationFacture(),
              fullscreenDialog: true,
            ),
          );*/
        },
      ),
      body: const ParametresGlobaux(),
    );
  }

}

class ParametresGlobaux extends StatefulWidget {
  const ParametresGlobaux({Key? key}) : super(key: key);

  @override
  State<ParametresGlobaux> createState() => _ParametresGlobauxState();
}

class _ParametresGlobauxState extends State<ParametresGlobaux> {
  final _myList = [
    // Your list data here
    "Mes coordoonées", "Thêmes"
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:

          Column(

            children: [
              const Padding(
                padding: EdgeInsets.only( top: 70, right: 20,),
                child:
                  Text(
                    " Mes Paramètres",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),


              const Divider(),

              Expanded(child:
                ListView.separated(
                  itemCount: _myList.length,
                  itemBuilder: (context, index) {
                    return Container( padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: index == 0 ? const Border() : Border(top: BorderSide(width: 1, color: Theme.of(context).primaryColor)),
                      ),
                      child: Text(_myList[index], style: const TextStyle(fontSize: 18),),
                    );
                  }, separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),

            ],
          ),
    );
  }
}
