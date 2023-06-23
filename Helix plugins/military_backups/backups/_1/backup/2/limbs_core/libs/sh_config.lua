LIMBS = LIMBS || {}

LIMBS.BLEEDS = LIMBS.BLEEDS || {}

LIMBS.DAMAGE_MUL = 90; // На сколько умножать урон; ! Заскейлится количество боли, уменьшаемой крови !
LIMBS.CAUSE_BLEED = 100; // Сколько процентов от урона будет составлять кровотечение
LIMBS.MIN_HURT = 5; // Сколько будет добавляться предела восстановления боли за попадание по части тела;
LIMBS.MIN_BLOOD = 4000; // Сколько всего будет крови в самом начале(мл!)
LIMBS.BLOOD_PERCENT = LIMBS.MIN_BLOOD * (75 / 100); // 75% от крови = упасть
LIMBS.BLOOD_MIN = LIMBS.MIN_BLOOD * (60 / 100); // 60% от крови = упасть без сознания
LIMBS.MIN_BLOOD_G = LIMBS.MIN_BLOOD * 0.0001; // Для отображения серости, не менять.
LIMBS.TICK_BLOOD = 1; // Сколько секунд будет между потерей крови;
LIMBS.DAMAGE_MORE = 5; // Доп урон в зависимости от количества ранений;
LIMBS.DMG_LEG_FALL = 10; // Порог урона, после которого персонаж упадет
LIMBS.INFECT_TIME = 3600; // Через сколько секунд появится инфекция из-за загноения(Если не настроено)
LIMBS.ROT_TIME = 60; // Через сколько секунд, если этому не помешать, появится гниение?
LIMBS.ADD_CD = 10; // Сколько секунд будет показываться после получения урона тело на экране;

LIMBS.BIO = LIMBS.BIO || {blood = LIMBS.MIN_BLOOD, pain = 0, painMin = 0, shock = 0, bleed = 0}

LIMBS.SHOCK_AMOUNT = 80; // Количество шока, чтобы упасть в обморок
LIMBS.MAX_SHOCK_AMOUNT = 150; // Максимальное количество шока
LIMBS.ADD_SHOCK = 5; // Сколько процентов от текущего шока добавить к количеству шока от препарата

LIMBS.INJ_CLR = Color(200, 80, 80) // Цвет для ранения

LIMBS.BLOOD_TEXT = "** Из этой конечности без остановки идет кровь." // Текст для кровотечения
LIMBS.BLOOD_CLR = Color(200, 100, 100) // Цвет для кровотечения
LIMBS.ROT_TEXT = "** Эта конечность болит и с каждой секундой боль усиливается." // Текст для гниения
LIMBS.ROT_CLR = Color(131, 160, 38) // Цвет для гниения

LIMBS.HEAL_CLR = Color(50, 160, 50)

LIMBS.INFECT_TEXT = "** Повреждение чернеет и отдает невыносимой болью по всей конечности."; // Текст для инфекции

LIMBS.WOUNDED_SEQ = {"d1_town05_Winston_Down", "d1_town05_Wounded_Idle_1", "d1_town05_Wounded_Idle_2"}

LIMBS.INT_KEY = KEY_I

LIMBS.UI = nil;

function LIMBS:GetRandomSequence()
	return self.WOUNDED_SEQ[math.random(1, #self.WOUNDED_SEQ)]
end;

function LIMBS:OpenUI(data)
	local char = LocalPlayer():GetLocalVar("inspChar")

	LIMBS_DATA = {}
	if data && IsValid(char) && char.Name then
		LIMBS_DATA = data;
	else
		LIMBS_DATA.Limbs = LocalPlayer():GetLimbs()
		LIMBS_DATA.Blood = LocalPlayer():GetBlood()
		LIMBS_DATA.Pain = LocalPlayer():GetHurt()
		LIMBS_DATA.Bleeding = LocalPlayer():GetBleed()
	end

	if IsValid(LIMBS.UI) then LIMBS.UI:Close() end

	LIMBS.UI = vgui.Create( "Limbs" )
	LIMBS.UI:Populate()
end;