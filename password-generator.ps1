$Password = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | sort {Get-Random})[0..8] -join ''
$Password
# Example: Fj-Rs!4p2z

# PS> dir C:\Windows\*.* | Get-Random | Get-FileHash -Algorithm SHA1
# Example: 819AABA1653415766D4A6B0F5F89833F4E40AA27

# https://www.netmux.com/blog/random-password-cheat-sheet
