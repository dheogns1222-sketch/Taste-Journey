Set-Location "D:\Clode\Projects\Taste Journey"

# Git 락 파일 제거 (이전 프로세스 잔여물)
if (Test-Path ".git\index.lock") { Remove-Item ".git\index.lock" -Force }

git add -A

git commit -m "✨ Luxury design overhaul — Michelin Guide aesthetic

- Full CSS redesign: Playfair Display + DM Sans typography
- Black & Gold color palette (--gold, --gold2, --gold3)
- Auth screen: dark cinematic backdrop + glass morphism card
- Smooth animations: heroFloat, viewIn, slideUp (spring easing)
- Header: gold gradient accent line, blur shadow
- Nav: gold top bar indicator with spring animation
- Cards: premium hover lift + shadow system
- Buttons: gradient gold with translateY hover + press feedback
- Modals: backdrop blur overlay + spring slide-up
- Stats: Playfair Display numerals with gradient text
- Profile hero: dark cinematic gradient bg
- Compatibility aliases: --pr/--ac → gold for JS inline styles
- theme-color updated to #0D0A06"

git push origin master

Write-Host "`n✅ 배포 완료! https://dheogns1222-sketch.github.io/Taste-Journey/" -ForegroundColor Green
