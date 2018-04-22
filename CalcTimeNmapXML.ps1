<#
  .SYNOPSIS
    -�{�X�N���v�g�����s�����f�B���N�g���ȉ��ɑ��݂���
     �S�Ă�Nmap����xml�t�@�C������ANmap�̎��s���Ԃ��p�[�X���ĕW���o�͂ɏo�͂��܂��B
     
     ���ӁF<CommonParameters> �̓T�|�[�g���Ă��܂���B
   
  .DESCRIPTION
    -�{�X�N���v�g�����s�����f�B���N�g���ȉ��ɑ��݂���
     �S�Ă�Nmap����xml�t�@�C������ANmap�̎��s���Ԃ��p�[�X���ĕW���o�͂ɏo�͂��܂��B
     
    -�{�X�N���v�g��Nmap����xml�t�@�C������Nmap���s���Ԃ��p�[�X����ɂ́A
     ���Ȃ��Ƃ��ȉ��̃I�v�V������Nmap�R�}���h�ɕt�^����XML�t�@�C���𐶐����Ă��������B
       -v �������� -vv
       -oX [</path/to/NmapOutput.xml>]
       
    -xml�t�@�C���P�ʂŃz�X�g�𔻕ʂ��ďo�͂��܂��B
     1��xml�t�@�C����1�z�X�g�݂̂�Nmap���ʂ��L�ڂ���Ă���΁A����IPv4�A�h���X��\�����܂��B
     1��xml�t�@�C���ɕ����z�X�g��Nmap���ʂ��L�ڂ���Ă���΁A����xml�t�@�C������\�����܂��B
     Nmap���o�͂���xml�t�@�C���̏�����A
     ����Nmap���s�ŕ����z�X�g�ւ̐f�f���s�����ۂ�xml�t�@�C������́A
     �z�X�g�P�ʂ̎��Ԍv�����ł��܂���̂Œ��ӂ��Ă��������B
     
    -�|�[�g�X�L�����̎�ނ��Ƃ�Nmap���s���Ԃ��o�͂��܂��B
       e.g. ARP Ping Scan, UDP Scan, Connect Scan, ...
    
    -�ȉ��̏����^�u��؂�ɂďo�͂��܂��B�R�s�y���ăG�N�Z���Ȃǂɓ\��t���Ă��������B
       IPv4�܂���xml�t�@�C����	�|�[�g�X�L�������	������������(�b)
    
    -�{�X�N���v�g��IPv4�̃z�X�g�Ɏ��s����Nmap�̌��ʂɂ̂ݑΉ����Ă��܂��B
     IPv6�ɂ͑Ή����Ă��܂���B
    
  .EXAMPLE
    PS C:\Data> .\CalcTimeNmapXML.ps1
   
  .LINK
    -�Ȃ��B
   
  .PARAMETER Path
    -�Ȃ��B�t�@�C�������w�肵�Ă̎��s�ɂ͑Ή����Ă��܂���B
    
  .INPUTS
    -�Ȃ��B�p�C�v���C������̓��͂ɂ͑Ή����Ă��܂���B
    
  .OUTPUTS
    -System.String
     �W���o�͂֏o�͂��܂��B
    
  .NOTES
    20180422 r1
#>

#help�X�C�b�`
Param ( [switch]$help )
if ( ${help} )
  {
  $ScriptFullName = $MyInvocation.MyCommand.Path
  Get-Help ${ScriptFullName}
  exit
  }

#xml�t�@�C�����Œ��͂��邩�m�F
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
  #XML�^�ɃL���X�g
  $MYXML = [xml]( Get-Content ${LINE} )
  #XPathNavigator�I�u�W�F�N�g�쐬
  $MYXNAVI = ${MYXML}.CreateNavigator()
  
  #xml�̃��[�g��nmaprun�����邩�ǂ����m�F���A
  #�Ȃ�������Nmap��xml�t�@�C������Ȃ��Ɣ��f�����t�@�C����
  if ( ![bool]${MYXML}.nmaprun )
    {
    Write-Output "${FILENAME}`t[ERROR]`tThis file doesn`'t seem to be NmapXML."
    continue
    }

  #����ނ̃X�L�������������
  $SCANNEDNUM = [int]( ${MYXNAVI}.Select("/nmaprun/taskend/@task") | %{ $_.Value} ).Count
  #0��ނȂ�Nmap���s����v�I�v�V�����t���ĂȂ��Ɣ��f�����t�@�C����
  if ( ${SCANNEDNUM} -le 0)
    {
    Write-Output "${FILENAME}`t[ERROR]`tNo Scan type is found. Prease run nmap with '-v' option."
    continue
    }

  #�X�L��������IP�A�h���X��z��Ŋi�[
  $IPLIST = ${MYXNAVI}.Select("/nmaprun/host/address[@addrtype = 'ipv4']/@addr") | %{$_.Value}
  #IP�A�h���X�̌����i�[
  $IPCOUNT = [int]${IPLIST}.Count
  #IP�A�h���X�̌�����f�f�������肷��
  if ( ${IPCOUNT} -le 0 )
    {
    Write-Output "${FILENAME}`t[ERROR]`tipv4 was not found."
    continue
    } elseif ( ${IPCOUNT} -ge 2 ) {
    #���xml�t�@�C���ɂĕ����̃z�X�g�̐f�f���s���Ă����ꍇ�A
    #XML�t�@�C������f�f���Ƃ���
    [string]$SCANNAME = "[multiple hosts]" + ${FILENAME}
    } else {
    #IP�A�h���X��f�f���Ƃ���
    [string]$SCANNAME = ${IPLIST}
    }
  
  #�X�L�������ނ����Ԍv�Z&�o��
  for ( $i = 1; ${i} -le ${SCANNEDNUM}; ${i}++ )
    {
    #�X�L�����̎�ޖ�
    $TASKNAME = [string]( ${MYXNAVI}.Select("/nmaprun/taskend[${i}]/@task") | %{$_.Value} )
    #�X�L�����J�n����
    $TASKBEGIN = [int]( ${MYXNAVI}.Select("/nmaprun/taskbegin[${i}]/@time") | %{$_.Value} )
    #�X�L�����I������
    $TASKEND = [int]( ${MYXNAVI}.Select("/nmaprun/taskend[${i}]/@time") | %{$_.Value} )
    #�X�L�����ɂ�����������(�b)
    $TASKTIME = ${TASKEND} - ${TASKBEGIN}
    #���ʏo��
    Write-Output "${SCANNAME}`t${TASKNAME}`t${TASKTIME}"
    }
  }
