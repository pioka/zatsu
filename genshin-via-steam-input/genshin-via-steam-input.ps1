# Steamを閉じる
Start-Process -Wait `
  'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent -shutdown'

while (Get-Process -Name steam -ErrorAction SilentlyContinue) {
  Start-Sleep 1
  echo 'Waiting for Steam to shutdown...'
}

# 管理者としてSteamを立ち上げ,原神を起動
Start-Process -Verb RunAs `
  'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent steam://rungameid/xxxxxxxxxxxxxxxxxxxx'

# ゲーム終了後にEnterを押させる想定
pause

# 管理者として立ち上げたSteamを閉じる
Start-Process -Wait `
  'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent -shutdown'

while (Get-Process -Name steam -ErrorAction SilentlyContinue) {
  Start-Sleep 1
  echo 'Waiting for Steam to shutdown...'
}

# 元のユーザーでSteamを立ち上げる
Start-Process -Wait `
  'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent'
