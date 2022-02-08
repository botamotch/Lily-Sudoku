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

