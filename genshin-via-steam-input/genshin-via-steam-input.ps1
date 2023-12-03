# Steamを閉じる
Start-Process 'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent -shutdown' -Wait
while (Get-Process -Name steam -ErrorAction SilentlyContinue) {
  Start-Sleep 1
}

# 管理者としてSteamを立ち上げ,原神を起動
Start-Process 'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent steam://rungameid/xxxxxxxxxxxxxxxxxxxx' -Verb RunAs 

# ゲーム終了後にEnterを押させる
Read-Host -Prompt "ゲームが終了したらEnterを押してね"

# 管理者として立ち上げたSteamを閉じる
Start-Process 'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent -shutdown' -Wait
while (Get-Process -Name steam -ErrorAction SilentlyContinue) {
  Start-Sleep 1
}

# 元のユーザーでSteamを立ち上げる
Start-Process 'C:\Program Files (x86)\Steam\steam.exe' -ArgumentList '-silent'
