// ... ListView.builder 内 ...
child: Row
(
children: [
// 完了状態を示すアイコン
Icon(
// ...
color: item.isDone
? CupertinoColors.systemBlue // ★完了時は青
    : CupertinoColors.systemGrey, // ★未完了時はグレー
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
? CupertinoColors.systemGrey // ★完了時はグレー（薄くする）
    : CupertinoColors.black, // ★未完了時は黒（はっきり表示）
// ...
),
),
),
]
,
)
,