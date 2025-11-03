


# Flutter Treeview Plus 🎯

[![Pub Version](https://img.shields.io/pub/v/treeview_plus.svg)](https://pub.dev/packages/treeview_plus)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# 🌳 treeview_plus

A customizable Flutter widget for displaying **hierarchical data** in an expandable and interactive tree view.  
Supports custom node widgets, selection, expand/collapse animations, and flexible indicator styles.

---

## Features ✨

## 🚀 Features

- ✅ Generic type support – use any data model  
- ✅ Expand and collapse nodes  
- ✅ Customizable node widgets (`nodeBuilder`)  
- ✅ Plus/Minus or Arrow indicators  
- ✅ Connector lines between parent and child  
- ✅ Scrollable horizontally and vertically  

---



## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  treeview_plus: ^0.0.1

```

Then run:

```bash
flutter pub get
```

## Usage 💻

1. Import the package:
```dart
import 'package:treeview_plus/treeview_plus.dart';
```


### Basic Example

```dart

import 'package:flutter/material.dart';
import 'package:treeview_plus/treeview_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyNode {
  final String id;
  final String label;
  final List<MyNode> children;

  MyNode({
    required this.id,
    required this.label,
    this.children = const [],
  });
}

```



```dart

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final treeData = MyNode(
      id: 'root',
      label: 'Root Node',
      children: [
        MyNode(id: '1', label: 'Child 1'),
        MyNode(
          id: '2',
          label: 'Child 2',
          children: [
            MyNode(id: '2.1', label: 'Subchild 1'),
            MyNode(id: '2.2', label: 'Subchild 2'),
          ],
        ),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('TreeView Plus Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomTreeView<MyNode>(
            root: treeData,
            nodeBuilder: (context, node, isSelected) => Text(
              node.label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: (id) => debugPrint('Tapped node: $id'),
            indicatorType: NodeIndicatorType.arrow,
          ),
        ),
      ),
    );
  }
}

```

## ⚙️ Node Model Requirements

Each node should include:

A unique id property

Either a child or children property (list of subnodes)

class MyNode {
  final String id;
  final String label;
  final MyNode? child;
  final List<MyNode>? children;

  MyNode({required this.id, required this.label, this.child, this.children});
}
🎨 Indicator Types
| Type                          | Description                       |
| ----------------------------- | --------------------------------- |
| `NodeIndicatorType.plusMinus` | Shows + / - for expand & collapse |
| `NodeIndicatorType.arrow`     | Rotating arrow indicator          |


📸 Preview (Optional)
You can add a preview image or GIF here once ready:
![treeview_plus preview](example/preview.gif)


🧠 Notes


Root node expands automatically by default.


Handles dynamic child updates gracefully.


Designed for both data visualization and UI trees.

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support ❤️

If you find this package helpful, please give it a ⭐️ on [GitHub](https://github.com/rupkumar-dev/treeview-plus)!




## 📚 Documentation

For detailed documentation and examples, visit our [LivePreview](https://rupkumar-dev.github.io/treeview-plus/).

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Rupkumar Sarkar** - *Initial work* - [GithubProfile](https://github.com/rupkumar-dev)

## 🙏 Acknowledgments

- Thanks to all contributors who have helped make this package better
- Special thanks to the Flutter community

## 📧 Contact

If you have any questions, feel free to reach out:

- Email: rupkumarcomputer@gmail.com
- Instagram: [@rupkumar.dev](https://www.instagram.com/rupkumar.dev/)

---
💬 Author
Rupkumar

Made with ❤️ by Rupkumar Sarkar