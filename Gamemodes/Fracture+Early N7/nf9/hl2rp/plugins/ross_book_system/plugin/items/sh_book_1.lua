local ITEM = Clockwork.item:New("books_base");

ITEM.name = "Владение пистолетами";
ITEM.model = "models/props_lab/binderblue.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "c_book_pistols"
ITEM.category = "Книги";
ITEM.typeOfSkill = ATB_PISTOLS;
ITEM.addToSkill = 0.3;
ITEM.addToInt = 0.4;

ITEM:Register()