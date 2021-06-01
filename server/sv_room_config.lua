ROOM_CONFIG = {
    [1] = {
        info = {
            name = "Valentine Hotel", -- blipde ve bildirimlerde gözüken otel ismi
            showblip = true, -- blip açma kapama
            sprite = 475, -- blip stili (https://wiki.rage.mp/index.php?title=Blips)
            color = 27, -- blip rengi (https://wiki.rage.mp/index.php?title=Blips sayfanın en altında renklerin kodları var)
            coords = vector3(-325.83, 774.45, 117.46), -- blipin haritada yeri ve mesafe blok kontrolü için olan koordinat (otelin tam ortasına koyun)
            reception = {x = -325.83, y = 774.45, z = 117.46}, -- resepsiyon menüsü koordinatı
            doorhash = 1650744725, -- kapının obje hash i (eğer sadece objenin ismini biliyorsanız GetHashKey("motels_door_r") tarızınıda kullanabilirsiniz)
            owner = "", -- motel sahibi identifier
            expense = 20000, -- motelin gideri
            auto_pay = false, -- burayı değiştirmeyin
            debt = 0, -- burayıda değiştirmeyin
        },
        rooms = {
            [1] = {door = vector3(-324.1794, 774.6575, 120.6239), h = 279.99993896484, stash = vector3(-324.91, 776.13, 121.25), clothe = vector3(-329.52, 775.25, 121.6), obj = nil, locked = true, locked2 = true, data = {}},
            [2] = {door = vector3(-322.7494, 766.6564, 120.6232), h = 99.999923706055, stash = vector3(310.51, -198.61, 54.22), clothe = vector3(306.32, -197.45, 54.22), obj = nil, locked = true, locked2 = true, data = {}},
            [3] = {door = vector3(-322.0833, 762.7339, 120.6229), h = 280.17929077148, stash = vector3(320.45, -194.13, 54.22), clothe = vector3(321.79, -189.81, 54.22), obj = nil, locked = true, locked2 = true, data = {}},
        }
    }
}