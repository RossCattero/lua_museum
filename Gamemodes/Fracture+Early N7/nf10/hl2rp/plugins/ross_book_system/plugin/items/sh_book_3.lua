local ITEM = Clockwork.item:New("books_base");

ITEM.name = "Поваренная книга";
ITEM.model = "models/props_lab/binderblue.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "c_book_cooking"
ITEM.category = "Книги";
ITEM.typeOfSkill = ATB_COOK;
ITEM.addToSkill = 0.5;
ITEM.addToInt = 0.2;

ITEM:Register()