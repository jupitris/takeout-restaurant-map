# 台東区周辺のテイクアウト可能なお店マップ

[![台東区周辺のテイクアウト可能なお店マップ](https://user-images.githubusercontent.com/6129513/79033298-1c8f3d80-7be8-11ea-953d-53bb86c5010a.png)](https://takeoutmap-6fe47.web.app/)

台東区周辺のテイクアウト可能な飲食店を独自に調査したマップです。

## お店の管理方法
[スプレッドシート](https://docs.google.com/spreadsheets/d/17wEI2oBZ94odAKiXm7eeoWpkhA5jdVaZogVxhRYXxaU/edit#gid=0)にてお店の一覧管理をしています。   

こちらの「テイクアウト可能」という項目にチェックが入っているお店のみマップに反映されます。是非とも追加をお願いします。

## お店の追加方法
[スプレッドシート](https://docs.google.com/spreadsheets/d/17wEI2oBZ94odAKiXm7eeoWpkhA5jdVaZogVxhRYXxaU/edit#gid=0)に以下の項目の追加をお願いします。

| 項目名 | 必須/任意 | 備考 |
| ---- | ---- | ---- |
| **店舗名** | 必須 |  |
| **住所** | 必須 | 郵便番号ありなしどちらでも大丈夫です  |
| **テイクアウト可能** | 必須 | テイクアウト可能なお店の場合はチェックをお願いします |
| 電話番号 | 任意 | 自動でマップに反映されます、番号間違いにご注意ください |
| 緯度 | 自動入力 | 住所から自動で計算され反映されます、手動で入れないようお願いします | 
| 経度 | 自動入力 | 住所から自動で計算され反映されます、手動で入れないようお願いします | 
| ウェブサイト | 任意 | 自動でマップに反映されます、出来るだけご入力ください | 



   


## 注意事項
[スプレッドシート](https://docs.google.com/spreadsheets/d/17wEI2oBZ94odAKiXm7eeoWpkhA5jdVaZogVxhRYXxaU/edit#gid=0)に入力していただいた情報は即時反映されます。
緯度経度が自動で反映されない場合は住所の入れ方を変更してください。(全角スペースが入っている、改行があるなどで自動取得出来ない場合があります)


## テイクアウト出来るお店のチラシなどに使えるデザインも公開しています
[![テイクアウトデザイン](https://user-images.githubusercontent.com/6129513/79034692-29fdf500-7bf3-11ea-9a28-07183514f4f6.png)](https://takeoutmap-6fe47.web.app/Takeaway.pdf)


## 台東区以外でも作りたい方向け
コードを公開しました。
是非とも他の地域でもご活用ください。

またコードに対するPullRequestもお待ちしております。

### ディレクトリ構成
ディレクトリ構成です。  
`app` はFirebaseプロジェクトになります。動かすのに必要なhostingとfunctionsが含まれています。  
(※ `.firebaserc` と `.runtimeconfig.json` はリポジトリに含まれていません)  

    .
    ├── app
    │   ├── firebase.json
    │   ├── .firebaserc
    │   ├── functions
    │   │   ├── .gitignore
    │   │   ├── index.js
    │   │   ├── node_modules
    │   │   ├── package.json
    │   │   ├── package-lock.json
    │   │   ├── .runtimeconfig.json
    │   │   └── views
    │   ├── .gitignore
    │   └── hosting
    │       ├── 404.html
    │       ├── favicon.ico
    │       └── Takeaway.pdf
    ├── .gitignore
    ├── LICENSE
    ├── logo
    │   └── Takeaway.pdf
    └── README.md

### 事前準備

FirebaseのHostingプロジェクトを作成しておきましょう。

またプロジェクトで使用するAPIキーを用意しておきます。
必要なAPIは以下の通りです。

- Maps JavaScript API
- Geocoding API
- Google Sheets API

Maps JavaScript API のAPIキーはプロジェクトの性質上、HTMLに表示されてしまうため、特定のリファラー以外は利用できないように制限しておきましょう。

### Cloneしてからデプロイするまで

1. プロジェクトをcloneする  

    ```
    git clone git@github.com:jupitris/takeout-restaurant-map.git
    ```

1. プロジェクトディレクトリに移動する  

    ```
    cd takeout-restaurant-map
    ```

1. `.firebaserc` を作る  

    ```
    cat << EOS > app/.firebaserc
    {
      "projects": {
        "default": "YOUR_PROJECT_ID"
      }
    }
    EOS
    ```

1. functionsで使用する環境変数を設定する  
    
    ```
    cd app/functions
    firebase functions:config:set takeoutmap.apikey='YOUR_SHEETS_API_KEY'
    firebase functions:config:set takeoutmap.sheetid='YOUR_SPREAD_SHEET_ID'
    firebase functions:config:get
      ### {
      ###   "takeoutmap": {
      ###     "sheetid": "YOUR_SPREAD_SHEET_ID",
      ###     "apikey": "YOUR_SHEETS_API_KEY"
      ###   }
      ### }
    
    ## For locally development
    firebase functions:config:get > .runtimeconfig.json
    ```

1. Node.jsモジュールをインストールする  

    ```
    npm install
    ```

1. ローカルで起動する

    ```
    firebase serve --only functions,hosting
    ```

    Open the http://localhost:5001/YOUR_PROJECT_ID/us-central1/app

### その他

ビューのテンプレートファイル( `app/functions/views/index.hbs` )は自由に書き換えてください。
