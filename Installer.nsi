# IF～ELSE～ENDIFのような条件式やSwitch文を使用するライブラリ
 !include LogicLib.nsh   
 
# インストーラーを日本語化
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Japanese.nlf"

# アプリケーション名
Name "2DDiffToolインストーラー"

# 作成されるインストーラ名
OutFile "2DDiffTool.exe"

# インストールされるディレクトリ
InstallDir "C:\2DDiffTool\"

#インストール変数
Var count ;インストーラーのページ数(0,1,2,3)
Var installpath ;プログラムフォルダのパス
Var directorypath ;diff,drw2imgのフォルダパス
Var version 
Var size 
Var imagemagick ;ImageMasickのファイルパス
Var configwrite ;設定ファイルへの書き込み変数

#管理者権限が必要なフォルダの判別
var windowslen 
var programlen
var win
var program

# ページ
#ライセンスページ
PageEx license
#作成者によってパスが異なる
LicenseData "C:\Users\Administrator\Desktop\業務\Installer\input3\license.txt"
PageExEnd
Page instfiles

#アプリのモジュールのインストールページ
PageEx directory 
 DirText  "「参照」を押して、インストールフォルダの配置を 選択してください。" インストールフォルダ
 DirVerify leave
 PageCallbacks "" "" DirectoryDeny
PageExEnd
Page instfiles 

#diff,drw2imgのインストールページ
PageEx directory
 DirText "「参照」を押して、diff,drw2imgフォルダの配置を 選択してください。" diff,drw2imgフォルダー
 DirVerify leave
 PageCallbacks "" "" DirectoryDeny
PageExEnd
Page instfiles

#ショートカットの作成,スタートメニュー登録
Page components
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

Section "スタートメニューに登録"
${If} $count == 3
  
  #スタートメニューのショートカット
  CreateDirectory "$SMPROGRAMS\アビスト"
  SetOutPath "$installpath"
  CreateShortcut "$SMPROGRAMS\アビスト\2DDiff.lnk" "$installpath\DiffToolMainFrame.exe" ""
${EndIf}

SectionEnd

Section "デスクトップにアプリのショートカットを作成"
${If} $count == 3

 SetOutPath "$installpath"
 CreateShortcut "$DESKTOP\2DDiff.lnk" "$installpath\DiffToolMainFrame.exe" ""
${EndIf}

SectionEnd
Section "デスクトップにdiff,drw2imgフォルダのショートカットを作成"
${If} $count == 3
 SetOutPath "$installpath"
 CreateShortcut "$DESKTOP\diff.lnk" "$directorypath\diff" ""
 CreateShortcut "$DESKTOP\drw2img.lnk" "$directorypath\drw2img" ""
${EndIf}

SectionEnd
Section
 ${If} $count == 1  ;プログラムフォルダのインストール
  Call AppModule
  IntOp $count 0 + 2
 ${ElseIf} $count == 2 ;diff,drw2imgのインストール
  Call Directory
  Call Setting
  
  IntOp $count 0 + 3
 ${ElseIf} $count == 3 ;ショートカットの作成,スタートメニュー登録
  Push "$installpath\DiffToolMainFrame.exe"
  Call FileSize
  IntOp $1 $1 * 1024
  IntOp $1 $1 / 1000
   #レジストリキー(コントロールパネルに登録)
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDifftool" "DisplayName" "2DDiffツール"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "UninstallString" '"$installpath\Uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "DisplayIcon" "$installpath\GUI_img\2DDy.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "Publisher" "アビスト"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "DisplayVersion" "1.0"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "EstimatedSize" "$1"
 ${Else} 
 ClearErrors
 
 #ImageMagickのインストール確認
 SearchPath $imagemagick "magick.exe"
 SearchPath $imagemagick "ImageMagick.ico"
 IfErrors 0 +3          
  Call Ininstaller
  GOTO next
  MessageBox MB_YESNO "すでにImageMagickがインストールされています。インストールしますか？" IDYES yes IDNO no
  yes:
  DetailPrint "yes"
  Call Ininstaller
  GOTO next
  no:
  DetailPrint "no"
  next:
  SetOutPath C:\Temp
  RMDir /r "C:\Temp\2DiffTool"
  IntOp $count 0 + 1
 ${EndIf}
SectionEnd

Section "Uninstall"
  #uninstall.txt読み込み
  FileOpen $0 "$INSTDIR\uninstall.txt" r
  FileRead $0 $1
  FileClose $0
  #スタートメニューフォルダの削除
  Delete "$SMPROGRAMS\アビスト\2DDiff.lnk"
  RmDir /r "$SMPROGRAMS\アビスト"
  #ショートカットの削除
  Delete "$DESKTOP\2DDiff.lnk"
  Delete "$DESKTOP\diff.lnk"
  Delete "$DESKTOP\drw2img.lnk"
  #コントロールパネルキーの削除
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool"
  
  # ファイルを削除
  Delete "$INSTDIR\DiffToolMainFrame.exe"
  Delete "$INSTDIR\logger.log"
  Delete "$INSTDIR\uninstall.txt"
  Delete "$INSTDIR\config.ini"
  Delete "$INSTDIR\RunasAdmin.bat"
  Delete "$INSTDIR\CatiaVersionChange.bat"
  
  # ディレクトリを削除
  RMDir /r "$INSTDIR\GUI_img\"
  RMDir /r "$1\diff\"
  RMDir /r "$1\drw2img"

   # アンインストーラを削除
  Delete "$INSTDIR\Uninstall.exe"
SectionEnd


Function AppModule
  # 出力先を指定
  SetOutPath "$INSTDIR"
  # ファイルは、インストーラー作成者の端末を参照しているので、作成者によってパスが異なる
  File "C:\Users\Administrator\Desktop\業務\Installer\input2\uninstall.txt"
  File "C:\Users\Administrator\Desktop\業務\Installer\input2\config.ini"
  
  #DiffToolMainFrame.exe,logger.log,アイコンフォルダーのインストール
  File /nonfatal /a /r "C:\Users\Administrator\Desktop\業務\Installer\input\"
 
  # アンインストーラを出力
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  StrCpy $installpath "$INSTDIR"
  
FunctionEnd

#diff,drw2imgフォルダー
Function Directory
  # 出力先を指定します。
  SetOutPath "$INSTDIR"
  StrCpy $directorypath "$INSTDIR"
  FileOpen $0 "$installpath\uninstall.txt" w
  FileWrite $0 "$INSTDIR"
  FileClose $0
  
  # diffフォルダとdrw2imgフォルダのインストール
  File /nonfatal /a /r "C:\Users\Administrator\Desktop\業務\Installer\input1\"
  
FunctionEnd

Function Ininstaller
	#ImageMagickのインストール処理
	
 	SetOutPath C:\Temp\2DiffTool
    File "C:\Users\Administrator\Desktop\業務\Installer\input3\ImageMagick-7.0.10-10-Q16-x64-dll.exe"
    #ImageMasickインストーラー起動
    ExecWait "C:\Temp\2DiffTool\ImageMagick-7.0.10-10-Q16-x64-dll.exe"
FunctionEnd

Function Setting
#config.iniを記載する。
  FileOpen $configwrite "$installpath\config.ini" w
  FileWrite $configwrite "[path]$\ndiff=$directorypath$\ndrw2img=$directorypath"
  FileClose $configwrite
FunctionEnd

Function FileSize
#ファイルサイズの測定
 Exch $R0 ; Input path
  Push $0 ; Save
  FileOpen $0 "$R0" r
  System::Call 'kernel32::GetFileSize(pr0, p0)i.r1' ; Call API to read 32-bit file size
  FileClose $0
 IntCmp -1 $1 +3
 IntOp $1 $1 / 1024 ; $1 is in bytes, let's convert to KBs
 Goto +2
 StrCpy $1 "unknown" ; GetFileSize failed
 FunctionEnd

Function DirectoryDeny
#インストール先がC:\Windows,C:\Program Files,C:\Program Files(x86)とき拒否する。
StrLen $windowslen "C:\Windows"
StrLen $programlen "C:\Program Files"

StrCpy $win "$INSTDIR" $windowslen
StrCpy $program "$INSTDIR" $programlen


${If} $program == "C:\Program Files"
MessageBox MB_OK "C:\Program FilesやC:\Windows等の管理者権限が必要なフォルダには、インストールは、できないので、他のフォルダを選択してください。"
Abort 
${ELSEIf} $win == "C:\Windows"
MessageBox MB_OK "C:\Program FilesやC:\Windows等の管理者権限が必要なフォルダには、インストールは、できないので、他のフォルダを選択してください"
Abort 
${EndIf}
FunctionEnd

 Function .onUserAbort 
 #インストーラー画面でキャンセルしたときの処理
 	${If} $count == 2 ;diff,drw2imgのインストール
 	${OrIf} $count == 3 ;デスクトップにショートカットの作成、スタートメニュー登録
 	ExecWait "$installpath\Uninstall.exe"
 	${EndIf}
   
 FunctionEnd


