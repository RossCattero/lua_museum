local ITEM = Clockwork.item:New("books_base");

ITEM.name = "Медицина";
ITEM.model = "models/props_lab/binderblue.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "c_book_medicine"
ITEM.category = "Книги";
ITEM.typeOfSkill = ATB_SUSPECTING;
ITEM.addToSkill = 0.4;
ITEM.addToInt = 0.2;

ITEM:Register()