<#
  .SYNOPSIS
    -本スクリプトを実行したディレクトリ以下に存在する
     全てのNmap結果xmlファイルから、Nmapの実行時間をパースして標準出力に出力します。
     
     注意：<CommonParameters> はサポートしていません。
   
  .DESCRIPTION
    -本スクリプトを実行したディレクトリ以下に存在する
     全てのNmap結果xmlファイルから、Nmapの実行時間をパースして標準出力に出力します。
     
    -本スクリプトでNmap結果xmlファイルからNmap実行時間をパースするには、
     少なくとも以下のオプションをNmapコマンドに付与してXMLファイルを生成してください。
       -v もしくは -vv
       -oX [</path/to/NmapOutput.xml>]
       
    -xmlファイル単位でホストを判別して出力します。
     1つのxmlファイルに1ホストのみのNmap結果が記載されていれば、そのIPv4アドレスを表示します。
     1つのxmlファイルに複数ホストのNmap結果が記載されていれば、そのxmlファイル名を表示します。
     Nmapが出力するxmlファイルの書式上、
     一回のNmap実行で複数ホストへの診断を行った際のxmlファイルからは、
     ホスト単位の時間計測ができませんので注意してください。
     
    -ポートスキャンの種類ごとにNmap実行時間を出力します。
       e.g. ARP Ping Scan, UDP Scan, Connect Scan, ...
    
    -以下の情報をタブ区切りにて出力します。コピペしてエクセルなどに貼り付けてください。
       IPv4またはxmlファイル名	ポートスキャン種類	かかった時間(秒)
    
    -本スクリプトはIPv4のホストに実行したNmapの結果にのみ対応しています。
     IPv6には対応していません。
    
  .EXAMPLE
    PS C:\Data> .\CalcTimeNmapXML.ps1
   
  .LINK
    -なし。
   
  .PARAMETER Path
    -なし。ファイル名を指定しての実行には対応していません。
    
  .INPUTS
    -なし。パイプラインからの入力には対応していません。
    
  .OUTPUTS
    -System.String
     標準出力へ出力します。
    
  .NOTES
    20180422 r1
#>

#helpスイッチ
Param ( [switch]$help )
if ( ${help} )
  {
  $ScriptFullName = $MyInvocation.MyCommand.Path
  Get-Help ${ScriptFullName}
  exit
  }

#xmlファイルが最低一つはあるか確認
if ( !( Test-Path *.xml ) )
  {
  Write-Output "There is no *.xml file in (pwd)."
  Read-Host "Prease press the Enter key..."
  exit
  }

#main
foreach ( $LINE in Get-ChildItem .\*.xml )
  {
  $FILENAME = [string]${LINE}.Name
  #XML型にキャスト
  $MYXML = [xml]( Get-Content ${LINE} )
  #XPathNavigatorオブジェクト作成
  $MYXNAVI = ${MYXML}.CreateNavigator()
  
  #xmlのルートにnmaprunがあるかどうか確認し、
  #なかったらNmapのxmlファイルじゃないと判断し次ファイルへ
  if ( ![bool]${MYXML}.nmaprun )
    {
    Write-Output "${FILENAME}`t[ERROR]`tThis file doesn`'t seem to be NmapXML."
    continue
    }

  #何種類のスキャンをやったか
  $SCANNEDNUM = [int]( ${MYXNAVI}.Select("/nmaprun/taskend/@task") | %{ $_.Value} ).Count
  #0種類ならNmap実行時にvオプション付けてないと判断し次ファイルへ
  if ( ${SCANNEDNUM} -le 0)
    {
    Write-Output "${FILENAME}`t[ERROR]`tNo Scan type is found. Prease run nmap with '-v' option."
    continue
    }

  #スキャンしたIPアドレスを配列で格納
  $IPLIST = ${MYXNAVI}.Select("/nmaprun/host/address[@addrtype = 'ipv4']/@addr") | %{$_.Value}
  #IPアドレスの個数を格納
  $IPCOUNT = [int]${IPLIST}.Count
  #IPアドレスの個数から診断名を決定する
  if ( ${IPCOUNT} -le 0 )
    {
    Write-Output "${FILENAME}`t[ERROR]`tipv4 was not found."
    continue
    } elseif ( ${IPCOUNT} -ge 2 ) {
    #一つのxmlファイルにて複数のホストの診断が行われていた場合、
    #XMLファイル名を診断名とする
    [string]$SCANNAME = "[multiple hosts]" + ${FILENAME}
    } else {
    #IPアドレスを診断名とする
    [string]$SCANNAME = ${IPLIST}
    }
  
  #スキャン一種類ずつ時間計算&出力
  for ( $i = 1; ${i} -le ${SCANNEDNUM}; ${i}++ )
    {
    #スキャンの種類名
    $TASKNAME = [string]( ${MYXNAVI}.Select("/nmaprun/taskend[${i}]/@task") | %{$_.Value} )
    #スキャン開始時刻
    $TASKBEGIN = [int]( ${MYXNAVI}.Select("/nmaprun/taskbegin[${i}]/@time") | %{$_.Value} )
    #スキャン終了時刻
    $TASKEND = [int]( ${MYXNAVI}.Select("/nmaprun/taskend[${i}]/@time") | %{$_.Value} )
    #スキャンにかかった時間(秒)
    $TASKTIME = ${TASKEND} - ${TASKBEGIN}
    #結果出力
    Write-Output "${SCANNAME}`t${TASKNAME}`t${TASKTIME}"
    }
  }
