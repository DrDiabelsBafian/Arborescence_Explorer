# ====================================================================
# SCRIPT : Arborescence Explorer v5.0 - GitHub Edition
# AUTEUR : Claude pour Fabian (Dr. Diabels Bafian)
# USAGE  : Double-cliquer sur Arborescence_Explorer.bat
# REPO   : github.com/[votre-repo]/arborescence-explorer
# ====================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Fix DPI pour nettete sur ecrans haute resolution
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class DpiAwareness {
    [DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();
}
"@
[void][DpiAwareness]::SetProcessDPIAware()

# ====================================================================
# DETECTION DES OUTILS
# ====================================================================

function Test-CommandExists {
    param ([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

$script:HasFFprobe = Test-CommandExists "ffprobe"

# ====================================================================
# FONCTIONS UTILITAIRES
# ====================================================================

function Format-FileSize {
    param ([long]$Size)
    if ($Size -eq 0) { return "0 o" }
    if ($Size -ge 1GB) { return "{0:N2} Go" -f ($Size / 1GB) }
    if ($Size -ge 1MB) { return "{0:N2} Mo" -f ($Size / 1MB) }
    if ($Size -ge 1KB) { return "{0:N2} Ko" -f ($Size / 1KB) }
    return "$Size o"
}

function Format-Duration {
    param ([double]$Seconds)
    if ($Seconds -lt 60) { return "{0:N0}s" -f $Seconds }
    if ($Seconds -lt 3600) {
        $min = [math]::Floor($Seconds / 60)
        $sec = [math]::Floor($Seconds % 60)
        return "{0}m{1:D2}s" -f $min, $sec
    }
    $hours = [math]::Floor($Seconds / 3600)
    $min = [math]::Floor(($Seconds % 3600) / 60)
    return "{0}h{1:D2}m" -f $hours, $min
}

function Get-TokenEstimate {
    param ([string]$Text)
    if (-not $Text) { return 0 }
    return [math]::Ceiling($Text.Length / 4)
}

function Format-TokenCount {
    param ([int]$Tokens)
    if ($Tokens -ge 1000000) { return "{0:N1}M" -f ($Tokens / 1000000) }
    if ($Tokens -ge 1000) { return "{0:N1}k" -f ($Tokens / 1000) }
    return "$Tokens"
}

# ====================================================================
# FONCTIONS FFPROBE (VIDEO/AUDIO)
# ====================================================================

function Get-MediaInfo {
    param ([string]$FilePath)

    if (-not $script:HasFFprobe) { return $null }

    try {
        $json = & ffprobe -v quiet -print_format json -show_format -show_streams "$FilePath" 2>$null
        if ($LASTEXITCODE -ne 0) { return $null }

        $info = $json | ConvertFrom-Json
        $result = @{
            Duration = $null
            Resolution = $null
            Codec = $null
            AudioTracks = @()
            Bitrate = $null
        }

        if ($info.format.duration) {
            $result.Duration = [double]$info.format.duration
        }
        if ($info.format.bit_rate) {
            $result.Bitrate = [math]::Round([long]$info.format.bit_rate / 1000)
        }

        $videoStream = $info.streams | Where-Object { $_.codec_type -eq 'video' } | Select-Object -First 1
        if ($videoStream) {
            $result.Resolution = "$($videoStream.width)x$($videoStream.height)"
            $result.Codec = $videoStream.codec_name
        }

        $audioStreams = $info.streams | Where-Object { $_.codec_type -eq 'audio' }
        foreach ($audio in $audioStreams) {
            $lang = if ($audio.tags.language) { $audio.tags.language } else { "?" }
            $codec = $audio.codec_name
            $channels = $audio.channels
            $result.AudioTracks += "$lang/$codec/${channels}ch"
        }

        return $result
    } catch {
        return $null
    }
}

function Format-MediaInfo {
    param ($MediaInfo)

    if (-not $MediaInfo) { return "" }

    $parts = @()
    if ($MediaInfo.Duration) { $parts += Format-Duration $MediaInfo.Duration }
    if ($MediaInfo.Resolution) { $parts += $MediaInfo.Resolution }
    if ($MediaInfo.Codec) { $parts += $MediaInfo.Codec }
    if ($MediaInfo.Bitrate) { $parts += "$($MediaInfo.Bitrate)kbps" }
    if ($MediaInfo.AudioTracks.Count -gt 0) {
        $parts += "Audio: " + ($MediaInfo.AudioTracks -join ", ")
    }

    return $parts -join " | "
}

# ====================================================================
# FONCTIONS EXCLUSION
# ====================================================================

$script:Exclusions = @('.git', 'node_modules', '__pycache__', '$RECYCLE.BIN', '.vs', '.vscode', 'bin', 'obj', '.idea', 'vendor', 'packages', '.next', 'dist', '.cache', '.tmp')

function Test-Excluded {
    param ([string]$Name, [bool]$UseExclusions)
    if (-not $UseExclusions) { return $false }
    return $script:Exclusions -contains $Name
}

# ====================================================================
# EXTENSIONS CONNUES
# ====================================================================

$script:VideoExtensions = @('.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv', '.webm', '.m4v', '.mpeg', '.mpg')
$script:AudioExtensions = @('.mp3', '.wav', '.flac', '.aac', '.ogg', '.wma', '.m4a', '.opus')

# ====================================================================
# FONCTION PRINCIPALE : GET-TREE
# ====================================================================

function Get-Tree {
    param (
        [string]$Path,
        [int]$Level = 0,
        [int]$CurrentDepth = 0,
        [hashtable]$Options,
        [System.Windows.Forms.Label]$StatusLabel
    )

    $Output = @()
    $Indent = "  " * $Level
    $FolderName = Split-Path $Path -Leaf

    if ($Level -eq 0) {
        $Output += "$FolderName\"
    } else {
        $Output += "$Indent+-- $FolderName\"
    }

    if ($StatusLabel) {
        $StatusLabel.Text = "Scan: $FolderName"
        [System.Windows.Forms.Application]::DoEvents()
    }

    if ($Options.MaxDepth -gt 0 -and $CurrentDepth -ge $Options.MaxDepth) {
        $Output += "$Indent    [...profondeur max atteinte...]"
        return $Output
    }

    try {
        $SubFolders = Get-ChildItem -Path $Path -Directory -ErrorAction Stop |
                      Where-Object { -not (Test-Excluded $_.Name $Options.UseExclusions) } |
                      Sort-Object Name

        foreach ($Folder in $SubFolders) {
            $Output += Get-Tree -Path $Folder.FullName -Level ($Level + 1) -CurrentDepth ($CurrentDepth + 1) -Options $Options -StatusLabel $StatusLabel
        }

        if ($Options.Mode -eq "COMPLET") {
            $Files = Get-ChildItem -Path $Path -File -ErrorAction Stop | Sort-Object Name

            foreach ($File in $Files) {
                $FileIndent = "  " * ($Level + 1)
                $Output += "$FileIndent+-- $($File.Name)"

                $ext = $File.Extension.ToLower()

                if ($Options.ShowMetadata) {
                    $FilePoids = Format-FileSize $File.Length
                    $FileCree = $File.CreationTime.ToString('dd/MM/yyyy HH:mm')
                    $FileModif = $File.LastWriteTime.ToString('dd/MM/yyyy HH:mm')
                    $Output += "$FileIndent    Poids: $FilePoids | Cree: $FileCree | Modif: $FileModif"
                }

                if ($Options.AnalyzeMedia -and ($script:VideoExtensions -contains $ext -or $script:AudioExtensions -contains $ext)) {
                    $mediaInfo = Get-MediaInfo -FilePath $File.FullName
                    if ($mediaInfo) {
                        $formatted = Format-MediaInfo $mediaInfo
                        if ($formatted) {
                            $Output += "$FileIndent    [MEDIA] $formatted"
                        }
                    }
                }
            }
        }
    } catch {
        $Output += "$Indent    [Acces refuse]"
    }

    return $Output
}

# ====================================================================
# STATISTIQUES
# ====================================================================

function Get-Statistics {
    param ([string]$Path, [bool]$ShowStats)

    $Stats = @()
    $Stats += ""
    $Stats += "=========================================="
    $Stats += "STATISTIQUES"
    $Stats += "=========================================="

    try {
        $AllItems = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue
        $Folders = $AllItems | Where-Object { $_.PSIsContainer }
        $Files = $AllItems | Where-Object { -not $_.PSIsContainer }

        $TotalSize = ($Files | Measure-Object -Property Length -Sum).Sum

        $Stats += "Dossiers     : $($Folders.Count)"
        $Stats += "Fichiers     : $($Files.Count)"
        $Stats += "Taille totale: $(Format-FileSize $TotalSize)"

        if ($ShowStats -and $Files.Count -gt 0) {
            $Stats += ""
            $Stats += "--- Repartition par extension ---"
            $ExtStats = $Files | Group-Object Extension | Sort-Object Count -Descending | Select-Object -First 10
            foreach ($Ext in $ExtStats) {
                $ExtName = if ($Ext.Name -eq "") { "(sans ext)" } else { $Ext.Name }
                $ExtSize = ($Ext.Group | Measure-Object -Property Length -Sum).Sum
                $Stats += "  $($ExtName.PadRight(12)) : $($Ext.Count.ToString().PadLeft(5)) fichiers  $(Format-FileSize $ExtSize)"
            }

            $Stats += ""
            $Stats += "--- Top 10 plus gros fichiers ---"
            $TopFiles = $Files | Sort-Object Length -Descending | Select-Object -First 10
            $i = 1
            foreach ($F in $TopFiles) {
                $RelPath = $F.FullName.Replace($Path, "").TrimStart("\")
                $Stats += "  $i. $(Format-FileSize $F.Length) - $RelPath"
                $i++
            }
        }
    } catch {
        $Stats += "[Erreur lors du calcul des stats]"
    }

    return $Stats
}

# ====================================================================
# EXPORT MARKDOWN
# ====================================================================

function Export-Markdown {
    param (
        [string]$TreeContent,
        [string]$StatsContent,
        [string]$Title,
        [string]$SourcePath,
        [hashtable]$Options,
        [int]$TokenCount,
        [string]$OutputFile
    )

    $md = @()
    $md += "# $Title"
    $md += ""
    $md += "| Info | Valeur |"
    $md += "|------|--------|"
    $md += "| Genere le | $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss') |"
    $md += "| Racine | ``$SourcePath`` |"
    $ModeDisplay = if ($Options.Mode -eq 'DOSSIERS') { 'Dossiers uniquement' } else { 'Dossiers + Fichiers' }
    $md += "| Mode | $ModeDisplay |"
    $DepthDisplay = if ($Options.MaxDepth -eq 0) { 'Illimitee' } else { "$($Options.MaxDepth) niveaux" }
    $md += "| Profondeur | $DepthDisplay |"
    $md += "| Tokens estimes | ~$(Format-TokenCount $TokenCount) tokens |"
    $md += ""

    # Context window compatibility
    $md += "### Compatibilite fenetres contexte LLM"
    $md += ""
    $contextWindows = @(
        @{ Name = "Claude (200k)"; Limit = 200000 }
        @{ Name = "GPT-4o (128k)"; Limit = 128000 }
        @{ Name = "GPT-4 (8k)"; Limit = 8000 }
        @{ Name = "Gemini 2.0 (1M)"; Limit = 1000000 }
    )
    $md += "| Modele | Limite | Usage | Statut |"
    $md += "|--------|--------|-------|--------|"
    foreach ($cw in $contextWindows) {
        $pct = [math]::Round(($TokenCount / $cw.Limit) * 100, 1)
        $status = if ($pct -le 80) { "OK" } elseif ($pct -le 100) { "LIMITE" } else { "DEPASSE" }
        $md += "| $($cw.Name) | $(Format-TokenCount $cw.Limit) | $pct% | $status |"
    }
    $md += ""

    $md += "## Arborescence"
    $md += ""
    $md += '```'
    $md += $TreeContent
    $md += '```'
    $md += ""

    if ($StatsContent) {
        $md += "## Statistiques"
        $md += ""
        $md += '```'
        $md += $StatsContent
        $md += '```'
    }

    $md += ""
    $md += "---"
    $md += "*Genere par [Arborescence Explorer](https://github.com/DrDiabelsBafian/arborescence-explorer) v5.0*"

    ($md -join "`r`n") | Out-File -FilePath $OutputFile -Encoding UTF8
}

# ====================================================================
# GUI - CREATION DE L'INTERFACE
# ====================================================================

$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width
$formHeight = [math]::Min(780, [int]($screenHeight * 0.88))
$formWidth = [math]::Min(700, [int]($screenWidth * 0.95))

$form = New-Object System.Windows.Forms.Form
$form.Text = "Arborescence Explorer v5.0 - by Dr. Diabels Bafian"
$form.Size = New-Object System.Drawing.Size($formWidth, $formHeight)
$form.MinimumSize = New-Object System.Drawing.Size(650, 550)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "Sizable"
$form.MaximizeBox = $true
$form.AutoScroll = $true
$form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi
$form.AutoScaleDimensions = New-Object System.Drawing.SizeF(96, 96)
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# Colors
$colorCyan = [System.Drawing.Color]::FromArgb(74, 158, 255)
$colorGreen = [System.Drawing.Color]::FromArgb(80, 250, 123)
$colorOrange = [System.Drawing.Color]::FromArgb(245, 166, 35)
$colorGray = [System.Drawing.Color]::FromArgb(100, 100, 100)
$colorDarkBg = [System.Drawing.Color]::FromArgb(40, 40, 40)

$currentY = 15

# === TITRE ===
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Location = New-Object System.Drawing.Point(20, $currentY)
$lblTitle.Size = New-Object System.Drawing.Size(620, 30)
$lblTitle.Text = "ARBORESCENCE EXPLORER"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = $colorCyan
$form.Controls.Add($lblTitle)
$currentY += 28

# === SOUS-TITRE ===
$lblSubtitle = New-Object System.Windows.Forms.Label
$lblSubtitle.Location = New-Object System.Drawing.Point(22, $currentY)
$lblSubtitle.Size = New-Object System.Drawing.Size(400, 15)
$lblSubtitle.Text = "v5.0 by Dr. Diabels Bafian | LLM-ready directory scanner"
$lblSubtitle.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$lblSubtitle.ForeColor = $colorGray
$form.Controls.Add($lblSubtitle)
$currentY += 22

# === SECTION : DOSSIER SOURCE ===
$grpSource = New-Object System.Windows.Forms.GroupBox
$grpSource.Location = New-Object System.Drawing.Point(20, $currentY)
$grpSource.Size = New-Object System.Drawing.Size(620, 70)
$grpSource.Text = "DOSSIER A SCANNER"
$grpSource.ForeColor = $colorCyan
$form.Controls.Add($grpSource)

$txtSource = New-Object System.Windows.Forms.TextBox
$txtSource.Location = New-Object System.Drawing.Point(15, 25)
$txtSource.Size = New-Object System.Drawing.Size(480, 25)
$txtSource.Text = $PSScriptRoot
$txtSource.BackColor = $colorDarkBg
$txtSource.ForeColor = [System.Drawing.Color]::White
$grpSource.Controls.Add($txtSource)

$btnBrowseSource = New-Object System.Windows.Forms.Button
$btnBrowseSource.Location = New-Object System.Drawing.Point(505, 23)
$btnBrowseSource.Size = New-Object System.Drawing.Size(100, 28)
$btnBrowseSource.Text = "Parcourir..."
$btnBrowseSource.BackColor = $colorDarkBg
$btnBrowseSource.FlatStyle = "Flat"
$grpSource.Controls.Add($btnBrowseSource)

$btnBrowseSource.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Choisir le dossier a scanner"
    $folderBrowser.SelectedPath = $txtSource.Text
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $txtSource.Text = $folderBrowser.SelectedPath
    }
})

$currentY += 80

# === SECTION : DESTINATION EXPORT ===
$grpDest = New-Object System.Windows.Forms.GroupBox
$grpDest.Location = New-Object System.Drawing.Point(20, $currentY)
$grpDest.Size = New-Object System.Drawing.Size(620, 110)
$grpDest.Text = "OU SAUVEGARDER L'EXPORT ?"
$grpDest.ForeColor = $colorCyan
$form.Controls.Add($grpDest)

$radDestFixed = New-Object System.Windows.Forms.RadioButton
$radDestFixed.Location = New-Object System.Drawing.Point(15, 22)
$radDestFixed.Size = New-Object System.Drawing.Size(580, 20)
$radDestFixed.Text = "Dossier Telechargements : C:\Users\$env:USERNAME\Downloads\"
$radDestFixed.Checked = $true
$radDestFixed.ForeColor = [System.Drawing.Color]::White
$grpDest.Controls.Add($radDestFixed)

$radDestBeside = New-Object System.Windows.Forms.RadioButton
$radDestBeside.Location = New-Object System.Drawing.Point(15, 44)
$radDestBeside.Size = New-Object System.Drawing.Size(580, 20)
$radDestBeside.Text = "A cote du dossier scanne (meme niveau)"
$radDestBeside.ForeColor = [System.Drawing.Color]::White
$grpDest.Controls.Add($radDestBeside)

$radDestInside = New-Object System.Windows.Forms.RadioButton
$radDestInside.Location = New-Object System.Drawing.Point(15, 66)
$radDestInside.Size = New-Object System.Drawing.Size(580, 20)
$radDestInside.Text = "Dans le dossier scanne (a la racine)"
$radDestInside.ForeColor = [System.Drawing.Color]::White
$grpDest.Controls.Add($radDestInside)

$radDestAsk = New-Object System.Windows.Forms.RadioButton
$radDestAsk.Location = New-Object System.Drawing.Point(15, 88)
$radDestAsk.Size = New-Object System.Drawing.Size(580, 20)
$radDestAsk.Text = "Me demander a chaque fois (fenetre Enregistrer sous)"
$radDestAsk.ForeColor = [System.Drawing.Color]::White
$grpDest.Controls.Add($radDestAsk)

$currentY += 115

# === SECTION : MODE + PROFONDEUR ===
$grpMode = New-Object System.Windows.Forms.GroupBox
$grpMode.Location = New-Object System.Drawing.Point(20, $currentY)
$grpMode.Size = New-Object System.Drawing.Size(300, 90)
$grpMode.Text = "QUE LISTER ?"
$grpMode.ForeColor = $colorCyan
$form.Controls.Add($grpMode)

$radModeFolders = New-Object System.Windows.Forms.RadioButton
$radModeFolders.Location = New-Object System.Drawing.Point(15, 22)
$radModeFolders.Size = New-Object System.Drawing.Size(270, 20)
$radModeFolders.Text = "Dossiers uniquement"
$radModeFolders.ForeColor = [System.Drawing.Color]::White
$grpMode.Controls.Add($radModeFolders)

$lblModeFoldersDesc = New-Object System.Windows.Forms.Label
$lblModeFoldersDesc.Location = New-Object System.Drawing.Point(32, 42)
$lblModeFoldersDesc.Size = New-Object System.Drawing.Size(250, 15)
$lblModeFoldersDesc.Text = "Structure des dossiers, sans les fichiers"
$lblModeFoldersDesc.ForeColor = $colorGray
$lblModeFoldersDesc.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpMode.Controls.Add($lblModeFoldersDesc)

$radModeComplete = New-Object System.Windows.Forms.RadioButton
$radModeComplete.Location = New-Object System.Drawing.Point(15, 58)
$radModeComplete.Size = New-Object System.Drawing.Size(270, 20)
$radModeComplete.Text = "Dossiers + Fichiers"
$radModeComplete.Checked = $true
$radModeComplete.ForeColor = [System.Drawing.Color]::White
$grpMode.Controls.Add($radModeComplete)

$grpDepth = New-Object System.Windows.Forms.GroupBox
$grpDepth.Location = New-Object System.Drawing.Point(340, $currentY)
$grpDepth.Size = New-Object System.Drawing.Size(300, 90)
$grpDepth.Text = "PROFONDEUR MAX"
$grpDepth.ForeColor = $colorCyan
$form.Controls.Add($grpDepth)

$numDepth = New-Object System.Windows.Forms.NumericUpDown
$numDepth.Location = New-Object System.Drawing.Point(15, 30)
$numDepth.Size = New-Object System.Drawing.Size(60, 25)
$numDepth.Minimum = 0
$numDepth.Maximum = 99
$numDepth.Value = 0
$numDepth.BackColor = $colorDarkBg
$numDepth.ForeColor = [System.Drawing.Color]::White
$grpDepth.Controls.Add($numDepth)

$lblDepthDesc = New-Object System.Windows.Forms.Label
$lblDepthDesc.Location = New-Object System.Drawing.Point(85, 33)
$lblDepthDesc.Size = New-Object System.Drawing.Size(200, 20)
$lblDepthDesc.Text = "niveaux (0 = illimite)"
$lblDepthDesc.ForeColor = [System.Drawing.Color]::White
$grpDepth.Controls.Add($lblDepthDesc)

$lblDepthHelp = New-Object System.Windows.Forms.Label
$lblDepthHelp.Location = New-Object System.Drawing.Point(15, 60)
$lblDepthHelp.Size = New-Object System.Drawing.Size(270, 20)
$lblDepthHelp.Text = "Limite les sous-dossiers scannes"
$lblDepthHelp.ForeColor = $colorGray
$lblDepthHelp.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpDepth.Controls.Add($lblDepthHelp)

$currentY += 100

# === SECTION : OPTIONS ===
$grpOptions = New-Object System.Windows.Forms.GroupBox
$grpOptions.Location = New-Object System.Drawing.Point(20, $currentY)
$grpOptions.Size = New-Object System.Drawing.Size(620, 100)
$grpOptions.Text = "OPTIONS"
$grpOptions.ForeColor = $colorCyan
$form.Controls.Add($grpOptions)

$chkMetadata = New-Object System.Windows.Forms.CheckBox
$chkMetadata.Location = New-Object System.Drawing.Point(15, 22)
$chkMetadata.Size = New-Object System.Drawing.Size(280, 20)
$chkMetadata.Text = "Metadonnees fichiers (poids, dates)"
$chkMetadata.Checked = $true
$chkMetadata.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkMetadata)

$chkStats = New-Object System.Windows.Forms.CheckBox
$chkStats.Location = New-Object System.Drawing.Point(320, 22)
$chkStats.Size = New-Object System.Drawing.Size(280, 20)
$chkStats.Text = "Stats globales (Top 10, extensions)"
$chkStats.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkStats)

$chkExclusions = New-Object System.Windows.Forms.CheckBox
$chkExclusions.Location = New-Object System.Drawing.Point(15, 48)
$chkExclusions.Size = New-Object System.Drawing.Size(280, 20)
$chkExclusions.Text = "Ignorer .git, node_modules, cache..."
$chkExclusions.Checked = $true
$chkExclusions.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkExclusions)

$chkClipboard = New-Object System.Windows.Forms.CheckBox
$chkClipboard.Location = New-Object System.Drawing.Point(320, 48)
$chkClipboard.Size = New-Object System.Drawing.Size(280, 20)
$chkClipboard.Text = "Copier dans presse-papier"
$chkClipboard.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkClipboard)

$lblExclHelp = New-Object System.Windows.Forms.Label
$lblExclHelp.Location = New-Object System.Drawing.Point(32, 72)
$lblExclHelp.Size = New-Object System.Drawing.Size(560, 15)
$lblExclHelp.Text = "Exclut : .git, node_modules, __pycache__, .vs, .vscode, bin, obj, .idea, vendor, packages, .next, dist, .cache"
$lblExclHelp.ForeColor = $colorGray
$lblExclHelp.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpOptions.Controls.Add($lblExclHelp)

$currentY += 105

# === SECTION : FFPROBE (optionnel) ===
$grpMedia = New-Object System.Windows.Forms.GroupBox
$grpMedia.Location = New-Object System.Drawing.Point(20, $currentY)
$grpMedia.Size = New-Object System.Drawing.Size(620, 50)
$grpMedia.Text = "ANALYSE MEDIA (optionnel)"
$grpMedia.ForeColor = $colorOrange
$form.Controls.Add($grpMedia)

$chkMedia = New-Object System.Windows.Forms.CheckBox
$chkMedia.Location = New-Object System.Drawing.Point(15, 22)
$chkMedia.Size = New-Object System.Drawing.Size(370, 20)
$chkMedia.Text = "Analyse video/audio (duree, resolution, codec)"
$chkMedia.Enabled = $script:HasFFprobe
$chkMedia.ForeColor = if ($script:HasFFprobe) { [System.Drawing.Color]::White } else { $colorGray }
$grpMedia.Controls.Add($chkMedia)

$lblMediaStatus = New-Object System.Windows.Forms.Label
$lblMediaStatus.Location = New-Object System.Drawing.Point(400, 24)
$lblMediaStatus.Size = New-Object System.Drawing.Size(200, 16)
$lblMediaStatus.Text = if ($script:HasFFprobe) { "FFprobe detecte" } else { "FFprobe absent (optionnel)" }
$lblMediaStatus.ForeColor = if ($script:HasFFprobe) { $colorGreen } else { $colorGray }
$lblMediaStatus.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpMedia.Controls.Add($lblMediaStatus)

$currentY += 58

# === SECTION : FORMAT EXPORT ===
$grpExport = New-Object System.Windows.Forms.GroupBox
$grpExport.Location = New-Object System.Drawing.Point(20, $currentY)
$grpExport.Size = New-Object System.Drawing.Size(620, 55)
$grpExport.Text = "FORMAT EXPORT"
$grpExport.ForeColor = $colorCyan
$form.Controls.Add($grpExport)

$chkExportTXT = New-Object System.Windows.Forms.CheckBox
$chkExportTXT.Location = New-Object System.Drawing.Point(15, 22)
$chkExportTXT.Size = New-Object System.Drawing.Size(180, 20)
$chkExportTXT.Text = "TXT (brut, LLM-ready)"
$chkExportTXT.Checked = $true
$chkExportTXT.ForeColor = [System.Drawing.Color]::White
$grpExport.Controls.Add($chkExportTXT)

$chkExportMD = New-Object System.Windows.Forms.CheckBox
$chkExportMD.Location = New-Object System.Drawing.Point(220, 22)
$chkExportMD.Size = New-Object System.Drawing.Size(250, 20)
$chkExportMD.Text = "Markdown (GitHub, tokens)"
$chkExportMD.Checked = $true
$chkExportMD.ForeColor = [System.Drawing.Color]::White
$grpExport.Controls.Add($chkExportMD)

$currentY += 65

# === STATUS + PROGRESS ===
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(20, $currentY)
$lblStatus.Size = New-Object System.Drawing.Size(620, 20)
$lblStatus.Text = "Pret"
$lblStatus.ForeColor = $colorGray
$form.Controls.Add($lblStatus)

$currentY += 25

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, $currentY)
$progressBar.Size = New-Object System.Drawing.Size(620, 20)
$progressBar.Style = "Marquee"
$progressBar.MarqueeAnimationSpeed = 0
$form.Controls.Add($progressBar)

$currentY += 30

# === TOKEN INFO ===
$lblTokenInfo = New-Object System.Windows.Forms.Label
$lblTokenInfo.Location = New-Object System.Drawing.Point(20, $currentY)
$lblTokenInfo.Size = New-Object System.Drawing.Size(620, 20)
$lblTokenInfo.Text = ""
$lblTokenInfo.ForeColor = $colorCyan
$lblTokenInfo.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($lblTokenInfo)

$currentY += 30

# === BOUTONS ===
$btnLaunch = New-Object System.Windows.Forms.Button
$btnLaunch.Location = New-Object System.Drawing.Point(200, $currentY)
$btnLaunch.Size = New-Object System.Drawing.Size(180, 40)
$btnLaunch.Text = "LANCER LE SCAN"
$btnLaunch.BackColor = $colorGreen
$btnLaunch.ForeColor = [System.Drawing.Color]::Black
$btnLaunch.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnLaunch.FlatStyle = "Flat"
$form.Controls.Add($btnLaunch)

$btnCancel = New-Object System.Windows.Forms.Button
$btnCancel.Location = New-Object System.Drawing.Point(400, $currentY)
$btnCancel.Size = New-Object System.Drawing.Size(100, 40)
$btnCancel.Text = "Fermer"
$btnCancel.BackColor = $colorDarkBg
$btnCancel.FlatStyle = "Flat"
$form.Controls.Add($btnCancel)

$btnCancel.Add_Click({ $form.Close() })

# ====================================================================
# LOGIQUE DU BOUTON LANCER
# ====================================================================

$btnLaunch.Add_Click({
    $sourcePath = $txtSource.Text
    if (-not (Test-Path $sourcePath)) {
        [void][System.Windows.Forms.MessageBox]::Show("Le dossier source n'existe pas!", "Erreur", "OK", "Error")
        return
    }

    # Determine destination
    $folderName = (Split-Path $sourcePath -Leaf) -replace '[^a-zA-Z0-9\-_]', ''
    $dateStamp = Get-Date -Format "dd-MM-yy"
    $baseFileName = "EXPORT_Arborescence-$folderName`_$dateStamp"

    if ($radDestFixed.Checked) {
        $destPath = "$env:USERPROFILE\Downloads"
        if (-not (Test-Path $destPath)) { [void](New-Item -ItemType Directory -Path $destPath -Force) }
    } elseif ($radDestBeside.Checked) {
        $destPath = Split-Path $sourcePath -Parent
    } elseif ($radDestInside.Checked) {
        $destPath = $sourcePath
    } else {
        $saveDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $saveDialog.Description = "Choisir le dossier de destination"
        if ($saveDialog.ShowDialog() -ne "OK") { return }
        $destPath = $saveDialog.SelectedPath
    }

    # Version increment
    $version = 1
    while (Test-Path (Join-Path $destPath "$baseFileName`_V$version.txt")) { $version++ }
    $baseFileName = "$baseFileName`_V$version"

    # Build options
    $options = @{
        Mode = if ($radModeComplete.Checked) { "COMPLET" } else { "DOSSIERS" }
        MaxDepth = [int]$numDepth.Value
        ShowMetadata = $chkMetadata.Checked
        ShowStats = $chkStats.Checked
        UseExclusions = $chkExclusions.Checked
        AnalyzeMedia = $chkMedia.Checked
    }

    # Start scan
    $btnLaunch.Enabled = $false
    $progressBar.MarqueeAnimationSpeed = 30
    $lblStatus.Text = "Scan en cours..."
    $lblTokenInfo.Text = ""
    [System.Windows.Forms.Application]::DoEvents()

    try {
        # Build header
        $Output = @()
        $Output += "=========================================="
        $ModeDisplay = if ($options.Mode -eq 'DOSSIERS') { 'DOSSIERS UNIQUEMENT' } else { 'COMPLETE' }
        $Output += "ARBORESCENCE - $ModeDisplay"
        $Output += "Genere le : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
        $Output += "Racine : $sourcePath"
        if ($options.ShowMetadata) { $Output += "+ Metadonnees fichiers" }
        if ($options.AnalyzeMedia) { $Output += "+ Analyse video/audio (FFprobe)" }
        $DepthDisplay = if ($options.MaxDepth -eq 0) { 'Illimitee' } else { "$($options.MaxDepth) niveaux" }
        $Output += "Profondeur : $DepthDisplay"
        $Output += "=========================================="
        $Output += ""

        # Get tree
        $TreeLines = Get-Tree -Path $sourcePath -Options $options -StatusLabel $lblStatus
        $Output += $TreeLines

        # Statistics
        $StatsLines = @()
        if ($options.ShowStats) {
            $StatsLines = Get-Statistics -Path $sourcePath -ShowStats $true
        } else {
            $StatsLines = Get-Statistics -Path $sourcePath -ShowStats $false
        }
        $Output += $StatsLines

        $Output += ""
        $Output += "=========================================="
        $Output += "FIN DU RAPPORT"
        $Output += "=========================================="

        $FullContent = $Output -join "`r`n"
        $TreeContent = $TreeLines -join "`r`n"
        $StatsContent = $StatsLines -join "`r`n"

        # Token estimation
        $tokenCount = Get-TokenEstimate $FullContent
        $tokenFormatted = Format-TokenCount $tokenCount

        # Context window check
        $claudeOk = if ($tokenCount -le 160000) { "Claude OK" } else { "Claude LIMITE" }
        $gptOk = if ($tokenCount -le 100000) { "GPT-4o OK" } else { "GPT-4o LIMITE" }
        $lblTokenInfo.Text = "~$tokenFormatted tokens | $claudeOk | $gptOk"
        $lblTokenInfo.ForeColor = if ($tokenCount -le 100000) { $colorGreen } elseif ($tokenCount -le 160000) { $colorOrange } else { [System.Drawing.Color]::Red }

        # Add token info to TXT output
        $tokenLine = "`r`nTokens estimes : ~$tokenFormatted (~$tokenCount tokens)"
        $FullContent += $tokenLine

        # Export TXT
        $exportedFiles = @()
        if ($chkExportTXT.Checked) {
            $txtFile = Join-Path $destPath "$baseFileName.txt"
            $FullContent | Out-File -FilePath $txtFile -Encoding UTF8
            $exportedFiles += $txtFile
        }

        # Export Markdown
        if ($chkExportMD.Checked) {
            $mdFile = Join-Path $destPath "$baseFileName.md"
            Export-Markdown -TreeContent $TreeContent -StatsContent $StatsContent -Title "Arborescence - $folderName" -SourcePath $sourcePath -Options $options -TokenCount $tokenCount -OutputFile $mdFile
            $exportedFiles += $mdFile
        }

        # Clipboard
        if ($chkClipboard.Checked) {
            $FullContent | Set-Clipboard
        }

        # Done
        $progressBar.MarqueeAnimationSpeed = 0
        $lblStatus.Text = "Termine! $($exportedFiles.Count) fichier(s) | ~$tokenFormatted tokens"

        # Open destination
        Start-Process explorer.exe -ArgumentList $destPath

        $filesMsg = $exportedFiles -join "`n"
        [void][System.Windows.Forms.MessageBox]::Show("Export termine!`n`n$filesMsg`n`nTokens estimes : ~$tokenFormatted", "Succes", "OK", "Information")

    } catch {
        [void][System.Windows.Forms.MessageBox]::Show("Erreur: $($_.Exception.Message)", "Erreur", "OK", "Error")
    } finally {
        $btnLaunch.Enabled = $true
        $progressBar.MarqueeAnimationSpeed = 0
    }
})

# ====================================================================
# LANCEMENT
# ====================================================================

[void]$form.ShowDialog()
