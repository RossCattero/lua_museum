local ITEM = Clockwork.item:New("books_base");

ITEM.name = "Мастер на все руки";
ITEM.model = "models/props_lab/binderblue.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "c_book_remeslo"
ITEM.category = "Книги";
ITEM.typeOfSkill = ATB_COLLECTING;
ITEM.addToSkill = 0.3;
ITEM.addToInt = 0.2;

ITEM:Register()