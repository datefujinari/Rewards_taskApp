import 'package:flutter/cupertino.dart'; // iOSスタイルのウィジェットを使用するためのパッケージ
import 'package:flutter/material.dart'; // 一部の基本機能（ColorsやIconsなど）で使用

void main() {
  // アプリケーションのエントリーポイント（開始地点）
  runApp(const TodoApp());
}

/// アプリケーション全体のルートとなるウィジェット
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // iOSスタイルのデザインテーマを提供するCupertinoAppを使用します
    return const CupertinoApp(
      title: 'Cupertino ToDo',
      theme: CupertinoThemeData(
        // アプリ全体の基本色（プライマリカラー）を青に設定
        primaryColor: CupertinoColors.systemBlue,
      ),
      // アプリ起動時に最初に表示される画面
      home: TodoListPage(),
    );
  }
}

/// ToDoアイテムのデータを管理するクラス
/// 単純なデータ構造なので、クラスとして定義しておくと扱いやすくなります
class TodoItem {
  String title; // タスクの内容
  bool isDone; // 完了しているかどうか

  TodoItem({required this.title, this.isDone = false});
}

/// ToDoリストを表示する画面（状態を持つウィジェット）
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

/// 画面の状態（State）を管理するクラス
/// ここにToDoリストのデータや、画面更新のロジックを記述します
class _TodoListPageState extends State<TodoListPage> {
  // ToDoアイテムを格納するリスト
  final List<TodoItem> _todoList = [];

  // テキスト入力のコントローラー（ダイアログでの入力値を取得するために使用）
  final TextEditingController _textController = TextEditingController();

  /// 新しいタスクを追加するメソッド
  void _addTodoItem(String title) {
    if (title.isNotEmpty) {
      setState(() {
        // リストに新しいアイテムを追加し、画面を再描画します
        _todoList.add(TodoItem(title: title));
      });
      _textController.clear(); // 入力欄をクリア
    }
  }

  /// タスクの完了状態を切り替えるメソッド
  void _toggleTodoItem(int index) {
    setState(() {
      // 指定されたインデックスのアイテムの完了状態を反転させます
      _todoList[index].isDone = !_todoList[index].isDone;
    });
  }

  /// タスクを削除するメソッド
  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  /// タスク追加用のダイアログを表示するメソッド
  void _showAddDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('新規タスク'),
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CupertinoTextField(
              controller: _textController,
              placeholder: 'タスクを入力してください',
              autofocus: true, // ダイアログが開いたらすぐにキーボードを表示
            ),
          ),
          actions: [
            // キャンセルボタン
            CupertinoDialogAction(
              isDestructiveAction: true, // 赤色で表示（破棄アクション）
              onPressed: () {
                _textController.clear();
                Navigator.pop(context); // ダイアログを閉じる
              },
              child: const Text('キャンセル'),
            ),
            // 追加ボタン
            CupertinoDialogAction(
              isDefaultAction: true, // 太字で表示（推奨アクション）
              onPressed: () {
                _addTodoItem(_textController.text);
                Navigator.pop(context); // ダイアログを閉じる
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // iOSスタイルの基本的な画面レイアウト
    return CupertinoPageScaffold(
      // ナビゲーションバー（画面上部のヘッダー）
      navigationBar: CupertinoNavigationBar(
        middle: const Text('ToDoリスト'),
        // 右上に「＋」ボタンを配置
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showAddDialog,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      // 画面のメインコンテンツ
      child: SafeArea(
        // ListView.builderを使うと、リストの要素数に応じて効率的に描画できます
        child: _todoList.isEmpty
            ? const Center(
          child: Text(
            'タスクがありません。\n右上の＋ボタンから追加してください。',
            textAlign: TextAlign.center,
            style: TextStyle(color: CupertinoColors.systemGrey),
          ),
        )
            : ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            final item = _todoList[index];

            // スワイプして削除する機能（Dismissible）
            return Dismissible(
              // 各アイテムを一意に識別するためのキー
              key: Key(item.title + index.toString()),
              // スワイプした時の背景色（赤色）
              background: Container(
                color: CupertinoColors.systemRed,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(
                  CupertinoIcons.delete,
                  color: CupertinoColors.white,
                ),
              ),
              // スワイプ方向（右から左のみ許可）
              direction: DismissDirection.endToStart,
              // スワイプ完了時の処理
              onDismissed: (direction) {
                _removeTodoItem(index);
              },
              // リストの各行のデザイン
              child: GestureDetector(
                onTap: () => _toggleTodoItem(index),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.systemGrey5,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 完了状態を示すアイコン
                      Icon(
                        item.isDone
                            ? CupertinoIcons.check_mark_circled_solid
                            : CupertinoIcons.circle,
                        color: item.isDone
                            ? CupertinoColors.systemBlue
                            : CupertinoColors.systemGrey,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      // タスクのテキスト
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: item.isDone
                                ? CupertinoColors.systemGrey
                                : CupertinoColors.black,
                            decoration: item.isDone
                                ? TextDecoration.lineThrough // 完了時は取り消し線
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}