# lily_sudoku_app

Lily Sudoku

## main branch

通常の開発ブランチ。

```
$ flutter --version
Flutter 2.10.0-0.3.pre • channel beta • https://github.com/flutter/flutter.git
Framework • revision fdd0af78bb (13 days ago) • 2022-01-25 22:01:33 -0600
Engine • revision 5ac30ef0c7
Tools • Dart 2.16.0 (build 2.16.0-134.5.beta) • DevTools 2.9.2

$ flutter create --platforms web --description "Lily Sudoku" .
$ flutter run --debug
$ flutter build web
```

## gh-pages branch

Github Pagesで公開するブランチ。

https://botamotch.github.io/Lily-Sudoku/#/

mainブランチの`./build/web`ディレクトリをコピーしてデプロイ。
Github Actionsで自動化予定。
workflowはこんな感じ。

```
name: github pages

on:
  push:
    branches:
      - master

jobs:
  build-deploy:
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@master

    - name: Setup Flutter
      uses: subosito/flutter-action@v1
      with:
        channel: 'beta'

    - name: Install
      run: |
        flutter config --enable-web
        flutter pub get

    - name: Build
      run: flutter build web

    - name: Deploy
      uses: peaceiris/actions-gh-pages@v2.8.0
      env:
        ACTIONS_DEPLOY_KEY: ${{ secrets.ACTIONS_DEPLOY_KEY }}
        PUBLISH_BRANCH: gh-pages
        PUBLISH_DIR: ./build/web
```

## Lily Sudoku本体

数独アプリのプロトタイプ。

ゲーム起動時に数字が入力できなくなる不具合発見。
CLEARを入力すればなおるからcheckAnswer関数がなんかやらかしてるっぽい。そのうち修正。

ゲームの初期化の途中。
前半の数字１〜４は、各マスにランダムに入れて行・列・四角をチェックしていく方式。
後半は探索していく（未実装）。

```
Invalid argument: Maximam call stack size exceeded
See also: https://flutter.dev/docs/testing/errors
```

### class
- GameAreaWidget
  - ゲーム領域全体を制御するエリア
- FrameWidget
  - 数字、ボタンを設置するエリア。ここだけStatefulWidget
- PanelWidget
  - 数字、ボタンの中身を設定するパネル
- リセット、ヒント等の他のボタンも必要

### variable
- [x] List<int> inputNumber
  - 入力されている数字。ゲーム中にボタンを押すことで変わる
- [x] List<int> correctNumber
  - 正解の数字。ゲーム開始時resetGameによって変わる
- [x] List<int> status
  - 0 : 入力可能、未選択／1 : 入力可能、選択中／2,3 : 入力不可／その他 : Button
- [x] List<PanelWidget> panelList
  - 9x9のマスに入るPanel。PanelWidgetのList

### setState
- [ ] setNumber
  - 選択中のパネルに数字を入れる
- [x] selectPanel
  - パネルを選択する
- [ ] resetGame
  - ゲームを初期化する
- [ ] checkAnswer
  - 入力された数字の正解をチェックする
- [x] @override initState
  - resetGameを実行する
- [x] @override build
  - inputPanelの値をpanelListに入力してサイズを決定する

``` lib/panel.dart
class GameAreaWidget extends StatelessWidget

class FrameWidget extends StatefulWidget
 │
 │─ List<int> inputNumber = [];
 │─ List<int> correctNumber = [];
 │─ List<int> status = [];
 │─ List<PanelWidget> panelList = [];
 │
 │─ void setNumber(var num) { setState(() { ... }); }
 │─ void checkAnswer() {setState(() { ... });}
 │─ void selectPanel(var j) {setState(() { ... });}
 │─ void resetGame() {setState(() { ... });}
 │
 │─ @override void initState() { resetGame() }
 └─ @override Widget build() { return Stack(...) }

class PanelWidget extends StatelessWidget
 │─ final int inputNumber;
 │─ final int correctNumber;
 └─ final int status;
```

![sudoku_mockup](https://github.com/botamotch/Lily-Sudoku/tree/main/doc/sudoku_mockup.png "数独アプリモックアップ")

