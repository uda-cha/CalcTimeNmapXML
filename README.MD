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