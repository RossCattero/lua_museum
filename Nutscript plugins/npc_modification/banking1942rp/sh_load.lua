local PLUGIN = PLUGIN;

resource.AddFile("resource/fonts/com.ttf")
resource.AddFile("resource/fonts/indie.ttf")
resource.AddFile("resource/fonts/quicksand.ttf")
resource.AddFile("resource/fonts/typewriter.ttf")

BankBook = Material("materials/banking/book.png")
resource.AddFile(BankBook:GetName() .. ".png")
BankPage = Material("materials/banking/paper.png")
resource.AddFile(BankPage:GetName() .. ".png")

BookFlip = Sound("ui/f_page.wav")
resource.AddFile("ui/f_page.wav")
TypeWriter = Sound("ui/typewriter.wav")
resource.AddFile("ui/typewriter.wav")
PaperRip = Sound("ui/paper_rip.wav")
resource.AddFile("ui/paper_rip.wav")
PenWrite = Sound("ui/write.wav")
resource.AddFile("ui/write.wav")