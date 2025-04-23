
# Radio Stream Selector

このスクリプトは、指定したジャンルのラジオ局を選択し、選択した局のストリームを再生するためのものです。`fzf` を使用してジャンルや局をインタラクティブに選び、`mplayer` で選ばれたラジオ局を再生します。

## 依存関係

- [fzf](https://github.com/junegunn/fzf): ジャンルおよび局の選択に使用
- [mplayer](https://www.mplayerhq.hu/): ラジオ局のストリームを再生するために使用
- [jq](https://stedolan.github.io/jq/): JSONデータを処理するために使用

## インストール方法

1. 必要なパッケージをインストールします：

   ```bash
   sudo apt-get install fzf mplayer jq
   ```

2. スクリプトをダウンロードして実行可能にします：

   ```bash
   chmod +x radio_stream_selector.sh
   ```

## 使用方法

1. スクリプトを実行します：

   ```bash
   ./radio_stream_selector.sh
   ```

2. `fzf` を使用してジャンルを選択します。次に、選択したジャンルに関連するラジオ局が表示されるので、さらに `fzf` で局を選択します。

3. 選択した局のストリームURLが表示され、`mplayer` を使用してそのラジオ局のストリームを再生します。

## 機能

- ジャンル選択：ラジオ局をジャンル別に分類
- タグ選択：各ジャンルに関連するタグを使用して局を選択
- 局情報表示：選択した局の名前、国、ビットレート、ストリームURLを表示
- ストリーム再生：`mplayer` を使用して選択したラジオ局を再生

## サポートされるジャンル

- Adult Contemporary
- Alternative Rock
- Blues
- Broadway
- Classical
- Country
- Dance
- Holiday Music
- Jazz
- Latin
- Oldies
- Pop Hits
- Reggae
- Rock
- Soundtracks
- Talk
- World Music
- 80s
- 90s
- 00s
- 10s

## 注意事項

- ストリームURLが無効な場合、エラーメッセージが表示されます。
- 使用する端末に `mplayer` がインストールされていない場合、再生が失敗します。

## ライセンス

このスクリプトは、MITライセンスの下で提供されています。
