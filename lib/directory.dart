import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tree_view/tree_view.dart';
import 'package:line_icons/line_icons.dart';

class DirectoryView extends StatefulWidget {
  @override
  DirectoryViewState createState() => DirectoryViewState();
}

class DirectoryViewState extends State<DirectoryView> {
  List<Document> documentList = [
    Document(
      name: 'Desktop',
      dateModified: DateTime.now(),
      isFile: false,
      childData: [
        Document(name: 'Projects', dateModified: DateTime.now(), childData: [
          Document(
              name: 'flutter_app',
              dateModified: DateTime.now(),
              childData: [
                Document(
                  name: 'README.md',
                  dateModified: DateTime.now(),
                  isFile: true,
                ),
              ])
        ]),
        Document(
          name: 'test.sh',
          dateModified: DateTime.now(),
          isFile: true,
        ),
        Document(
          name: 'image.png',
          dateModified: DateTime.now(),
          isFile: true,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Parent> parentList = [];

    documentList.forEach((document) {
      Parent parent = _getParent(document: document);
      parentList.add(parent);
    });

    return TreeView(parentList: parentList);
  }

  ChildList _getChildList({@required Document document}) {
    List<Widget> widgetList = [];

    List<Document> childDocuments = document.childData;
    childDocuments.forEach((childDocument) {
      widgetList.add(Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _getParent(document: childDocument),
      ));
    });

    return ChildList(children: widgetList);
  }

  Parent _getParent({@required Document document}) {
    ChildList childList =
        document.isFile ? null : _getChildList(document: document);

    return Parent(
      parent: _getDocumentWidget(document: document),
      childList: childList,
    );
  }

  Widget _getDocumentWidget({@required Document document}) => document.isFile
      ? _getFileWidget(document: document)
      : _getDirectoryWidget(document: document);

  DirectoryWidget _getDirectoryWidget({@required Document document}) =>
      DirectoryWidget(
        directoryName: document.name,
        lastModified: document.dateModified,
      );

  FileWidget _getFileWidget({@required Document document}) => FileWidget(
        fileName: document.name,
        lastModified: document.dateModified,
      );
}

class FileWidget extends StatelessWidget {
  final String fileName;
  final DateTime lastModified;

  FileWidget({@required this.fileName, @required this.lastModified});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("TEST");
      },
      child: Card(
        elevation: 0.0,
        child: ListTile(
          leading: Icon(Icons.insert_drive_file),
          title: Text(this.fileName),
          subtitle: Text(
            Utils.getFormattedDateTime(dateTime: lastModified),
          ),
        ),
      ),
    );
  }
}

class DirectoryWidget extends StatelessWidget {
  final String directoryName;
  final DateTime lastModified;
  final VoidCallback onPressedNext;

  DirectoryWidget({
    @required this.directoryName,
    @required this.lastModified,
    this.onPressedNext,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.folder),
        title: Text(directoryName),
        subtitle: Text(
          Utils.getFormattedDateTime(dateTime: lastModified),
        ),
        trailing: IconButton(
          // icon: Icon(Icons.navigate_next),
          icon: Icon(LineIcons.folder_open),
          onPressed: () {
            onPressedNext();

          },
        ),
      ),
    );
  }
}

class Utils {
  static String getFormattedDateTime({@required DateTime dateTime}) {
    String day = '${dateTime.day}';
    String month = '${dateTime.month}';
    String year = '${dateTime.year}';

    String hour = '${dateTime.hour}';
    String minute = '${dateTime.minute}';
    String second = '${dateTime.second}';
    return '$day/$month/$year $hour/$minute/$second';
  }
}

class Document {
  final String name;
  final bool isFile;
  final DateTime dateModified;
  final List<Document> childData;

  Document({
    @required this.name,
    @required this.dateModified,
    this.isFile = false,
    this.childData = const <Document>[],
  });
}
