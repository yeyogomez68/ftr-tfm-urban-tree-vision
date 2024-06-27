import 'dart:math';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snackbar;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ftrlibcuestionario/pages/splash/splash.home.dart' as splash;
import 'package:ftrlibcuestionario/pages/sync/sync.home.dart' as sync;
import 'package:ftrlibcuestionario/widgets/inputs/input.digits.dart' as digits;
import 'package:ftrlibcuestionario/widgets/inputs/input.text.dart' as inputs;
import 'package:ftrlibcuestionario/globals/globals.dart';
import 'package:ftrlibcuestionario/widgets/toggles/togle.buttons.dart'
    as toggles;
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:ftrlibcuestionario/pages/login/login.home.dart' as login;
import 'package:ftrlibcuestionario/pages/perfil/perfil.home.dart' as perfil;
import 'package:ftrlibcuestionario/pages/survey/cuestionario/cuestionario.home.dart'
    as cuestionario;
import 'package:ftrlibcuestionario/pages/log/log.home.dart' as log;

class Home extends StatelessWidget {
  Home({
    super.key,
  });

  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    try {
      return Consumer(
        builder: (context, ref, _) {
          login.loginProvider = ref.watch(login.notifierLoginProvider);
          if (login.loginProvider.tbLogin.idUsuario > 0) {
            return dashBoard(context);
          } else {
            return login.Home(
              lottieFile: Globals.lottieFile,
              logoEmpresa: "assets/Logo_UNIR.png",
              fondoImagen: "assets/icono.png",
              secondsSplash: 6,
              title: Globals.titleApp,
            );
          }
        },
      );
    } catch (ex) {
      return Text(ex.toString());
    }
  }

  dashBoard(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SliderDrawer(
            //isCupertino: true,
            appBar: SliderAppBar(
                drawerIconColor: Colors.white,
                appBarHeight: 70,
                appBarColor: Theme.of(context).splashColor,
                trailing: Image.asset("assets/icono.png", width: 40),
                title: Text(Globals.titleApp,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700))),
            key: _sliderDrawerKey,
            sliderOpenSize: 220,
            slider: drawer(
              onItemClick: (title) {
                if (title == 'Perfil') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => perfil.Home()));
                }
                if (title == 'Sincronizar') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => sync.Home()));
                }
                if (title == 'Logs') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => log.Home()));
                }
                if (title == 'Salir') {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.bottomSlide,
                    title: 'Salir',
                    desc: '¿Está seguro de cerrar la sesión?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      login.loginProvider.logout().whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => login.Home(
                                    lottieFile: Globals.lottieFile,
                                    secondsSplash: 4,
                                    logoEmpresa: "assets/Logo_UNIR.png",     
                                    fondoImagen: "assets/icono.png",                               
                                    title: Globals.titleApp)));
                      });
                    },
                  ).show();
                }
              },
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color:Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    cuestionario.Home(
                      title: "Formularios / Cuestionarios",
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class drawer extends StatelessWidget {
  final Function(String)? onItemClick;

  const drawer({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).splashColor,
      padding: const EdgeInsets.only(top: 30),
      child: Consumer(
        builder: (context, ref, _) {
          login.loginProvider = ref.watch(login.notifierLoginProvider);
          return ListView(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: Image.asset("assets/icono.png").image,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                login.loginProvider.nombreUsuarioDestino,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ...[
                Menu(Icons.person, 'Perfil'),
                Menu(Icons.sync, 'Sincronizar'),
                Menu(Icons.settings, 'Configuración'),
                Menu(Icons.bug_report, 'Logs'),
                Menu(Icons.arrow_back_ios, 'Salir')
              ]
                  .map((menu) => _SliderMenuItem(
                      title: menu.title,
                      iconData: menu.iconData,
                      onTap: onItemClick))
                  .toList(),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Container(
                color: Colors.transparent,
                child: toggles.Home(colorIcons: Colors.white),
              )),
              SizedBox(
                height: 20,
              ),
              Text(Globals.empresaNombre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(192, 0, 0, 0),
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  color: Colors.white,
                  child: Center(
                      child:
                          Image.asset("assets/Logo_UNIR.png", height: 90)))
            ],
          );
        },
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title,
            style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'BalsamiqSans_Regular')),
        leading: Icon(iconData, color: Theme.of(context).primaryColor),
        minLeadingWidth: 20,
        onTap: () => onTap?.call(title));
  }
}

class Quotes {
  final MaterialColor color;
  final String author;
  final String quote;

  Quotes(this.color, this.author, this.quote);
}

class Menu {
  final IconData iconData;
  final String title;
  Menu(this.iconData, this.title);
}

final notifierLoginProvider = ChangeNotifierProvider((ref) => HomeProvider());

late HomeProvider homeProvider;

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    homeProvider = this;
  }
}
