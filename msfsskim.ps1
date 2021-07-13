$exclude = '*exe, *dll, *pdb, *png, *jpg, *jpeg, *mdf, *docx, *wav'
$include = '*.js', '*.html', '*.wasm', '*.svg'
$regex = '(?<!xmlns=|xmlns:svg=|xmlns:cc=|xmlns:dc=|xmlns:rdf=|xmlns:sodipodi=|xmlns:inkscape=|xmlns:xlink=)"http:|XmlHttpRequest|WebSockets'
$path = $Args[0]
#$path = 'e:\kittyhawk\marketplace\russal_STDT-RUSSAL-KH01_001\KittyHawk\PlayfabPackages\Official\*'
#$path = 'E:\kittyhawk\marketplace\russal_STDT-RUSSAL-KH01_001\KittyHawk\PlayfabPackages\Official\Xbox\bredok3d-boeing737\'

$results = Get-ChildItem -Include $include -Recurse $path | select-string -Pattern $regex
$results_file=$Args[1]+'\\msfsskim_results_'+(Get-Date -Format "yyyyMMdd").ToString()+'.html'

$html = $results | ConvertTo-Html -Title 'MSFS Security Review Results' @{
             label='File'
             expression={"<a href='vscode://file/$($_.Path)/:$($_.LineNumber):$($_.Matches.Index)'>$($_.FileName)</a>"}
         },
        @{
             label='Type'
             expression={
                $extension = [io.path]::GetExtension($_.Path)
                switch($extension)
                {
                    '.js'   {'JavaScript'}
                    '.html' {'HTML'}
                    '.svg'  {'SVG'}
                    default {$extension}
                 }
             }
         },
        @{
             label='Pattern'
             expression={$_.Matches[0].Value}
         },
        @{
            label='Line'
            expression={$_.Line}
         }

Add-Type -AssemblyName System.Web
[System.Web.HttpUtility]::HtmlDecode($html) | Out-File $results_file