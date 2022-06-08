import 'package:flutter/material.dart';

class OtpItem extends StatefulWidget {
  const OtpItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OtpItemState();
}

class _OtpItemState extends State<OtpItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Row(children: [
          Expanded(
            child: const Padding(
                padding: const EdgeInsets.all(0),
                child: ListTile(
                  title: Text('Issuer'),
                  subtitle: Text('Label'),
                )),
          ),
          new Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('696 420',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500))),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
