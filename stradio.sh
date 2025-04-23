#!/bin/bash

API="https://de1.api.radio-browser.info/json"

declare -A GENRE_MAP=(
  ["Adult Contemporary"]="adult contemporary,soft rock,lite hits"
  ["Alternative Rock"]="alternative,alt rock,indie,grunge"
  ["Blues"]="blues,delta blues,electric blues,R&B"
  ["Broadway"]="broadway,musicals,showtunes"
  ["Classical"]="classical,orchestral,symphony,baroque"
  ["Country"]="country,classic country,new country"
  ["Dance"]="dance,electronic,edm,club"
  ["Holiday Music"]="christmas,holiday,seasonal,xmas"
  ["Jazz"]="jazz,smooth jazz,vocal jazz"
  ["Latin"]="latin,reggaeton,salsa,tango"
  ["Oldies"]="oldies,50s,60s,70s,doo wop"
  ["Pop Hits"]="pop,top 40,mainstream,chart hits"
  ["Reggae"]="reggae,dub,ragga"
  ["Rock"]="rock,classic rock,hard rock,metal"
  ["Soundtracks"]="soundtrack,film score,cinematic"
  ["Talk"]="talk,news,spoken word"
  ["World Music"]="world,african,international"
  ["80s"]="80s,eighties"
  ["90s"]="90s,nineties"
  ["00s"]="2000s,00s"
  ["10s"]="2010s,10s"
)

# ジャンル選択
select_category() {
  local genres=("Adult Contemporary" "Alternative Rock" "Blues" "Broadway" "Classical" "Country" "Dance" "Holiday Music" "Jazz" "Latin" "Oldies" "Pop Hits" "Reggae" "Rock" "Soundtracks" "Talk" "World Music" "80s" "90s" "00s" "10s")
  
  # 手動でリスト表示
  for genre in "${genres[@]}"; do
    echo "$genre"
  done | fzf --prompt="Select a Genre > " --bind "esc:abort" --layout=reverse --header-first
}

# タグに基づいて局を選択
select_station_by_tags() {
  local tags="$1"
  local stations

  # タグごとに局を取得
  for tag in $(echo "$tags" | tr ',' '\n'); do
    tag=$(echo "$tag" | xargs)
    stations=$(curl -s -# "$API/stations/bytag/${tag// /%20}?limit=50&order=clickcount&reverse=true")
    # 空でない局だけ抽出して処理
    if [[ -n "$stations" ]]; then
      echo "$stations" | jq -r '.[] | "\(.name) | \(.country) | \(.bitrate)kbps | \(.url_resolved)"'
    fi
  done | fzf --prompt="Select a Station > " --bind "esc:abort" --layout=reverse --header-first
}

# URLが有効かどうかをチェックする関数
check_url_validity() {
  local url=$1
  curl --head --fail "$url" > /dev/null 2>&1
}

# カラー定義 (Iceberg準拠)
COLOR_RESET='\033[0m'
COLOR_INFO='\033[1;36m'    # Aqua
COLOR_ERROR='\033[1;31m'   # Red
COLOR_STATION='\033[1;33m' # Yellow
COLOR_COUNTRY='\033[1;32m' # Green
COLOR_BITRATE='\033[1;35m' # Magenta
COLOR_URL='\033[1;34m'     # Blue

while true; do
  # ジャンル選択
  category=$(select_category) || break
  tags="${GENRE_MAP[$category]}"
  
  # 局選択
  station=$(select_station_by_tags "$tags") || continue

  # URL抽出
  url=$(cut -d'|' -f4 <<< "$station" | xargs)
  name=$(cut -d'|' -f1 <<< "$station" | xargs)
  country=$(cut -d'|' -f2 <<< "$station" | xargs)
  bitrate=$(cut -d'|' -f3 <<< "$station" | xargs)

  if [[ -z "$url" ]]; then
    echo -e "${COLOR_ERROR}❌ Error: No valid URL found for station.${COLOR_RESET}"
    continue
  fi

  # 接続中メッセージ表示
  echo -e "${COLOR_INFO}--------------------------------------------------------------${COLOR_RESET}"
  echo -e "${COLOR_INFO}- Connecting to $name... Please wait.${COLOR_RESET}"
  echo -e "${COLOR_INFO}--------------------------------------------------------------${COLOR_RESET}"

  # 一度画面をクリア
  clear

  # 局情報表示
  echo -e "${COLOR_INFO}----------------------------------------------------------${COLOR_RESET}"
  echo -e "${COLOR_INFO}- Now playing: $name${COLOR_RESET}"
  echo -e "${COLOR_STATION}- Station: $name${COLOR_RESET}"
  echo -e "${COLOR_COUNTRY}- Country: $country${COLOR_RESET}"
  echo -e "${COLOR_BITRATE}- Bitrate: $bitrate${COLOR_RESET}"
  echo -e "${COLOR_URL}- Stream URL: $url${COLOR_RESET}"
  echo -e "${COLOR_INFO}----------------------------------------------------------${COLOR_RESET}"

  # 再生開始 (出力を抑制)
  if ! mplayer "$url" > /dev/null 2>&1; then
    echo -e "${COLOR_ERROR}❌ Error: Failed to play the station.${COLOR_RESET}"
  fi
done

