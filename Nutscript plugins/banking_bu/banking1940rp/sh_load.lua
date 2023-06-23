local PLUGIN = PLUGIN;

resource.AddFile("resource/fonts/com.ttf")
resource.AddFile("resource/fonts/indie.ttf")
resource.AddFile("resource/fonts/quicksand.ttf")
resource.AddFile("resource/fonts/typewriter.ttf")

PLUGIN.BankBook = Material("materials/banking/book.png")
resource.AddFile(PLUGIN.BankBook:GetName() .. ".png")
PLUGIN.BankPage = Material("materials/banking/paper.png")
resource.AddFile(PLUGIN.BankPage:GetName() .. ".png")

PLUGIN.BookFlip = Sound("ui/f_page.wav")
resource.AddFile("ui/f_page.wav")
PLUGIN.TypeWriter = Sound("ui/typewriter.wav")
resource.AddFile("ui/typewriter.wav")
PLUGIN.PaperRip = Sound("ui/paper_rip.wav")
resource.AddFile("ui/paper_rip.wav")
PLUGIN.PenWrite = Sound("ui/write.wav")
resource.AddFile("ui/write.wav")