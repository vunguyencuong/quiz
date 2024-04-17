import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';



class Participant {
  final String name;
  final int score;

  Participant(this.name, this.score);
}

@RoutePage()
class CompletedScreen extends StatelessWidget {
  CompletedScreen({super.key});
  List<Participant> participants = [
    Participant('Alice', 95),
    Participant('Bob', 85),
    Participant('Charlie', 80),
    Participant('David', 75),
    Participant('Emma', 70),
    Participant('Frank', 65),
    Participant('Grace', 60),
    Participant('Hannah', 55),
    Participant('Ian', 50),
    Participant('Julia', 45),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 521,
            width: 400,
            child: Stack(
              children: [
                Container(
                  height: 340,
                  width: 410,
                  decoration: BoxDecoration(
                      color: Color(0xff90CAF9),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.white.withOpacity(.3),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: Colors.white.withOpacity(.4),
                        child:  Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Your Score', style: TextStyle(
                                  fontSize: 20, color: Color(0xff90CAF9)
                              ),),
                              RichText(
                                  text: TextSpan(
                                      text: '100', style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xff90CAF9)
                                  ),
                                      children: [
                                        TextSpan(
                                          text: 'pt', style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.bold,color: Color(0xff90CAF9)
                                        ),
                                        )
                                      ]
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 22,
                  child: Container(
                    height: 190,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 3,
                              color: Color(0xff90CAF9).withOpacity(.7),
                              offset: Offset(0,1)
                          )
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff90CAF9)
                                            ),
                                          ),
                                          Text('100%', style: TextStyle(
                                              fontWeight: FontWeight.w500,fontSize: 20,
                                              color: Color(0xff90CAF9)
                                          ),)
                                        ],
                                      ),
                                    ),
                                    const Text('Completion')

                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff90CAF9)
                                            ),
                                          ),
                                          Text('10', style: TextStyle(
                                              fontWeight: FontWeight.w500,fontSize: 20,
                                              color: Color(0xff90CAF9)
                                          ),)
                                        ],
                                      ),
                                    ),
                                    const Text('Total Question')
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green
                                            ),
                                          ),
                                          Text(' 07', style: TextStyle(
                                              fontWeight: FontWeight.w500,fontSize: 20,
                                              color: Colors.green
                                          ),)
                                        ],
                                      ),
                                    ),
                                    const Text('Correct')
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 48.8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 15,
                                              width: 15,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red
                                              ),
                                            ),
                                            Text(' 03', style: TextStyle(
                                                fontWeight: FontWeight.w500,fontSize: 20,
                                                color: Colors.red
                                            ),)
                                          ],
                                        ),
                                      ),
                                      const Text('Wrong')
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index];
                return ListTile(
                  leading: Text('${index + 1}.'),
                  title: Text(participant.name),
                  trailing: Text('${participant.score} pts'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


