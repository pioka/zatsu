# Steamを閉じる
Start-Process -Wait `
  'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent -shutdown'

# 管理者としてSteamを立ち上げ,原神を起動
Start-Process -Verb RunAs `
  'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent steam://rungameid/xxxxxxxxxxxxxxxxxxxx'

# ゲーム終了後にEnterを押させる想定
pause

# Steamを閉じる
Start-Process -Wait `
  'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent -shutdown'

# 元のユーザーで再度Steamを立ち上げる
Start-Process `
  'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent'
