$Images = @(
    @{ Url = 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80'; File = 'villa_1.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80'; File = 'penthouse_1.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=800&q=80'; File = 'cottage_1.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80'; File = 'beach_house_1.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?auto=format&fit=crop&w=800&q=80'; File = 'apartment_1.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=800&q=80'; File = 'villa_2.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1512918580421-b2cfadd39b33?auto=format&fit=crop&w=800&q=80'; File = 'duplex_1.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1416331108676-a22ccb276e35?auto=format&fit=crop&w=800&q=80'; File = 'mansion_1.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'; File = 'studio_1.jpg' },
    @{ Url = 'https://images.unsplash.com/photo-1449844908441-8829872d2607?auto=format&fit=crop&w=800&q=80'; File = 'retreat_1.jpg' }
)

$TargetDir = "assets\picture"
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir | Out-Null
}

foreach ($Img in $Images) {
    $FilePath = Join-Path $TargetDir $Img.File
    Write-Host "Downloading $($Img.File)..."
    Invoke-WebRequest -Uri $Img.Url -OutFile $FilePath -UseBasicParsing
}
Write-Host "Done!"
