<script>
      @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
      winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
    </script>
    <powershell>
       # Install the OpenSSH Client
       Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
       
       # Install the OpenSSH Server
       Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

       # Start the sshd service
       Start-Service sshd

       # OPTIONAL but recommended:
       Set-Service -Name sshd -StartupType 'Automatic'
       
       # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
       if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
           Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
           New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
       } else {
           Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
       }

       # Can test this also for firewall issue
       #"Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
#      netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
#      # Set Administrator password
       $Password = "${Password}"
       $admin = [adsi]("WinNT://./administrator, user")
       $admin.psbase.invoke("SetPassword", $Password)
    </powershell>

