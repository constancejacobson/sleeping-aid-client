import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> postCustomization(String age, String weight) async {
  var params = {'age': age, 'weight': weight};
  var uri = Uri.https('sleeping-aid-295720.web.app', '/customization', params);

  final http.Response response = await http.put(uri);

  if (response.statusCode == 200) {
    return 'Customization updated';
  }
  return 'Customization failed';
}

class Customization extends StatefulWidget {
  @override
  _CustomizationState createState() => _CustomizationState();
}

class _CustomizationState extends State<Customization> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  Future<String> _futureCustomization;

  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void onSave() {
    setState(() => {
          _futureCustomization =
              postCustomization(_ageController.text, _weightController.text)
        });
  }

  @override
  Widget build(BuildContext context) {
    return (_futureCustomization == null)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                      labelText: 'Enter baby\'s age in months')),
              SizedBox(height: 20),
              TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                      labelText: 'Enter baby\'s weight in pounds')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () => {onSave()}, child: Text('Save'))
            ],
          )
        : DefaultTextStyle(
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
            child: FutureBuilder<String>(
              future: _futureCustomization,
              builder: (context, snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 60),
                    Text(snapshot.data),
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    Icon(Icons.error_outline, color: Colors.red, size: 60),
                    Text('Error:  ${snapshot.error}'),
                  ];
                } else {
                  children = <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                  ];
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ));
  }
}
