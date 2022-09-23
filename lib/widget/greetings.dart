import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do_list/screen/app_settings.dart';
import 'package:to_do_list/utils/authentication.dart';

const textGreetings = 'Hi,';

class Greetings extends StatelessWidget {
  const Greetings(this.name, {Key? key}) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          alignment: FractionalOffset.bottomCenter,
          child: Row(
            children: [
              Container(
                height: constraints.maxHeight * 0.7,
                width: constraints.maxWidth * 0.8,
                alignment: Alignment.centerLeft,
                child: Text(
                  '$textGreetings $name',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 40),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                height: constraints.maxHeight * 0.7,
                width: constraints.maxWidth * 0.1,
                alignment: Alignment.centerLeft,
                child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.gear,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppSettings(),
                          ));
                    }),
              ),
              Container(
                height: constraints.maxHeight * 0.7,
                width: constraints.maxWidth * 0.1,
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Authentication.confirmationDialog(
                      context: context,
                      confirmationText: 'Do you want to log out?',
                    ).then(
                      (confirmed) {
                        if (confirmed) {
                          Authentication.signOut(context: context);
                        }
                      },
                    );
                  },
                  icon: const Icon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
