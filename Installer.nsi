# IF�`ELSE�`ENDIF�̂悤�ȏ�������Switch�����g�p���郉�C�u����
 !include LogicLib.nsh   
 
# �C���X�g�[���[����{�ꉻ
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Japanese.nlf"

# �A�v���P�[�V������
Name "2DDiffTool�C���X�g�[���["

# �쐬�����C���X�g�[����
OutFile "2DDiffTool.exe"

# �C���X�g�[�������f�B���N�g��
InstallDir "C:\2DDiffTool\"

#�C���X�g�[���ϐ�
Var count ;�C���X�g�[���[�̃y�[�W��(0,1,2,3)
Var installpath ;�v���O�����t�H���_�̃p�X
Var directorypath ;diff,drw2img�̃t�H���_�p�X
Var version 
Var size 
Var imagemagick ;ImageMasick�̃t�@�C���p�X
Var configwrite ;�ݒ�t�@�C���ւ̏������ݕϐ�

#�Ǘ��Ҍ������K�v�ȃt�H���_�̔���
var windowslen 
var programlen
var win
var program

# �y�[�W
#���C�Z���X�y�[�W
PageEx license
#�쐬�҂ɂ���ăp�X���قȂ�
LicenseData "C:\Users\Administrator\Desktop\�Ɩ�\Installer\input3\license.txt"
PageExEnd
Page instfiles

#�A�v���̃��W���[���̃C���X�g�[���y�[�W
PageEx directory 
 DirText  "�u�Q�Ɓv�������āA�C���X�g�[���t�H���_�̔z�u�� �I�����Ă��������B" �C���X�g�[���t�H���_
 DirVerify leave
 PageCallbacks "" "" DirectoryDeny
PageExEnd
Page instfiles 

#diff,drw2img�̃C���X�g�[���y�[�W
PageEx directory
 DirText "�u�Q�Ɓv�������āAdiff,drw2img�t�H���_�̔z�u�� �I�����Ă��������B" diff,drw2img�t�H���_�[
 DirVerify leave
 PageCallbacks "" "" DirectoryDeny
PageExEnd
Page instfiles

#�V���[�g�J�b�g�̍쐬,�X�^�[�g���j���[�o�^
Page components
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

Section "�X�^�[�g���j���[�ɓo�^"
${If} $count == 3
  
  #�X�^�[�g���j���[�̃V���[�g�J�b�g
  CreateDirectory "$SMPROGRAMS\�A�r�X�g"
  SetOutPath "$installpath"
  CreateShortcut "$SMPROGRAMS\�A�r�X�g\2DDiff.lnk" "$installpath\DiffToolMainFrame.exe" ""
${EndIf}

SectionEnd

Section "�f�X�N�g�b�v�ɃA�v���̃V���[�g�J�b�g���쐬"
${If} $count == 3

 SetOutPath "$installpath"
 CreateShortcut "$DESKTOP\2DDiff.lnk" "$installpath\DiffToolMainFrame.exe" ""
${EndIf}

SectionEnd
Section "�f�X�N�g�b�v��diff,drw2img�t�H���_�̃V���[�g�J�b�g���쐬"
${If} $count == 3
 SetOutPath "$installpath"
 CreateShortcut "$DESKTOP\diff.lnk" "$directorypath\diff" ""
 CreateShortcut "$DESKTOP\drw2img.lnk" "$directorypath\drw2img" ""
${EndIf}

SectionEnd
Section
 ${If} $count == 1  ;�v���O�����t�H���_�̃C���X�g�[��
  Call AppModule
  IntOp $count 0 + 2
 ${ElseIf} $count == 2 ;diff,drw2img�̃C���X�g�[��
  Call Directory
  Call Setting
  
  IntOp $count 0 + 3
 ${ElseIf} $count == 3 ;�V���[�g�J�b�g�̍쐬,�X�^�[�g���j���[�o�^
  Push "$installpath\DiffToolMainFrame.exe"
  Call FileSize
  IntOp $1 $1 * 1024
  IntOp $1 $1 / 1000
   #���W�X�g���L�[(�R���g���[���p�l���ɓo�^)
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDifftool" "DisplayName" "2DDiff�c�[��"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "UninstallString" '"$installpath\Uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "DisplayIcon" "$installpath\GUI_img\2DDy.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "Publisher" "�A�r�X�g"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "DisplayVersion" "1.0"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool" "EstimatedSize" "$1"
 ${Else} 
 ClearErrors
 
 #ImageMagick�̃C���X�g�[���m�F
 SearchPath $imagemagick "magick.exe"
 SearchPath $imagemagick "ImageMagick.ico"
 IfErrors 0 +3          
  Call Ininstaller
  GOTO next
  MessageBox MB_YESNO "���ł�ImageMagick���C���X�g�[������Ă��܂��B�C���X�g�[�����܂����H" IDYES yes IDNO no
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
  #uninstall.txt�ǂݍ���
  FileOpen $0 "$INSTDIR\uninstall.txt" r
  FileRead $0 $1
  FileClose $0
  #�X�^�[�g���j���[�t�H���_�̍폜
  Delete "$SMPROGRAMS\�A�r�X�g\2DDiff.lnk"
  RmDir /r "$SMPROGRAMS\�A�r�X�g"
  #�V���[�g�J�b�g�̍폜
  Delete "$DESKTOP\2DDiff.lnk"
  Delete "$DESKTOP\diff.lnk"
  Delete "$DESKTOP\drw2img.lnk"
  #�R���g���[���p�l���L�[�̍폜
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\2DDiffTool"
  
  # �t�@�C�����폜
  Delete "$INSTDIR\DiffToolMainFrame.exe"
  Delete "$INSTDIR\logger.log"
  Delete "$INSTDIR\uninstall.txt"
  Delete "$INSTDIR\config.ini"
  Delete "$INSTDIR\RunasAdmin.bat"
  Delete "$INSTDIR\CatiaVersionChange.bat"
  
  # �f�B���N�g�����폜
  RMDir /r "$INSTDIR\GUI_img\"
  RMDir /r "$1\diff\"
  RMDir /r "$1\drw2img"

   # �A���C���X�g�[�����폜
  Delete "$INSTDIR\Uninstall.exe"
SectionEnd


Function AppModule
  # �o�͐���w��
  SetOutPath "$INSTDIR"
  # �t�@�C���́A�C���X�g�[���[�쐬�҂̒[�����Q�Ƃ��Ă���̂ŁA�쐬�҂ɂ���ăp�X���قȂ�
  File "C:\Users\Administrator\Desktop\�Ɩ�\Installer\input2\uninstall.txt"
  File "C:\Users\Administrator\Desktop\�Ɩ�\Installer\input2\config.ini"
  
  #DiffToolMainFrame.exe,logger.log,�A�C�R���t�H���_�[�̃C���X�g�[��
  File /nonfatal /a /r "C:\Users\Administrator\Desktop\�Ɩ�\Installer\input\"
 
  # �A���C���X�g�[�����o��
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  StrCpy $installpath "$INSTDIR"
  
FunctionEnd

#diff,drw2img�t�H���_�[
Function Directory
  # �o�͐���w�肵�܂��B
  SetOutPath "$INSTDIR"
  StrCpy $directorypath "$INSTDIR"
  FileOpen $0 "$installpath\uninstall.txt" w
  FileWrite $0 "$INSTDIR"
  FileClose $0
  
  # diff�t�H���_��drw2img�t�H���_�̃C���X�g�[��
  File /nonfatal /a /r "C:\Users\Administrator\Desktop\�Ɩ�\Installer\input1\"
  
FunctionEnd

Function Ininstaller
	#ImageMagick�̃C���X�g�[������
	
 	SetOutPath C:\Temp\2DiffTool
    File "C:\Users\Administrator\Desktop\�Ɩ�\Installer\input3\ImageMagick-7.0.10-10-Q16-x64-dll.exe"
    #ImageMasick�C���X�g�[���[�N��
    ExecWait "C:\Temp\2DiffTool\ImageMagick-7.0.10-10-Q16-x64-dll.exe"
FunctionEnd

Function Setting
#config.ini���L�ڂ���B
  FileOpen $configwrite "$installpath\config.ini" w
  FileWrite $configwrite "[path]$\ndiff=$directorypath$\ndrw2img=$directorypath"
  FileClose $configwrite
FunctionEnd

Function FileSize
#�t�@�C���T�C�Y�̑���
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
#�C���X�g�[���悪C:\Windows,C:\Program Files,C:\Program Files(x86)�Ƃ����ۂ���B
StrLen $windowslen "C:\Windows"
StrLen $programlen "C:\Program Files"

StrCpy $win "$INSTDIR" $windowslen
StrCpy $program "$INSTDIR" $programlen


${If} $program == "C:\Program Files"
MessageBox MB_OK "C:\Program Files��C:\Windows���̊Ǘ��Ҍ������K�v�ȃt�H���_�ɂ́A�C���X�g�[���́A�ł��Ȃ��̂ŁA���̃t�H���_��I�����Ă��������B"
Abort 
${ELSEIf} $win == "C:\Windows"
MessageBox MB_OK "C:\Program Files��C:\Windows���̊Ǘ��Ҍ������K�v�ȃt�H���_�ɂ́A�C���X�g�[���́A�ł��Ȃ��̂ŁA���̃t�H���_��I�����Ă�������"
Abort 
${EndIf}
FunctionEnd

 Function .onUserAbort 
 #�C���X�g�[���[��ʂŃL�����Z�������Ƃ��̏���
 	${If} $count == 2 ;diff,drw2img�̃C���X�g�[��
 	${OrIf} $count == 3 ;�f�X�N�g�b�v�ɃV���[�g�J�b�g�̍쐬�A�X�^�[�g���j���[�o�^
 	ExecWait "$installpath\Uninstall.exe"
 	${EndIf}
   
 FunctionEnd


