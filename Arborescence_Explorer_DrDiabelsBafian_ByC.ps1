# ====================================================================
# SCRIPT : Arborescence Explorer v6.0.0 - International Edition
# AUTEUR : Claude pour Fabian (Dr. Diabels Bafian)
# USAGE  : Double-cliquer sur Arborescence_Explorer.bat
# REPO   : github.com/DrDiabelsBafian/Arborescence_Explorer
# ====================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Fix DPI for sharpness on high-resolution screens
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
# LANGUAGE SYSTEM
# ====================================================================

$script:CurrentLang = "EN"

$script:Strings = @{
    EN = @{
        # Window
        WindowTitle        = "Arborescence Explorer v6.0.0 - by Dr. Diabels Bafian"
        Subtitle           = "v6.0.0 by Dr. Diabels Bafian | LLM-ready directory scanner"
        # Source
        GrpSource          = "FOLDER TO SCAN"
        BtnBrowse          = "Browse..."
        BrowseDesc         = "Choose a folder to scan"
        DragHint           = "or drag & drop a folder here"
        # Destination
        GrpDest            = "WHERE TO SAVE THE EXPORT?"
        DestDownloads      = "Downloads folder: C:\Users\{0}\Downloads\"
        DestBeside         = "Next to the scanned folder (same level)"
        DestInside         = "Inside the scanned folder (at root)"
        DestAsk            = "Ask me every time (Save As dialog)"
        # Mode
        GrpMode            = "WHAT TO LIST?"
        ModeFolders        = "Folders only"
        ModeFoldersDesc    = "Folder structure, no files"
        ModeComplete       = "Folders + Files"
        # Depth
        GrpDepth           = "MAX DEPTH"
        DepthDesc          = "levels (0 = unlimited)"
        DepthHelp          = "Limits scanned subfolders"
        # Options
        GrpOptions         = "OPTIONS"
        OptMetadata        = "File metadata (size, dates)"
        OptStats           = "Global stats (Top 10, extensions)"
        OptExclusions      = "Ignore .git, node_modules, cache..."
        OptClipboard       = "Copy to clipboard"
        OptGitignore       = "Read .gitignore (if present)"
        OptExtFilter       = "Filter extensions:"
        OptExtHelp         = "Ex: .py,.js,.md (empty = all)"
        OptExclHelp        = "Excludes: .git, node_modules, __pycache__,`n.vs, bin, obj, vendor, .next, dist, .cache"
        # Packing
        GrpPacking         = "LLM CONTENT PACKING (Repomix-style)"
        OptContents        = "Include text file contents"
        PackingHelp        = "Max 100KB/file | Text only"
        # Media
        GrpMedia           = "MEDIA ANALYSIS (optional)"
        OptMedia           = "Video/audio analysis (duration, resolution, codec)"
        MediaDetected      = "FFprobe detected"
        MediaAbsent        = "FFprobe absent (optional)"
        # Export
        GrpExport          = "EXPORT FORMAT"
        ExportTXT          = "TXT (raw, LLM-ready)"
        ExportMD           = "Markdown (GitHub, tokens)"
        # Status
        StatusReady        = "Ready"
        StatusScanning     = "Scanning..."
        StatusPacking      = "Packing file contents..."
        StatusDone         = "Done! {0} file(s) | ~{1} tokens"
        # Buttons
        BtnLaunch          = "START SCAN"
        BtnClose           = "Close"
        # Messages
        MsgNoFolder        = "Source folder does not exist!"
        MsgError           = "Error"
        MsgSuccess         = "Success"
        MsgExportDone      = "Export complete!`n`n{0}`n`nEstimated tokens: ~{1}"
        MsgChooseDest      = "Choose destination folder"
        # Scan labels
        ScanPrefix         = "Scan: "
        PackPrefix         = "Packing: "
        # Export content strings
        ExpTreeHeader      = "DIRECTORY TREE"
        ExpFoldersOnly     = "FOLDERS ONLY"
        ExpComplete        = "COMPLETE"
        ExpGenerated       = "Generated on"
        ExpRoot            = "Root"
        ExpMetadata        = "+ File metadata"
        ExpMediaAnalysis   = "+ Video/audio analysis (FFprobe)"
        ExpContentPacking  = "+ Text file contents (Repomix-style)"
        ExpExtFilter       = "Extension filter"
        ExpDepth           = "Depth"
        ExpUnlimited       = "Unlimited"
        ExpLevels          = "levels"
        ExpEndReport       = "END OF REPORT"
        ExpTokens          = "Estimated tokens"
        ExpFilesIncluded   = "files included"
        ExpTokensContent   = "tokens of content"
        ExpAccessDenied    = "[Access denied]"
        ExpMaxDepth        = "[...max depth reached...]"
        ExpFileTooLarge    = "[File too large: {0} > {1}KB max]"
        ExpFileEmpty       = "[Empty file]"
        ExpReadError       = "[Read error: {0}]"
        # Metadata labels
        MetaSize           = "Size"
        MetaCreated        = "Created"
        MetaModified       = "Modified"
        MetaAudio          = "Audio"
        # Stats
        StatTitle          = "STATISTICS"
        StatFolders        = "Folders"
        StatFiles          = "Files"
        StatTotalSize      = "Total size"
        StatByExtension    = "--- By extension ---"
        StatNoExt          = "(no ext)"
        StatTop10          = "--- Top 10 largest files ---"
        StatError          = "[Error calculating stats]"
        # File size units
        UnitB              = "B"
        UnitKB             = "KB"
        UnitMB             = "MB"
        UnitGB             = "GB"
        # Markdown export
        MdInfo             = "Info"
        MdValue            = "Value"
        MdGeneratedOn      = "Generated on"
        MdRoot             = "Root"
        MdMode             = "Mode"
        MdModeFolders      = "Folders only"
        MdModeComplete     = "Folders + Files"
        MdDepth            = "Depth"
        MdDepthUnlimited   = "Unlimited"
        MdDepthLevels      = "{0} levels"
        MdTokens           = "Estimated tokens"
        MdFilesIncluded    = "Text files included"
        MdContextTitle     = "LLM Context Window Compatibility"
        MdModel            = "Model"
        MdLimit            = "Limit"
        MdUsage            = "Usage"
        MdStatus           = "Status"
        MdStatusOK         = "OK"
        MdStatusLimit      = "LIMIT"
        MdStatusExceeded   = "EXCEEDED"
        MdTreeSection      = "Directory Tree"
        MdStatsSection     = "Statistics"
        MdContentsSection  = "File Contents"
        MdFooter           = "Generated by"
        # Token info
        TokenClaudeOK      = "Claude OK"
        TokenClaudeLimit   = "Claude LIMIT"
        TokenGptOK         = "GPT-4o OK"
        TokenGptLimit      = "GPT-4o LIMIT"
        TokenFiles         = "files"
        # GitHub link
        GithubLink         = "github.com/DrDiabelsBafian/Arborescence_Explorer"
    }
    FR = @{
        WindowTitle        = "Arborescence Explorer v6.0.0 - by Dr. Diabels Bafian"
        Subtitle           = "v6.0.0 by Dr. Diabels Bafian | Scanneur d'arborescence pour LLM"
        GrpSource          = "DOSSIER A SCANNER"
        BtnBrowse          = "Parcourir..."
        BrowseDesc         = "Choisir le dossier a scanner"
        DragHint           = "ou glissez-deposez un dossier ici"
        GrpDest            = "OU SAUVEGARDER L'EXPORT ?"
        DestDownloads      = "Dossier Telechargements : C:\Users\{0}\Downloads\"
        DestBeside         = "A cote du dossier scanne (meme niveau)"
        DestInside         = "Dans le dossier scanne (a la racine)"
        DestAsk            = "Me demander a chaque fois (fenetre Enregistrer sous)"
        GrpMode            = "QUE LISTER ?"
        ModeFolders        = "Dossiers uniquement"
        ModeFoldersDesc    = "Structure des dossiers, sans les fichiers"
        ModeComplete       = "Dossiers + Fichiers"
        GrpDepth           = "PROFONDEUR MAX"
        DepthDesc          = "niveaux (0 = illimite)"
        DepthHelp          = "Limite les sous-dossiers scannes"
        GrpOptions         = "OPTIONS"
        OptMetadata        = "Metadonnees fichiers (poids, dates)"
        OptStats           = "Stats globales (Top 10, extensions)"
        OptExclusions      = "Ignorer .git, node_modules, cache..."
        OptClipboard       = "Copier dans presse-papier"
        OptGitignore       = "Lire .gitignore (si present)"
        OptExtFilter       = "Filtrer extensions:"
        OptExtHelp         = "Ex: .py,.js,.md (vide = tout)"
        OptExclHelp        = "Exclut: .git, node_modules, __pycache__,`n.vs, bin, obj, vendor, .next, dist, .cache"
        GrpPacking         = "LLM CONTENT PACKING (Repomix-style)"
        OptContents        = "Inclure le contenu des fichiers texte"
        PackingHelp        = "Max 100Ko/fichier | Texte seulement"
        GrpMedia           = "ANALYSE MEDIA (optionnel)"
        OptMedia           = "Analyse video/audio (duree, resolution, codec)"
        MediaDetected      = "FFprobe detecte"
        MediaAbsent        = "FFprobe absent (optionnel)"
        GrpExport          = "FORMAT EXPORT"
        ExportTXT          = "TXT (brut, LLM-ready)"
        ExportMD           = "Markdown (GitHub, tokens)"
        StatusReady        = "Pret"
        StatusScanning     = "Scan en cours..."
        StatusPacking      = "Inclusion du contenu..."
        StatusDone         = "Termine! {0} fichier(s) | ~{1} tokens"
        BtnLaunch          = "LANCER LE SCAN"
        BtnClose           = "Fermer"
        MsgNoFolder        = "Le dossier source n'existe pas!"
        MsgError           = "Erreur"
        MsgSuccess         = "Succes"
        MsgExportDone      = "Export termine!`n`n{0}`n`nTokens estimes : ~{1}"
        MsgChooseDest      = "Choisir le dossier de destination"
        ScanPrefix         = "Scan: "
        PackPrefix         = "Packing: "
        ExpTreeHeader      = "ARBORESCENCE"
        ExpFoldersOnly     = "DOSSIERS UNIQUEMENT"
        ExpComplete        = "COMPLETE"
        ExpGenerated       = "Genere le"
        ExpRoot            = "Racine"
        ExpMetadata        = "+ Metadonnees fichiers"
        ExpMediaAnalysis   = "+ Analyse video/audio (FFprobe)"
        ExpContentPacking  = "+ Contenu fichiers texte (Repomix-style)"
        ExpExtFilter       = "Filtre extensions"
        ExpDepth           = "Profondeur"
        ExpUnlimited       = "Illimitee"
        ExpLevels          = "niveaux"
        ExpEndReport       = "FIN DU RAPPORT"
        ExpTokens          = "Tokens estimes"
        ExpFilesIncluded   = "fichiers inclus"
        ExpTokensContent   = "tokens de contenu"
        ExpAccessDenied    = "[Acces refuse]"
        ExpMaxDepth        = "[...profondeur max atteinte...]"
        ExpFileTooLarge    = "[Fichier trop gros: {0} > {1}Ko max]"
        ExpFileEmpty       = "[Fichier vide]"
        ExpReadError       = "[Erreur lecture: {0}]"
        MetaSize           = "Poids"
        MetaCreated        = "Cree"
        MetaModified       = "Modif"
        MetaAudio          = "Audio"
        StatTitle          = "STATISTIQUES"
        StatFolders        = "Dossiers"
        StatFiles          = "Fichiers"
        StatTotalSize      = "Taille totale"
        StatByExtension    = "--- Repartition par extension ---"
        StatNoExt          = "(sans ext)"
        StatTop10          = "--- Top 10 plus gros fichiers ---"
        StatError          = "[Erreur lors du calcul des stats]"
        UnitB              = "o"
        UnitKB             = "Ko"
        UnitMB             = "Mo"
        UnitGB             = "Go"
        MdInfo             = "Info"
        MdValue            = "Valeur"
        MdGeneratedOn      = "Genere le"
        MdRoot             = "Racine"
        MdMode             = "Mode"
        MdModeFolders      = "Dossiers uniquement"
        MdModeComplete     = "Dossiers + Fichiers"
        MdDepth            = "Profondeur"
        MdDepthUnlimited   = "Illimitee"
        MdDepthLevels      = "{0} niveaux"
        MdTokens           = "Tokens estimes"
        MdFilesIncluded    = "Fichiers texte inclus"
        MdContextTitle     = "Compatibilite fenetres contexte LLM"
        MdModel            = "Modele"
        MdLimit            = "Limite"
        MdUsage            = "Usage"
        MdStatus           = "Statut"
        MdStatusOK         = "OK"
        MdStatusLimit      = "LIMITE"
        MdStatusExceeded   = "DEPASSE"
        MdTreeSection      = "Arborescence"
        MdStatsSection     = "Statistiques"
        MdContentsSection  = "Contenu des fichiers"
        MdFooter           = "Genere par"
        TokenClaudeOK      = "Claude OK"
        TokenClaudeLimit   = "Claude LIMITE"
        TokenGptOK         = "GPT-4o OK"
        TokenGptLimit      = "GPT-4o LIMITE"
        TokenFiles         = "fichiers"
        GithubLink         = "github.com/DrDiabelsBafian/Arborescence_Explorer"
    }
}

function Get-Str {
    param ([string]$Key)
    $val = $script:Strings[$script:CurrentLang][$Key]
    if ($null -eq $val) { return $Key }
    return $val
}

# ====================================================================
# TOOL DETECTION
# ====================================================================

function Test-CommandExists {
    param ([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

$script:HasFFprobe = Test-CommandExists "ffprobe"

# ====================================================================
# UTILITY FUNCTIONS
# ====================================================================

function Format-FileSize {
    param ([long]$Size)
    if ($Size -eq 0) { return "0 $(Get-Str 'UnitB')" }
    if ($Size -ge 1GB) { return "{0:N2} {1}" -f ($Size / 1GB), (Get-Str 'UnitGB') }
    if ($Size -ge 1MB) { return "{0:N2} {1}" -f ($Size / 1MB), (Get-Str 'UnitMB') }
    if ($Size -ge 1KB) { return "{0:N2} {1}" -f ($Size / 1KB), (Get-Str 'UnitKB') }
    return "$Size $(Get-Str 'UnitB')"
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
# FFPROBE FUNCTIONS (VIDEO/AUDIO)
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
        $parts += (Get-Str 'MetaAudio') + ": " + ($MediaInfo.AudioTracks -join ", ")
    }

    return $parts -join " | "
}

# ====================================================================
# EXCLUSION FUNCTIONS
# ====================================================================

$script:Exclusions = @('.git', 'node_modules', '__pycache__', '$RECYCLE.BIN', '.vs', '.vscode', 'bin', 'obj', '.idea', 'vendor', 'packages', '.next', 'dist', '.cache', '.tmp')
$script:GitignorePatterns = @()

function Read-Gitignore {
    param ([string]$RootPath)
    $gitignorePath = Join-Path $RootPath ".gitignore"
    if (-not (Test-Path $gitignorePath)) { return @() }
    $patterns = @()
    Get-Content $gitignorePath -ErrorAction SilentlyContinue | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith('#')) {
            $clean = $line.TrimEnd('/').TrimStart('/')
            if ($clean) { $patterns += $clean }
        }
    }
    return $patterns
}

function Test-Excluded {
    param ([string]$Name, [bool]$UseExclusions, [string]$RelativePath = "")
    if ($UseExclusions) {
        if ($script:Exclusions -contains $Name) { return $true }
    }
    foreach ($pattern in $script:GitignorePatterns) {
        if ($Name -like $pattern) { return $true }
        if ($RelativePath -and $RelativePath -like $pattern) { return $true }
    }
    return $false
}

# ====================================================================
# TEXT EXTENSIONS (for content packing)
# ====================================================================

$script:TextExtensions = @(
    '.ps1', '.bat', '.cmd', '.sh', '.bash',
    '.py', '.js', '.ts', '.jsx', '.tsx', '.mjs', '.cjs',
    '.cs', '.java', '.go', '.rs', '.rb', '.php', '.swift', '.kt',
    '.c', '.cpp', '.h', '.hpp',
    '.html', '.htm', '.css', '.scss', '.sass', '.less',
    '.json', '.xml', '.yaml', '.yml', '.toml', '.ini', '.cfg', '.conf',
    '.md', '.txt', '.rst', '.log', '.csv', '.tsv',
    '.sql', '.graphql', '.proto',
    '.dockerfile', '.env', '.gitignore', '.editorconfig',
    '.vue', '.svelte', '.astro'
)

function Test-TextFile {
    param ([string]$Extension, [string]$Name)
    $ext = $Extension.ToLower()
    if ($script:TextExtensions -contains $ext) { return $true }
    $textNames = @('Dockerfile', 'Makefile', 'Rakefile', 'Gemfile', 'LICENSE', 'README', 'CHANGELOG', 'CONTRIBUTING')
    if ($textNames -contains $Name) { return $true }
    return $false
}

function Get-FileContent {
    param ([string]$FilePath, [int]$MaxSizeKB = 100)
    try {
        $fileSize = (Get-Item $FilePath).Length
        if ($fileSize -gt ($MaxSizeKB * 1024)) {
            return (Get-Str 'ExpFileTooLarge') -f (Format-FileSize $fileSize), $MaxSizeKB
        }
        $content = Get-Content $FilePath -Raw -ErrorAction Stop -Encoding UTF8
        if (-not $content) { return (Get-Str 'ExpFileEmpty') }
        return $content.TrimEnd()
    } catch {
        return (Get-Str 'ExpReadError') -f $_.Exception.Message
    }
}

# ====================================================================
# KNOWN EXTENSIONS
# ====================================================================

$script:VideoExtensions = @('.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv', '.webm', '.m4v', '.mpeg', '.mpg')
$script:AudioExtensions = @('.mp3', '.wav', '.flac', '.aac', '.ogg', '.wma', '.m4a', '.opus')

# ====================================================================
# MAIN FUNCTION: GET-TREE
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
        $StatusLabel.Text = (Get-Str 'ScanPrefix') + $FolderName
        [System.Windows.Forms.Application]::DoEvents()
    }

    if ($Options.MaxDepth -gt 0 -and $CurrentDepth -ge $Options.MaxDepth) {
        $Output += "$Indent    $(Get-Str 'ExpMaxDepth')"
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

            # Extension filter
            if ($Options.ExtensionFilter -and $Options.ExtensionFilter.Count -gt 0) {
                $Files = $Files | Where-Object { $Options.ExtensionFilter -contains $_.Extension.ToLower() }
            }

            foreach ($File in $Files) {
                $FileIndent = "  " * ($Level + 1)
                $ext = $File.Extension.ToLower()
                $tokenInfo = ""

                if ($Options.ShowMetadata) {
                    $FilePoids = Format-FileSize $File.Length
                    $FileCree = $File.CreationTime.ToString('dd/MM/yyyy HH:mm')
                    $FileModif = $File.LastWriteTime.ToString('dd/MM/yyyy HH:mm')

                    if ($Options.IncludeContents -and (Test-TextFile $ext $File.Name)) {
                        $fileTokens = Get-TokenEstimate (Get-Content $File.FullName -Raw -ErrorAction SilentlyContinue -Encoding UTF8)
                        $tokenInfo = " | ~$(Format-TokenCount $fileTokens) tokens"
                    }

                    $Output += "$FileIndent+-- $($File.Name)"
                    $Output += "$FileIndent    $(Get-Str 'MetaSize'): $FilePoids | $(Get-Str 'MetaCreated'): $FileCree | $(Get-Str 'MetaModified'): $FileModif$tokenInfo"
                } else {
                    $Output += "$FileIndent+-- $($File.Name)"
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
        $Output += "$Indent    $(Get-Str 'ExpAccessDenied')"
    }

    return $Output
}

# ====================================================================
# STATISTICS
# ====================================================================

function Get-Statistics {
    param ([string]$Path, [bool]$ShowStats)

    $Stats = @()
    $Stats += ""
    $Stats += "=========================================="
    $Stats += (Get-Str 'StatTitle')
    $Stats += "=========================================="

    try {
        $AllItems = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue
        $Folders = $AllItems | Where-Object { $_.PSIsContainer }
        $Files = $AllItems | Where-Object { -not $_.PSIsContainer }

        $TotalSize = ($Files | Measure-Object -Property Length -Sum).Sum

        $Stats += "$(Get-Str 'StatFolders')     : $($Folders.Count)"
        $Stats += "$(Get-Str 'StatFiles')     : $($Files.Count)"
        $Stats += "$(Get-Str 'StatTotalSize'): $(Format-FileSize $TotalSize)"

        if ($ShowStats -and $Files.Count -gt 0) {
            $Stats += ""
            $Stats += (Get-Str 'StatByExtension')
            $ExtStats = $Files | Group-Object Extension | Sort-Object Count -Descending | Select-Object -First 10
            foreach ($Ext in $ExtStats) {
                $ExtName = if ($Ext.Name -eq "") { (Get-Str 'StatNoExt') } else { $Ext.Name }
                $ExtSize = ($Ext.Group | Measure-Object -Property Length -Sum).Sum
                $filesWord = Get-Str 'StatFiles'
                $Stats += "  $($ExtName.PadRight(12)) : $($Ext.Count.ToString().PadLeft(5)) $filesWord  $(Format-FileSize $ExtSize)"
            }

            $Stats += ""
            $Stats += (Get-Str 'StatTop10')
            $TopFiles = $Files | Sort-Object Length -Descending | Select-Object -First 10
            $i = 1
            foreach ($F in $TopFiles) {
                $RelPath = $F.FullName.Replace($Path, "").TrimStart("\")
                $Stats += "  $i. $(Format-FileSize $F.Length) - $RelPath"
                $i++
            }
        }
    } catch {
        $Stats += (Get-Str 'StatError')
    }

    return $Stats
}

# ====================================================================
# FILE CONTENT PACKING (Repomix-style)
# ====================================================================

function Get-PackedContents {
    param (
        [string]$Path,
        [hashtable]$Options,
        [System.Windows.Forms.Label]$StatusLabel
    )

    $Packed = @()
    $FileCount = 0
    $TotalTokens = 0

    $allFiles = Get-ChildItem -Path $Path -File -Recurse -ErrorAction SilentlyContinue | Sort-Object FullName

    foreach ($file in $allFiles) {
        $relativePath = $file.FullName.Replace($Path, "").TrimStart("\")
        $ext = $file.Extension.ToLower()

        # Check exclusions on directory parts
        $parts = $relativePath -split '\\'
        $skip = $false
        if ($parts.Count -gt 1) {
            foreach ($part in $parts[0..($parts.Count - 2)]) {
                if (Test-Excluded $part $Options.UseExclusions) { $skip = $true; break }
            }
        }
        # Also check filename against gitignore patterns
        if (-not $skip) {
            foreach ($pattern in $script:GitignorePatterns) {
                if ($file.Name -like $pattern) { $skip = $true; break }
            }
        }
        if ($skip) { continue }

        # Extension filter
        if ($Options.ExtensionFilter -and $Options.ExtensionFilter.Count -gt 0) {
            if (-not ($Options.ExtensionFilter -contains $ext)) { continue }
        }

        # Only text files
        if (-not (Test-TextFile $ext $file.Name)) { continue }

        if ($StatusLabel) {
            $StatusLabel.Text = (Get-Str 'PackPrefix') + $file.Name
            [System.Windows.Forms.Application]::DoEvents()
        }

        $content = Get-FileContent -FilePath $file.FullName -MaxSizeKB 100
        $fileTokens = Get-TokenEstimate $content

        $Packed += ""
        $Packed += "================================================================"
        $Packed += "FILE: $relativePath (~$(Format-TokenCount $fileTokens) tokens)"
        $Packed += "================================================================"
        $Packed += $content

        $FileCount++
        $TotalTokens += $fileTokens
    }

    return @{
        Content = $Packed
        FileCount = $FileCount
        TotalTokens = $TotalTokens
    }
}

# ====================================================================
# EXPORT MARKDOWN
# ====================================================================

function Export-Markdown {
    param (
        [string]$TreeContent,
        [string]$StatsContent,
        [string]$PackedContent,
        [string]$Title,
        [string]$SourcePath,
        [hashtable]$Options,
        [int]$TokenCount,
        [int]$PackedFiles,
        [string]$OutputFile
    )

    $md = @()
    $md += "# $Title"
    $md += ""
    $md += "| $(Get-Str 'MdInfo') | $(Get-Str 'MdValue') |"
    $md += "|------|--------|"
    $md += "| $(Get-Str 'MdGeneratedOn') | $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss') |"
    $md += "| $(Get-Str 'MdRoot') | ``$SourcePath`` |"
    $ModeDisplay = if ($Options.Mode -eq 'DOSSIERS') { Get-Str 'MdModeFolders' } else { Get-Str 'MdModeComplete' }
    $md += "| $(Get-Str 'MdMode') | $ModeDisplay |"
    $DepthDisplay = if ($Options.MaxDepth -eq 0) { Get-Str 'MdDepthUnlimited' } else { (Get-Str 'MdDepthLevels') -f $Options.MaxDepth }
    $md += "| $(Get-Str 'MdDepth') | $DepthDisplay |"
    $md += "| $(Get-Str 'MdTokens') | ~$(Format-TokenCount $TokenCount) tokens |"
    if ($PackedFiles -gt 0) {
        $md += "| $(Get-Str 'MdFilesIncluded') | $PackedFiles |"
    }
    $md += ""

    # Context window compatibility
    $md += "### $(Get-Str 'MdContextTitle')"
    $md += ""
    $contextWindows = @(
        @{ Name = "Claude (200k)"; Limit = 200000 }
        @{ Name = "GPT-4o (128k)"; Limit = 128000 }
        @{ Name = "GPT-4 (8k)"; Limit = 8000 }
        @{ Name = "Gemini 2.0 (1M)"; Limit = 1000000 }
    )
    $md += "| $(Get-Str 'MdModel') | $(Get-Str 'MdLimit') | $(Get-Str 'MdUsage') | $(Get-Str 'MdStatus') |"
    $md += "|--------|--------|-------|--------|"
    foreach ($cw in $contextWindows) {
        $pct = [math]::Round(($TokenCount / $cw.Limit) * 100, 1)
        $status = if ($pct -le 80) { Get-Str 'MdStatusOK' } elseif ($pct -le 100) { Get-Str 'MdStatusLimit' } else { Get-Str 'MdStatusExceeded' }
        $md += "| $($cw.Name) | $(Format-TokenCount $cw.Limit) | $pct% | $status |"
    }
    $md += ""

    $md += "## $(Get-Str 'MdTreeSection')"
    $md += ""
    $md += '```'
    $md += $TreeContent
    $md += '```'
    $md += ""

    if ($StatsContent) {
        $md += "## $(Get-Str 'MdStatsSection')"
        $md += ""
        $md += '```'
        $md += $StatsContent
        $md += '```'
    }

    if ($PackedContent) {
        $md += ""
        $md += "## $(Get-Str 'MdContentsSection')"
        $md += ""
        $md += '```'
        $md += $PackedContent
        $md += '```'
    }

    $md += ""
    $md += "---"
    $md += "*$(Get-Str 'MdFooter') [Arborescence Explorer](https://github.com/DrDiabelsBafian/Arborescence_Explorer) v6.0.0*"

    ($md -join "`r`n") | Out-File -FilePath $OutputFile -Encoding UTF8
}

# ====================================================================
# GUI - INTERFACE CREATION
# ====================================================================

$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width
$formHeight = [math]::Min(920, [int]($screenHeight * 0.92))
$formWidth = [math]::Min(700, [int]($screenWidth * 0.95))

$form = New-Object System.Windows.Forms.Form
$form.Text = Get-Str 'WindowTitle'
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
$form.AllowDrop = $true
$form.KeyPreview = $true

# Enter key = launch scan
$form.Add_KeyDown({
    if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter -and $btnLaunch.Enabled) {
        # Don't trigger if a TextBox has focus (even nested inside GroupBoxes)
        if (-not $txtSource.Focused -and -not $txtExtFilter.Focused) {
            [void]$btnLaunch.PerformClick()
            $_.Handled = $true
            $_.SuppressKeyPress = $true
        }
    }
})

$form.Add_DragEnter({
    if ($_.Data.GetDataPresent([System.Windows.Forms.DataFormats]::FileDrop)) {
        $files = $_.Data.GetData([System.Windows.Forms.DataFormats]::FileDrop)
        if ($files.Count -gt 0 -and (Test-Path $files[0] -PathType Container)) {
            $_.Effect = [System.Windows.Forms.DragDropEffects]::Copy
        }
    }
})

$form.Add_DragDrop({
    $files = $_.Data.GetData([System.Windows.Forms.DataFormats]::FileDrop)
    if ($files.Count -gt 0 -and (Test-Path $files[0] -PathType Container)) {
        $txtSource.Text = $files[0]
    }
})

# Colors
$colorCyan = [System.Drawing.Color]::FromArgb(74, 158, 255)
$colorGreen = [System.Drawing.Color]::FromArgb(80, 250, 123)
$colorOrange = [System.Drawing.Color]::FromArgb(245, 166, 35)
$colorGray = [System.Drawing.Color]::FromArgb(100, 100, 100)
$colorDarkBg = [System.Drawing.Color]::FromArgb(40, 40, 40)

$currentY = 15

# === TITLE (full width) ===
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Location = New-Object System.Drawing.Point(20, $currentY)
$lblTitle.Size = New-Object System.Drawing.Size(620, 30)
$lblTitle.Text = "ARBORESCENCE EXPLORER"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = $colorCyan
$form.Controls.Add($lblTitle)
$currentY += 32

# === SUBTITLE (left) + LANGUAGE SELECTOR (right) - same line ===
$lblSubtitle = New-Object System.Windows.Forms.Label
$lblSubtitle.Location = New-Object System.Drawing.Point(22, ($currentY + 2))
$lblSubtitle.Size = New-Object System.Drawing.Size(400, 15)
$lblSubtitle.Text = Get-Str 'Subtitle'
$lblSubtitle.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$lblSubtitle.ForeColor = $colorGray
$form.Controls.Add($lblSubtitle)

# Flag panel (right-aligned on subtitle line)
$pnlFlag = New-Object System.Windows.Forms.Panel
$pnlFlag.Location = New-Object System.Drawing.Point(524, $currentY)
$pnlFlag.Size = New-Object System.Drawing.Size(34, 20)
$pnlFlag.BorderStyle = "FixedSingle"
$form.Controls.Add($pnlFlag)

# Flag colors (pre-created to avoid GDI+ leaks in Paint events)
$script:colorFrBlue = [System.Drawing.Color]::FromArgb(0, 35, 149)
$script:colorFrRed  = [System.Drawing.Color]::FromArgb(237, 41, 57)
$script:colorUkBlue = [System.Drawing.Color]::FromArgb(1, 33, 105)
$script:colorUkRed  = [System.Drawing.Color]::FromArgb(200, 16, 46)
$script:brushFrBlue = New-Object System.Drawing.SolidBrush($script:colorFrBlue)
$script:brushFrRed  = New-Object System.Drawing.SolidBrush($script:colorFrRed)
$script:brushUkBlue = New-Object System.Drawing.SolidBrush($script:colorUkBlue)
$script:penWhite3   = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 4)
$script:penWhite5   = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 6)
$script:penUkRed2   = New-Object System.Drawing.Pen($script:colorUkRed, 2)
$script:penUkRed3   = New-Object System.Drawing.Pen($script:colorUkRed, 3)

$pnlFlag.Add_Paint({
    $g = $_.Graphics
    $w = $pnlFlag.ClientSize.Width
    $h = $pnlFlag.ClientSize.Height
    if ($script:CurrentLang -eq "FR") {
        # French tricolore: blue | white | red (vertical stripes)
        $third = [math]::Floor($w / 3)
        $g.FillRectangle($script:brushFrBlue, 0, 0, $third, $h)
        $g.FillRectangle([System.Drawing.Brushes]::White, $third, 0, $third, $h)
        $g.FillRectangle($script:brushFrRed, ($third * 2), 0, ($w - $third * 2), $h)
    } else {
        # Union Jack: blue bg + white X + red X + white cross + red cross
        $cx = [math]::Floor($w / 2)
        $cy = [math]::Floor($h / 2)
        $g.FillRectangle($script:brushUkBlue, 0, 0, $w, $h)
        $g.DrawLine($script:penWhite3, 0, 0, $w, $h)
        $g.DrawLine($script:penWhite3, $w, 0, 0, $h)
        $g.DrawLine($script:penUkRed2, 0, 0, $w, $h)
        $g.DrawLine($script:penUkRed2, $w, 0, 0, $h)
        $g.DrawLine($script:penWhite5, $cx, 0, $cx, $h)
        $g.DrawLine($script:penWhite5, 0, $cy, $w, $cy)
        $g.DrawLine($script:penUkRed3, $cx, 0, $cx, $h)
        $g.DrawLine($script:penUkRed3, 0, $cy, $w, $cy)
    }
})

# Combo (right of flag)
$cboLang = New-Object System.Windows.Forms.ComboBox
$cboLang.Location = New-Object System.Drawing.Point(564, ($currentY - 2))
$cboLang.Size = New-Object System.Drawing.Size(60, 22)
$cboLang.DropDownStyle = "DropDownList"
$cboLang.BackColor = $colorDarkBg
$cboLang.ForeColor = [System.Drawing.Color]::White
$cboLang.FlatStyle = "Popup"
$cboLang.Font = New-Object System.Drawing.Font("Segoe UI", 8)
[void]$cboLang.Items.Add("EN")
[void]$cboLang.Items.Add("FR")
$cboLang.SelectedIndex = 0
$form.Controls.Add($cboLang)

$currentY += 24

# === SECTION: SOURCE FOLDER ===
$grpSource = New-Object System.Windows.Forms.GroupBox
$grpSource.Location = New-Object System.Drawing.Point(20, $currentY)
$grpSource.Size = New-Object System.Drawing.Size(620, 70)
$grpSource.Text = Get-Str 'GrpSource'
$grpSource.ForeColor = $colorCyan
$form.Controls.Add($grpSource)

$txtSource = New-Object System.Windows.Forms.TextBox
$txtSource.Location = New-Object System.Drawing.Point(15, 25)
$txtSource.Size = New-Object System.Drawing.Size(480, 25)
# ps2exe: $PSScriptRoot points to a temp folder, use the EXE directory
$currentExe = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
if ($currentExe -notlike "*powershell*" -and $currentExe -notlike "*pwsh*") {
    $defaultPath = Split-Path $currentExe
} else {
    $defaultPath = $PSScriptRoot
}
$txtSource.Text = $defaultPath
$txtSource.BackColor = $colorDarkBg
$txtSource.ForeColor = [System.Drawing.Color]::White
$grpSource.Controls.Add($txtSource)

$btnBrowseSource = New-Object System.Windows.Forms.Button
$btnBrowseSource.Location = New-Object System.Drawing.Point(505, 23)
$btnBrowseSource.Size = New-Object System.Drawing.Size(100, 28)
$btnBrowseSource.Text = Get-Str 'BtnBrowse'
$btnBrowseSource.BackColor = $colorDarkBg
$btnBrowseSource.FlatStyle = "Flat"
$grpSource.Controls.Add($btnBrowseSource)

$btnBrowseSource.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = Get-Str 'BrowseDesc'
    $folderBrowser.SelectedPath = $txtSource.Text
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $txtSource.Text = $folderBrowser.SelectedPath
    }
})

$currentY += 70

# === DRAG & DROP HINT ===
$lblDragHint = New-Object System.Windows.Forms.Label
$lblDragHint.Location = New-Object System.Drawing.Point(20, $currentY)
$lblDragHint.Size = New-Object System.Drawing.Size(620, 16)
$lblDragHint.Text = Get-Str 'DragHint'
$lblDragHint.ForeColor = $colorGray
$lblDragHint.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$lblDragHint.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($lblDragHint)
$currentY += 22

# === SECTION: EXPORT DESTINATION ===
$grpDest = New-Object System.Windows.Forms.GroupBox
$grpDest.Location = New-Object System.Drawing.Point(20, $currentY)
$grpDest.Size = New-Object System.Drawing.Size(620, 110)
$grpDest.Text = Get-Str 'GrpDest'
$grpDest.ForeColor = $colorCyan
$form.Controls.Add($grpDest)

$radDestFixed = New-Object System.Windows.Forms.RadioButton
$radDestFixed.Location = New-Object System.Drawing.Point(15, 22)
$radDestFixed.Size = New-Object System.Drawing.Size(580, 20)
$radDestFixed.Text = (Get-Str 'DestDownloads') -f $env:USERNAME
$radDestFixed.Checked = $true
$radDestFixed.ForeColor = [System.Drawing.Color]::White
$grpDest.Controls.Add($radDestFixed)

$radDestBeside = New-Object System.Windows.Forms.RadioButton
$radDestBeside.Location = New-Object System.Drawing.Point(15, 44)
$radDestBeside.Size = New-Object System.Drawing.Size(580, 20)
$radDestBeside.Text = Get-Str 'DestBeside'
$radDestBeside.ForeColor = [System.Drawing.Color]::White
$grpDest.Controls.Add($radDestBeside)

$radDestInside = New-Object System.Windows.Forms.RadioButton
$radDestInside.Location = New-Object System.Drawing.Point(15, 66)
$radDestInside.Size = New-Object System.Drawing.Size(580, 20)
$radDestInside.Text = Get-Str 'DestInside'
$radDestInside.ForeColor = [System.Drawing.Color]::White
$grpDest.Controls.Add($radDestInside)

$radDestAsk = New-Object System.Windows.Forms.RadioButton
$radDestAsk.Location = New-Object System.Drawing.Point(15, 88)
$radDestAsk.Size = New-Object System.Drawing.Size(580, 20)
$radDestAsk.Text = Get-Str 'DestAsk'
$radDestAsk.ForeColor = [System.Drawing.Color]::White
$grpDest.Controls.Add($radDestAsk)

$currentY += 115

# === SECTION: MODE + DEPTH ===
$grpMode = New-Object System.Windows.Forms.GroupBox
$grpMode.Location = New-Object System.Drawing.Point(20, $currentY)
$grpMode.Size = New-Object System.Drawing.Size(300, 90)
$grpMode.Text = Get-Str 'GrpMode'
$grpMode.ForeColor = $colorCyan
$form.Controls.Add($grpMode)

$radModeFolders = New-Object System.Windows.Forms.RadioButton
$radModeFolders.Location = New-Object System.Drawing.Point(15, 22)
$radModeFolders.Size = New-Object System.Drawing.Size(270, 20)
$radModeFolders.Text = Get-Str 'ModeFolders'
$radModeFolders.ForeColor = [System.Drawing.Color]::White
$grpMode.Controls.Add($radModeFolders)

$lblModeFoldersDesc = New-Object System.Windows.Forms.Label
$lblModeFoldersDesc.Location = New-Object System.Drawing.Point(32, 42)
$lblModeFoldersDesc.Size = New-Object System.Drawing.Size(250, 15)
$lblModeFoldersDesc.Text = Get-Str 'ModeFoldersDesc'
$lblModeFoldersDesc.ForeColor = $colorGray
$lblModeFoldersDesc.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpMode.Controls.Add($lblModeFoldersDesc)

$radModeComplete = New-Object System.Windows.Forms.RadioButton
$radModeComplete.Location = New-Object System.Drawing.Point(15, 58)
$radModeComplete.Size = New-Object System.Drawing.Size(270, 20)
$radModeComplete.Text = Get-Str 'ModeComplete'
$radModeComplete.Checked = $true
$radModeComplete.ForeColor = [System.Drawing.Color]::White
$grpMode.Controls.Add($radModeComplete)

$grpDepth = New-Object System.Windows.Forms.GroupBox
$grpDepth.Location = New-Object System.Drawing.Point(340, $currentY)
$grpDepth.Size = New-Object System.Drawing.Size(300, 90)
$grpDepth.Text = Get-Str 'GrpDepth'
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
$lblDepthDesc.Text = Get-Str 'DepthDesc'
$lblDepthDesc.ForeColor = [System.Drawing.Color]::White
$grpDepth.Controls.Add($lblDepthDesc)

$lblDepthHelp = New-Object System.Windows.Forms.Label
$lblDepthHelp.Location = New-Object System.Drawing.Point(15, 60)
$lblDepthHelp.Size = New-Object System.Drawing.Size(270, 20)
$lblDepthHelp.Text = Get-Str 'DepthHelp'
$lblDepthHelp.ForeColor = $colorGray
$lblDepthHelp.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpDepth.Controls.Add($lblDepthHelp)

$currentY += 100

# === SECTION: OPTIONS ===
$grpOptions = New-Object System.Windows.Forms.GroupBox
$grpOptions.Location = New-Object System.Drawing.Point(20, $currentY)
$grpOptions.Size = New-Object System.Drawing.Size(620, 130)
$grpOptions.Text = Get-Str 'GrpOptions'
$grpOptions.ForeColor = $colorCyan
$form.Controls.Add($grpOptions)

$chkMetadata = New-Object System.Windows.Forms.CheckBox
$chkMetadata.Location = New-Object System.Drawing.Point(15, 22)
$chkMetadata.Size = New-Object System.Drawing.Size(280, 20)
$chkMetadata.Text = Get-Str 'OptMetadata'
$chkMetadata.Checked = $true
$chkMetadata.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkMetadata)

$chkStats = New-Object System.Windows.Forms.CheckBox
$chkStats.Location = New-Object System.Drawing.Point(320, 22)
$chkStats.Size = New-Object System.Drawing.Size(280, 20)
$chkStats.Text = Get-Str 'OptStats'
$chkStats.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkStats)

$chkExclusions = New-Object System.Windows.Forms.CheckBox
$chkExclusions.Location = New-Object System.Drawing.Point(15, 48)
$chkExclusions.Size = New-Object System.Drawing.Size(280, 20)
$chkExclusions.Text = Get-Str 'OptExclusions'
$chkExclusions.Checked = $true
$chkExclusions.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkExclusions)

$chkClipboard = New-Object System.Windows.Forms.CheckBox
$chkClipboard.Location = New-Object System.Drawing.Point(320, 48)
$chkClipboard.Size = New-Object System.Drawing.Size(280, 20)
$chkClipboard.Text = Get-Str 'OptClipboard'
$chkClipboard.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkClipboard)

$chkGitignore = New-Object System.Windows.Forms.CheckBox
$chkGitignore.Location = New-Object System.Drawing.Point(15, 74)
$chkGitignore.Size = New-Object System.Drawing.Size(280, 20)
$chkGitignore.Text = Get-Str 'OptGitignore'
$chkGitignore.Checked = $true
$chkGitignore.ForeColor = [System.Drawing.Color]::White
$grpOptions.Controls.Add($chkGitignore)

$lblExtFilter = New-Object System.Windows.Forms.Label
$lblExtFilter.Location = New-Object System.Drawing.Point(320, 76)
$lblExtFilter.Size = New-Object System.Drawing.Size(110, 16)
$lblExtFilter.Text = Get-Str 'OptExtFilter'
$lblExtFilter.ForeColor = [System.Drawing.Color]::White
$lblExtFilter.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpOptions.Controls.Add($lblExtFilter)

$txtExtFilter = New-Object System.Windows.Forms.TextBox
$txtExtFilter.Location = New-Object System.Drawing.Point(430, 73)
$txtExtFilter.Size = New-Object System.Drawing.Size(175, 22)
$txtExtFilter.Text = ""
$txtExtFilter.BackColor = $colorDarkBg
$txtExtFilter.ForeColor = [System.Drawing.Color]::White
$txtExtFilter.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpOptions.Controls.Add($txtExtFilter)

$lblExtHelp = New-Object System.Windows.Forms.Label
$lblExtHelp.Location = New-Object System.Drawing.Point(320, 97)
$lblExtHelp.Size = New-Object System.Drawing.Size(290, 15)
$lblExtHelp.Text = Get-Str 'OptExtHelp'
$lblExtHelp.ForeColor = $colorGray
$lblExtHelp.Font = New-Object System.Drawing.Font("Segoe UI", 7)
$grpOptions.Controls.Add($lblExtHelp)

$lblExclHelp = New-Object System.Windows.Forms.Label
$lblExclHelp.Location = New-Object System.Drawing.Point(15, 97)
$lblExclHelp.Size = New-Object System.Drawing.Size(300, 28)
$lblExclHelp.Text = Get-Str 'OptExclHelp'
$lblExclHelp.ForeColor = $colorGray
$lblExclHelp.Font = New-Object System.Drawing.Font("Segoe UI", 7)
$grpOptions.Controls.Add($lblExclHelp)

$currentY += 138

# === SECTION: LLM CONTENT PACKING ===
$grpPacking = New-Object System.Windows.Forms.GroupBox
$grpPacking.Location = New-Object System.Drawing.Point(20, $currentY)
$grpPacking.Size = New-Object System.Drawing.Size(620, 50)
$grpPacking.Text = Get-Str 'GrpPacking'
$grpPacking.ForeColor = $colorOrange
$form.Controls.Add($grpPacking)

$chkContents = New-Object System.Windows.Forms.CheckBox
$chkContents.Location = New-Object System.Drawing.Point(15, 22)
$chkContents.Size = New-Object System.Drawing.Size(370, 20)
$chkContents.Text = Get-Str 'OptContents'
$chkContents.ForeColor = [System.Drawing.Color]::White
$grpPacking.Controls.Add($chkContents)

$lblPackingHelp = New-Object System.Windows.Forms.Label
$lblPackingHelp.Location = New-Object System.Drawing.Point(400, 24)
$lblPackingHelp.Size = New-Object System.Drawing.Size(210, 16)
$lblPackingHelp.Text = Get-Str 'PackingHelp'
$lblPackingHelp.ForeColor = $colorGray
$lblPackingHelp.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpPacking.Controls.Add($lblPackingHelp)

$currentY += 58

# === SECTION: FFPROBE (optional) ===
$grpMedia = New-Object System.Windows.Forms.GroupBox
$grpMedia.Location = New-Object System.Drawing.Point(20, $currentY)
$grpMedia.Size = New-Object System.Drawing.Size(620, 50)
$grpMedia.Text = Get-Str 'GrpMedia'
$grpMedia.ForeColor = $colorOrange
$form.Controls.Add($grpMedia)

$chkMedia = New-Object System.Windows.Forms.CheckBox
$chkMedia.Location = New-Object System.Drawing.Point(15, 22)
$chkMedia.Size = New-Object System.Drawing.Size(370, 20)
$chkMedia.Text = Get-Str 'OptMedia'
$chkMedia.Enabled = $script:HasFFprobe
$chkMedia.ForeColor = if ($script:HasFFprobe) { [System.Drawing.Color]::White } else { $colorGray }
$grpMedia.Controls.Add($chkMedia)

$lblMediaStatus = New-Object System.Windows.Forms.Label
$lblMediaStatus.Location = New-Object System.Drawing.Point(400, 24)
$lblMediaStatus.Size = New-Object System.Drawing.Size(200, 16)
$lblMediaStatus.Text = if ($script:HasFFprobe) { Get-Str 'MediaDetected' } else { Get-Str 'MediaAbsent' }
$lblMediaStatus.ForeColor = if ($script:HasFFprobe) { $colorGreen } else { $colorGray }
$lblMediaStatus.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$grpMedia.Controls.Add($lblMediaStatus)

$currentY += 58

# === SECTION: EXPORT FORMAT ===
$grpExport = New-Object System.Windows.Forms.GroupBox
$grpExport.Location = New-Object System.Drawing.Point(20, $currentY)
$grpExport.Size = New-Object System.Drawing.Size(620, 55)
$grpExport.Text = Get-Str 'GrpExport'
$grpExport.ForeColor = $colorCyan
$form.Controls.Add($grpExport)

$chkExportTXT = New-Object System.Windows.Forms.CheckBox
$chkExportTXT.Location = New-Object System.Drawing.Point(15, 22)
$chkExportTXT.Size = New-Object System.Drawing.Size(180, 20)
$chkExportTXT.Text = Get-Str 'ExportTXT'
$chkExportTXT.Checked = $true
$chkExportTXT.ForeColor = [System.Drawing.Color]::White
$grpExport.Controls.Add($chkExportTXT)

$chkExportMD = New-Object System.Windows.Forms.CheckBox
$chkExportMD.Location = New-Object System.Drawing.Point(220, 22)
$chkExportMD.Size = New-Object System.Drawing.Size(250, 20)
$chkExportMD.Text = Get-Str 'ExportMD'
$chkExportMD.Checked = $true
$chkExportMD.ForeColor = [System.Drawing.Color]::White
$grpExport.Controls.Add($chkExportMD)

$currentY += 65

# === STATUS + PROGRESS ===
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(20, $currentY)
$lblStatus.Size = New-Object System.Drawing.Size(620, 20)
$lblStatus.Text = Get-Str 'StatusReady'
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

# === BUTTONS ===
$btnLaunch = New-Object System.Windows.Forms.Button
$btnLaunch.Location = New-Object System.Drawing.Point(200, $currentY)
$btnLaunch.Size = New-Object System.Drawing.Size(180, 40)
$btnLaunch.Text = Get-Str 'BtnLaunch'
$btnLaunch.BackColor = $colorGreen
$btnLaunch.ForeColor = [System.Drawing.Color]::Black
$btnLaunch.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnLaunch.FlatStyle = "Flat"
$form.Controls.Add($btnLaunch)

$btnCancel = New-Object System.Windows.Forms.Button
$btnCancel.Location = New-Object System.Drawing.Point(400, $currentY)
$btnCancel.Size = New-Object System.Drawing.Size(100, 40)
$btnCancel.Text = Get-Str 'BtnClose'
$btnCancel.BackColor = $colorDarkBg
$btnCancel.FlatStyle = "Flat"
$form.Controls.Add($btnCancel)

$btnCancel.Add_Click({ $form.Close() })

$currentY += 50

# === GITHUB LINK (bottom) ===
$lblGithub = New-Object System.Windows.Forms.LinkLabel
$lblGithub.Location = New-Object System.Drawing.Point(20, $currentY)
$lblGithub.Size = New-Object System.Drawing.Size(620, 18)
$lblGithub.Text = "v6.0.0 - github.com/DrDiabelsBafian/Arborescence_Explorer"
$lblGithub.LinkArea = New-Object System.Windows.Forms.LinkArea(9, 50)
$lblGithub.LinkColor = $colorGray
$lblGithub.ActiveLinkColor = $colorCyan
$lblGithub.VisitedLinkColor = $colorGray
$lblGithub.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblGithub.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($lblGithub)

$lblGithub.Add_LinkClicked({
    [void](Start-Process "https://github.com/DrDiabelsBafian/Arborescence_Explorer")
})

# ====================================================================
# LANGUAGE SWITCH HANDLER
# ====================================================================

$cboLang.Add_SelectedIndexChanged({
    $script:CurrentLang = $cboLang.SelectedItem.ToString()

    # Update all GUI texts
    $form.Text = Get-Str 'WindowTitle'
    $lblSubtitle.Text = Get-Str 'Subtitle'
    $grpSource.Text = Get-Str 'GrpSource'
    $btnBrowseSource.Text = Get-Str 'BtnBrowse'
    $lblDragHint.Text = Get-Str 'DragHint'
    $grpDest.Text = Get-Str 'GrpDest'
    $radDestFixed.Text = (Get-Str 'DestDownloads') -f $env:USERNAME
    $radDestBeside.Text = Get-Str 'DestBeside'
    $radDestInside.Text = Get-Str 'DestInside'
    $radDestAsk.Text = Get-Str 'DestAsk'
    $grpMode.Text = Get-Str 'GrpMode'
    $radModeFolders.Text = Get-Str 'ModeFolders'
    $lblModeFoldersDesc.Text = Get-Str 'ModeFoldersDesc'
    $radModeComplete.Text = Get-Str 'ModeComplete'
    $grpDepth.Text = Get-Str 'GrpDepth'
    $lblDepthDesc.Text = Get-Str 'DepthDesc'
    $lblDepthHelp.Text = Get-Str 'DepthHelp'
    $grpOptions.Text = Get-Str 'GrpOptions'
    $chkMetadata.Text = Get-Str 'OptMetadata'
    $chkStats.Text = Get-Str 'OptStats'
    $chkExclusions.Text = Get-Str 'OptExclusions'
    $chkClipboard.Text = Get-Str 'OptClipboard'
    $chkGitignore.Text = Get-Str 'OptGitignore'
    $lblExtFilter.Text = Get-Str 'OptExtFilter'
    $lblExtHelp.Text = Get-Str 'OptExtHelp'
    $lblExclHelp.Text = Get-Str 'OptExclHelp'
    $grpPacking.Text = Get-Str 'GrpPacking'
    $chkContents.Text = Get-Str 'OptContents'
    $lblPackingHelp.Text = Get-Str 'PackingHelp'
    $grpMedia.Text = Get-Str 'GrpMedia'
    $chkMedia.Text = Get-Str 'OptMedia'
    $lblMediaStatus.Text = if ($script:HasFFprobe) { Get-Str 'MediaDetected' } else { Get-Str 'MediaAbsent' }
    $grpExport.Text = Get-Str 'GrpExport'
    $chkExportTXT.Text = Get-Str 'ExportTXT'
    $chkExportMD.Text = Get-Str 'ExportMD'
    $lblStatus.Text = Get-Str 'StatusReady'
    $btnLaunch.Text = Get-Str 'BtnLaunch'
    $btnCancel.Text = Get-Str 'BtnClose'
    $lblTokenInfo.Text = ""

    $pnlFlag.Invalidate()
    $form.Refresh()
})

# ====================================================================
# LAUNCH BUTTON LOGIC
# ====================================================================

$btnLaunch.Add_Click({
    $sourcePath = $txtSource.Text
    if (-not (Test-Path $sourcePath)) {
        [void][System.Windows.Forms.MessageBox]::Show((Get-Str 'MsgNoFolder'), (Get-Str 'MsgError'), "OK", "Error")
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
        $saveDialog.Description = Get-Str 'MsgChooseDest'
        if ($saveDialog.ShowDialog() -ne "OK") { return }
        $destPath = $saveDialog.SelectedPath
    }

    # Version increment (check all export formats)
    $version = 1
    while ((Test-Path (Join-Path $destPath "$baseFileName`_V$version.txt")) -or
           (Test-Path (Join-Path $destPath "$baseFileName`_V$version.md"))) { $version++ }
    $baseFileName = "$baseFileName`_V$version"

    # Parse extension filter
    $extFilter = @()
    if ($txtExtFilter.Text.Trim()) {
        $extFilter = $txtExtFilter.Text.Split(',') | ForEach-Object {
            $e = $_.Trim().ToLower()
            if ($e -and -not $e.StartsWith('.')) { $e = ".$e" }
            $e
        } | Where-Object { $_ }
    }

    # Read .gitignore if enabled
    if ($chkGitignore.Checked) {
        $script:GitignorePatterns = Read-Gitignore $sourcePath
    } else {
        $script:GitignorePatterns = @()
    }

    # Build options
    $options = @{
        Mode = if ($radModeComplete.Checked) { "COMPLET" } else { "DOSSIERS" }
        MaxDepth = [int]$numDepth.Value
        ShowMetadata = $chkMetadata.Checked
        ShowStats = $chkStats.Checked
        UseExclusions = $chkExclusions.Checked
        AnalyzeMedia = $chkMedia.Checked
        IncludeContents = $chkContents.Checked
        ExtensionFilter = $extFilter
    }

    # Start scan
    $btnLaunch.Enabled = $false
    $progressBar.MarqueeAnimationSpeed = 30
    $lblStatus.Text = Get-Str 'StatusScanning'
    $lblTokenInfo.Text = ""
    [System.Windows.Forms.Application]::DoEvents()

    try {
        # Build header
        $Output = @()
        $Output += "=========================================="
        $ModeDisplay = if ($options.Mode -eq 'DOSSIERS') { Get-Str 'ExpFoldersOnly' } else { Get-Str 'ExpComplete' }
        $Output += "$(Get-Str 'ExpTreeHeader') - $ModeDisplay"
        $Output += "$(Get-Str 'ExpGenerated') : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
        $Output += "$(Get-Str 'ExpRoot') : $sourcePath"
        if ($options.ShowMetadata) { $Output += (Get-Str 'ExpMetadata') }
        if ($options.AnalyzeMedia) { $Output += (Get-Str 'ExpMediaAnalysis') }
        if ($options.IncludeContents) { $Output += (Get-Str 'ExpContentPacking') }
        if ($options.ExtensionFilter.Count -gt 0) { $Output += "$(Get-Str 'ExpExtFilter') : $($options.ExtensionFilter -join ', ')" }
        $DepthDisplay = if ($options.MaxDepth -eq 0) { Get-Str 'ExpUnlimited' } else { "$($options.MaxDepth) $(Get-Str 'ExpLevels')" }
        $Output += "$(Get-Str 'ExpDepth') : $DepthDisplay"
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
        $Output += (Get-Str 'ExpEndReport')
        $Output += "=========================================="

        $FullContent = $Output -join "`r`n"
        $TreeContent = $TreeLines -join "`r`n"
        $StatsContent = $StatsLines -join "`r`n"

        # Content packing
        $PackedContent = ""
        $PackedFiles = 0
        $PackedTokens = 0
        if ($options.IncludeContents) {
            $lblStatus.Text = Get-Str 'StatusPacking'
            [System.Windows.Forms.Application]::DoEvents()
            $packResult = Get-PackedContents -Path $sourcePath -Options $options -StatusLabel $lblStatus
            $PackedContent = $packResult.Content -join "`r`n"
            $PackedFiles = $packResult.FileCount
            $PackedTokens = $packResult.TotalTokens
            $FullContent += "`r`n$PackedContent"
        }

        # Token estimation
        $tokenCount = Get-TokenEstimate $FullContent
        $tokenFormatted = Format-TokenCount $tokenCount

        # Context window check
        $claudeOk = if ($tokenCount -le 160000) { Get-Str 'TokenClaudeOK' } else { Get-Str 'TokenClaudeLimit' }
        $gptOk = if ($tokenCount -le 100000) { Get-Str 'TokenGptOK' } else { Get-Str 'TokenGptLimit' }
        $packingInfo = if ($PackedFiles -gt 0) { " | $PackedFiles $(Get-Str 'TokenFiles')" } else { "" }
        $lblTokenInfo.Text = "~$tokenFormatted tokens | $claudeOk | $gptOk$packingInfo"
        $lblTokenInfo.ForeColor = if ($tokenCount -le 100000) { $colorGreen } elseif ($tokenCount -le 160000) { $colorOrange } else { [System.Drawing.Color]::Red }

        # Add token info to TXT output
        $tokenLine = "`r`n$(Get-Str 'ExpTokens') : ~$tokenFormatted (~$tokenCount tokens)"
        if ($PackedFiles -gt 0) { $tokenLine += " | $PackedFiles $(Get-Str 'ExpFilesIncluded') (~$(Format-TokenCount $PackedTokens) $(Get-Str 'ExpTokensContent'))" }
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
            Export-Markdown -TreeContent $TreeContent -StatsContent $StatsContent -PackedContent $PackedContent -Title "Arborescence - $folderName" -SourcePath $sourcePath -Options $options -TokenCount $tokenCount -PackedFiles $PackedFiles -OutputFile $mdFile
            $exportedFiles += $mdFile
        }

        # Clipboard
        if ($chkClipboard.Checked) {
            $FullContent | Set-Clipboard
        }

        # Done
        $progressBar.MarqueeAnimationSpeed = 0
        $lblStatus.Text = (Get-Str 'StatusDone') -f $exportedFiles.Count, $tokenFormatted

        # Open destination
        [void](Start-Process explorer.exe -ArgumentList $destPath)

        $filesMsg = $exportedFiles -join "`n"
        [void][System.Windows.Forms.MessageBox]::Show(((Get-Str 'MsgExportDone') -f $filesMsg, $tokenFormatted), (Get-Str 'MsgSuccess'), "OK", "Information")

    } catch {
        [void][System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", (Get-Str 'MsgError'), "OK", "Error")
    } finally {
        $btnLaunch.Enabled = $true
        $progressBar.MarqueeAnimationSpeed = 0
    }
})

# ====================================================================
# LAUNCH
# ====================================================================

[void]$form.ShowDialog()
