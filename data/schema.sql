-- ================================================================
-- ZooJoy Supabase Schema + Seed
-- Запустить в: https://supabase.com/dashboard/project/YOUR_PROJECT_REF/sql/new
-- ================================================================

-- TABLE: vets
CREATE TABLE IF NOT EXISTS vets (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  name_local TEXT,
  category TEXT,
  description TEXT,
  city TEXT,
  district TEXT,
  address TEXT,
  address_branch TEXT,
  lat DECIMAL(10,6),
  lng DECIMAL(10,6),
  phone JSONB,
  email TEXT,
  website TEXT,
  social_media JSONB,
  working_hours JSONB,
  services JSONB,
  rating DECIMAL(3,1),
  reviews_count INTEGER,
  is_24h BOOLEAN DEFAULT FALSE,
  image_url TEXT,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- TABLE: places
CREATE TABLE IF NOT EXISTS places (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  name_local TEXT,
  type TEXT,
  category TEXT,
  description TEXT,
  founded INTEGER,
  city TEXT,
  district TEXT,
  address TEXT,
  lat DECIMAL(10,6),
  lng DECIMAL(10,6),
  phone JSONB,
  email TEXT,
  website TEXT,
  social_media JSONB,
  working_hours JSONB,
  pricing JSONB,
  features JSONB,
  rating DECIMAL(4,1),
  image_url TEXT,
  status TEXT DEFAULT 'active',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- TABLE: organizations
CREATE TABLE IF NOT EXISTS organizations (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  name_local TEXT,
  type TEXT,
  category TEXT,
  description TEXT,
  founded INTEGER,
  city TEXT,
  address TEXT,
  lat DECIMAL(10,6),
  lng DECIMAL(10,6),
  phone JSONB,
  email TEXT,
  website TEXT,
  social_media JSONB,
  working_hours JSONB,
  services JSONB,
  rating DECIMAL(3,1),
  image_url TEXT,
  status TEXT DEFAULT 'active',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- TABLE: shelters
CREATE TABLE IF NOT EXISTS shelters (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  name_local TEXT,
  category TEXT,
  description TEXT,
  city TEXT,
  district TEXT,
  address TEXT,
  lat DECIMAL(10,6),
  lng DECIMAL(10,6),
  phone JSONB,
  email TEXT,
  website TEXT,
  social_media JSONB,
  working_hours JSONB,
  animals_count INTEGER,
  animals_types JSONB,
  services JSONB,
  rating DECIMAL(3,1),
  reviews_count INTEGER,
  image_url TEXT,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_vets_district ON vets(district);
CREATE INDEX IF NOT EXISTS idx_vets_is_24h ON vets(is_24h);
CREATE INDEX IF NOT EXISTS idx_vets_status ON vets(status);
CREATE INDEX IF NOT EXISTS idx_places_category ON places(category);
CREATE INDEX IF NOT EXISTS idx_places_status ON places(status);
CREATE INDEX IF NOT EXISTS idx_organizations_type ON organizations(type);
CREATE INDEX IF NOT EXISTS idx_organizations_status ON organizations(status);
CREATE INDEX IF NOT EXISTS idx_shelters_city ON shelters(city);
CREATE INDEX IF NOT EXISTS idx_shelters_status ON shelters(status);

-- RLS: Public read for active records
ALTER TABLE vets ENABLE ROW LEVEL SECURITY;
ALTER TABLE places ENABLE ROW LEVEL SECURITY;
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE shelters ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_vets" ON vets;
DROP POLICY IF EXISTS "public_read_places" ON places;
DROP POLICY IF EXISTS "public_read_organizations" ON organizations;
DROP POLICY IF EXISTS "public_read_shelters" ON shelters;

CREATE POLICY "public_read_vets" ON vets FOR SELECT USING (status = 'active');
CREATE POLICY "public_read_places" ON places FOR SELECT USING (status = 'active');
CREATE POLICY "public_read_organizations" ON organizations FOR SELECT USING (status = 'active');
CREATE POLICY "public_read_shelters" ON shelters FOR SELECT USING (status = 'active');

-- ================================================================
-- SEED: vets (18 records)
-- ================================================================
INSERT INTO vets (id, name, name_local, category, description, city, district, address, phone, email, website, social_media, working_hours, services, rating, reviews_count, is_24h, status)
VALUES
('vet-001','ЗооДоктор','ZooDoctor','Ветеринарная клиника','Многопрофильная ветеринарная клиника с широким спектром услуг. Вызов на дом, рентген, хирургия. Специалисты: гинекологи, орнитологи, дерматологи, терапевты, анестезиологи, хирурги, офтальмологи, онкологи.','Ташкент',NULL,'ул. Мирабад 33, Ташкент','["+998 97 754 54 50", "+998 71 297 34 87", "+998 93 564 22 32"]',NULL,'https://zoodoctor.uz','{"telegram":null,"instagram":null,"facebook":"https://facebook.com/ZooDoctorUz"}','{"daily":"08:00–20:00"}','["Вызов на дом","Рентген","Хирургия","Пет-такси","Ветеринарная аптека","Зоогостиница","Справки","Груминг","Вакцинация","Кастрация","Чипирование","Стационар"]',5.0,441,false,'active'),
('vet-002','Ветклиника «Darel»','Darel','Ветеринарная клиника','Одна из старейших ветклиник Ташкента, более 30 лет работы.','Ташкент','Яшнабадский район','просп. Мирзо Улугбека, 1/1-6, 1 этаж','["+998 71 268 18 85", "+998 71 267 25 65"]',NULL,NULL,'{"telegram":null,"instagram":"https://instagram.com/darel_uz","facebook":"https://facebook.com/darel.uz"}','{"daily":"09:00–17:30"}','["УЗИ-диагностика","Рентген","Общая ветеринария"]',NULL,NULL,false,'active'),
('vet-003','Клиника «Доктор Айболит»','Doctor Aibolit','Ветеринарная клиника','Ветеринарная клиника с двумя филиалами в Ташкенте: основной на ул. Насаф и филиал на ул. Гагарина.','Ташкент','Яшнабадский район','ул. Насаф, 1/1','["+998 71 277 43 33", "+998 90 987 43 33"]',NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Общая ветеринария","Ветеринарная аптека"]',NULL,NULL,false,'active'),
('vet-004','Doktor-Animal','Doktor & Animals','Ветеринарная клиника + аптека','Ветеринарная клиника с аптекой. Юридическое лицо: ООО GRAND VET SERVIS.','Ташкент','Мирзо-Улугбекский район','мсг Ялангач, 27А','["+998 71 275 96 69"]','intervetfarm2011@mail.ru',NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Общая ветеринария","Ветеринарная аптека","Стерилизация","УЗИ-диагностика"]',NULL,NULL,false,'active'),
('vet-005','Nur Vet','Nur Vet Farm Servis','Ветеринарная клиника','Ветеринарная клиника с несколькими филиалами в Ташкенте.','Ташкент','Чиланзарский район','кв-л Чиланзар-2, ул. Гагарина 1, 100115','["+998 71 277 62 08", "+998 97 411 69 65"]',NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Общая ветеринария"]',NULL,NULL,false,'active'),
('vet-006','Top Animals','Top Animals','Ветеринарная клиника','Ветеринарная клиника, работающая с 2011 года.','Ташкент',NULL,NULL,'["+998 94 666 77 37", "+998 93 571 77 37"]',NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}','{"daily":"Круглосуточно"}','["УЗИ-диагностика","Хирургия","Диагностика"]',NULL,NULL,true,'active'),
('vet-007','Star Vet','Star Vet','Ветеринарная клиника','Ветеринарная клиника с 10+ летним стажем. Работает с кошками, собаками, птицами.','Ташкент','Юнусабадский район','кв-л Киёт, 68А',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":"https://facebook.com/starvet.uz"}',NULL,'["Хирургия","Диагностика","Лечение кошек, собак, птиц"]',NULL,NULL,false,'active'),
('vet-008','Deep Forest Animals','Deep Forest Animals','Ветеринарная клиника + аптека','ООО «Deep Forest Animals». Аптека, стрижка, вызов на дом, кастрация, чипирование, вакцинация, стационар.','Ташкент','Мирзо-Улугбекский район','ул. Феруза, 24, 100124','["+998 71 263 41 16", "+998 99 832 79 39", "+998 90 935 70 09", "+998 90 825 23 25"]',NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Ветеринарная аптека","Стрижка","Вызов на дом","Кастрация","Чипирование","Вакцинация","Стационар"]',NULL,NULL,false,'active'),
('vet-009','Круглосуточная клиника (Учтепинский р-н)',NULL,'Ветеринарная клиника','Круглосуточная ветеринарная клиника в Учтепинском районе.','Ташкент','Учтепинский район','кв-л Чиланзар-12, ул. Фархада, 3А',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}','{"daily":"Круглосуточно (24/7)"}','["Общая ветеринария"]',NULL,NULL,true,'active'),
('vet-010','Ветклиника на Буюк Ипак Йули, 77',NULL,'Ветеринарная клиника + лаборатория + аптека','Круглосуточная ветклиника с лабораторией и аптекой.','Ташкент','Мирзо-Улугбекский район','ул. Буюк Ипак Йули, 77',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}','{"daily":"Круглосуточно (24/7)"}','["Общая ветеринария","Лаборатория","Ветеринарная аптека"]',NULL,NULL,true,'active'),
('vet-011','Vet Drug (Буюк Ипак Йули, 473/19)','Vet Drug','Ветеринарная клиника + аптека','Круглосуточная ветклиника. Вакцинации, сложные хирургические операции. Ратолог, орнитолог, УЗИ, рентген.','Ташкент','Мирзо-Улугбекский район','ул. Буюк Ипак Йули, 473/19',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}','{"daily":"Круглосуточно (24/7)"}','["Ветеринарная аптека","Вакцинация","Хирургия","Ратология","Орнитология","УЗИ-диагностика","Рентген"]',NULL,NULL,true,'active'),
('vet-012','NBS Vet Service (пр. Мирзо Улугбека, 49)','NBS VET SERVICE','Ветеринарная клиника + лаборатория','Ветклиника с лабораторией. Юр. лицо: NBS VET SERVICE LTD.','Ташкент','Мирзо-Улугбекский район','просп. Мирзо Улугбека, 49, 111227',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Общая ветеринария","Лаборатория"]',NULL,NULL,false,'active'),
('vet-013','Doctor Vet (Авиасозлар-2)','Doctor Vet','Ветеринарная клиника','Ветеринарная клиника в Яшнабадском районе. Рядом: рынок Авиасозлар.','Ташкент','Яшнабадский район','м-в Авиасозлар-2, 56А, 100204',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Общая ветеринария"]',NULL,NULL,false,'active'),
('vet-014','Ветклиника (ул. Феруза, 18А)',NULL,'Ветеринарная клиника','Ветеринарная клиника в Мирзо-Улугбекском районе.','Ташкент','Мирзо-Улугбекский район','м-в Феруза-1, ул. Феруза, 18А',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Общая ветеринария"]',NULL,NULL,false,'active'),
('vet-015','Ветклиника (м-в Каракамыш-2/4)',NULL,'Ветеринарная клиника','Ветеринарная клиника в Алмазарском районе.','Ташкент','Алмазарский район','м-в Каракамыш-2/4, 1/1',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Общая ветеринария"]',NULL,NULL,false,'active'),
('vet-016','Ветклиника (ул. Олмос, 13)',NULL,'Ветеринарная клиника','Ветеринарная клиника на улице Олмос.','Ташкент',NULL,'ул. Олмос, 13',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}','{"daily":"08:00–20:00"}','["Общая ветеринария"]',NULL,NULL,false,'active'),
('vet-017','Ветклиника (ул. Рихсили, 2А)',NULL,'Ветеринарная клиника','Ветеринарная клиника на улице Рихсили.','Ташкент',NULL,'ул. Рихсили, 2А',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Общая ветеринария"]',NULL,NULL,false,'active'),
('vet-018','VET LIDER (ТашГРЭС, 26)','VET LIDER','Ветеринарная клиника','Круглосуточная ветеринарная клиника в Юнусабадском районе.','Ташкент','Юнусабадский район','мкр ТашГРЭС, 26/10, 100164',NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}','{"daily":"Круглосуточно (24/7)"}','["Общая ветеринария"]',NULL,NULL,true,'active')
ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, updated_at=NOW();

-- ================================================================
-- SEED: places (10 records)
-- ================================================================
INSERT INTO places (id, name, name_local, type, category, description, founded, city, district, address, phone, website, social_media, working_hours, pricing, features, rating, status, notes)
VALUES
('pf-001','Cats & Friends','Котокафе Cats & Friends','Котокафе','Котокафе','Первое котокафе в Узбекистане (2024). Антикафе и коворкинг с кошками из приюта «Милые Кошки». 12 стерилизованных кошек. Бесплатные напитки и WiFi. По субботам — пристройство кошек.',2024,'Ташкент','Мирзо-Улугбекский район','ул. Аккурган, 10',NULL,NULL,'{"telegram":null,"instagram":"https://instagram.com/catsandfriends.uz","facebook":null}','{"daily":"10:00–22:00"}','{"first_hour":"38 000 сум","additional_hour":"20 000 сум"}','["12 кошек из приюта","Бесплатные напитки","WiFi","Коворкинг","Пристройство по субботам 11:00–20:00"]',NULL,'active','Партнёр приюта «Милые Кошки»'),
('pf-002','PetZoo.uz','ПетЗу','Зоомагазин','Зоомагазин','Зоомагазин и платформа зоотоваров. Корм, витамины, лакомства, аксессуары, игрушки, переноски. 96% рекомендаций.',NULL,'Ташкент',NULL,'ул. Чиланзарская, 3-й квартал, дом 23','["+998 93 555 55 20"]','https://petzoo.uz','{"telegram":null,"instagram":null,"facebook":"https://facebook.com/aquamarineuzbekistan"}',NULL,NULL,'["Корм для животных","Витамины и лакомства","Аксессуары и игрушки","Переноски","Аквариумные товары"]',4.8,'active','96% рекомендуют (35 отзывов)'),
('pf-003','ZOOMARKET Pet Shop','Зоомаркет','Зоомагазин','Зоомагазин','Зоомагазин в Мирзо-Улугбекском районе Ташкента.',NULL,'Ташкент','Мирзо-Улугбекский район','ул. Сайрам, 25, 100170',NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,NULL,'["Зоотовары","Корм для животных"]',NULL,'active',NULL),
('pf-004','Animal Pet Shop','Анимал Пет Шоп','Зоомагазин','Зоомагазин','Зоомагазин на проспекте Мирзо Улугбека.',NULL,'Ташкент','Мирзо-Улугбекский район','просп. Мирзо Улугбека, 40',NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}',NULL,NULL,'["Зоотовары","Корм для животных"]',NULL,'active',NULL),
('pf-005','Star Dog Grooming Salon','Стар Дог','Груминг-салон','Груминг','Груминг-салон: салонный, выставочный груминг, SPA-процедуры, креативный груминг, экспресс-линька.',NULL,'Ташкент',NULL,'ул. Бобура, 67/6','["+998 93 515 17 39"]',NULL,'{"telegram":null,"instagram":null,"facebook":"https://facebook.com/stardog67"}',NULL,NULL,'["Салонный груминг","Выставочный груминг","SPA-процедуры","Креативный груминг","Экспресс-линька"]',NULL,'active',NULL),
('pf-006','Zoo Grooming','Зу Груминг','Груминг-салон','Груминг','Груминг-салон в Мирзо-Улугбекском районе.',NULL,'Ташкент','Мирзо-Улугбекский район','Буюк Ипак Йули, 27','["+998 99 789 11 99"]',NULL,'{"telegram":null,"instagram":null,"facebook":null}','{"daily":"до 19:00"}',NULL,'["Груминг собак и кошек"]',NULL,'active','Есть на 2GIS'),
('pf-007','КотоПёс Груминг','KotoPes Grooming','Груминг-салон','Груминг','Груминг-салон для кошек и собак.',NULL,'Ташкент',NULL,NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":"https://facebook.com/groomfetisova.uz"}',NULL,NULL,'["Груминг кошек и собак"]',NULL,'active','Связь через Facebook'),
('pf-008','Courtyard by Marriott Tashkent',NULL,'Зоогостиница / Pet-friendly отель','Зоогостиница','Pet-friendly отель с удобствами для животных.',NULL,'Ташкент',NULL,NULL,NULL,'https://www.marriott.com','{"telegram":null,"instagram":null,"facebook":null}','{"daily":"Круглосуточно"}',NULL,'["Размещение с животными","Миски для еды и воды","Прогулки для собак","Специальное меню для питомцев"]',NULL,'active','Pet-friendly'),
('pf-009','InterContinental Tashkent',NULL,'Зоогостиница / Pet-friendly отель','Зоогостиница','Пятизвёздочный отель, принимающий гостей с животными.',NULL,'Ташкент',NULL,NULL,NULL,'https://www.ihg.com','{"telegram":null,"instagram":null,"facebook":null}','{"daily":"Круглосуточно"}',NULL,'["Размещение с животными","Миски для еды и воды"]',9.8,'active','IHG'),
('pf-010','Europe Hotel Tashkent',NULL,'Зоогостиница / Pet-friendly отель','Зоогостиница','Отель, принимающий всех животных.',NULL,'Ташкент',NULL,NULL,NULL,NULL,'{"telegram":null,"instagram":null,"facebook":null}','{"daily":"Круглосуточно"}',NULL,'["Размещение с любыми животными"]',9.2,'active','Принимает всех животных')
ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, updated_at=NOW();

-- ================================================================
-- SEED: organizations (5 records)
-- ================================================================
INSERT INTO organizations (id, name, name_local, type, category, description, founded, city, address, phone, email, website, social_media, working_hours, services, rating, status, notes)
VALUES
('nno-001','Mehr va Oqibat','Мехр ва Оқибат','ННО','Зоозащитная организация','Старейшая и первая благотворительная организация по защите животных в Узбекистане. Основана в 2010. Стерилизация (8000+ животных), правовая защита, образовательные программы, рассмотрение случаев жестокого обращения (3000+ дел).',2010,'Ташкент','ул. Сайрам 25, Ташкент, 100170','["+998 93 564 22 32"]','mvouzb@gmail.com','https://mehrvaoqibat.uz','{"telegram":"https://t.me/mehrvaoqibat","instagram":"https://instagram.com/mehrvaoqibat","facebook":"https://facebook.com/mehrvaoqibat"}','{"weekdays":"09:00–18:00","saturday":"Закрыто","sunday":"Закрыто"}','["Стерилизация животных","Правовая защита","Образовательные программы","Расследование жестокости","Законодательная адвокация"]',NULL,'active','Стерилизовано 8000+ животных, рассмотрено 3000+ случаев'),
('nno-002','Мушуккент','Mushukkent','Проект/ННО','Защита бездомных кошек','Проект по уходу за бездомными кошками Ташкента. Запущен в 2019. Установка уличных кошачьих домиков. Связан с ННО «Хаёт». Партнёр — Uzum Bank.',2019,'Ташкент',NULL,NULL,NULL,'https://mushukkent.uz','{"telegram":"https://t.me/mushukkent","instagram":"https://instagram.com/mushukkent","facebook":"https://facebook.com/groups/Mushukkent"}',NULL,'["Установка кошачьих домиков","Забота о бездомных кошках","Кормление","Пристройство кошек","Волонтёрская программа"]',NULL,'active','Волонтёры: @volonteer_mushukkent. Партнёр: Uzum Bank.'),
('nno-003','Приют MEHR','MEHR Shelter','Корпоративный приют','Приют при корпорации','Первый приют в Узбекистане с ветеринарной и кинологической службой. Построен AKFA Group в 2021. До 1200 животных, 11 блоков на 1 гектаре. Без усыпления. Международные усыновления.',2021,'Пскентский район, Ташкентская область','Ташкентская область, Пскентский район','["+998 95 196 80 80"]',NULL,'https://akfagroup.com','{"telegram":null,"instagram":null,"facebook":null}',NULL,'["Спасение животных","Ветеринарная помощь","Кинологическая служба","Социализация","Стерилизация","Микрочипирование","Международное усыновление"]',NULL,'active','Лауреат Central Asia Employer Brand Award. До 1200 собак.'),
('nno-004','PetZoo.uz','ПетЗу','Платформа','Зоомагазин / платформа','Зоомагазин и платформа зоотоваров. Дистрибьютор брендов Profine и TRIXIE.',NULL,'Ташкент','ул. Чиланзарская, 3-й квартал, дом 23','["+998 93 555 55 20"]',NULL,'https://petzoo.uz','{"telegram":null,"instagram":null,"facebook":"https://facebook.com/aquamarineuzbekistan"}',NULL,'["Продажа зоотоваров","Корм","Аксессуары","Аквариумные товары","Дистрибьюция брендов"]',NULL,'active','96% рекомендуют (35 отзывов)'),
('nno-005','Hayot Is Life','Ҳаёт — Это жизнь','Сайт приюта','Приют / платформа усыновления','Первый официальный приют для животных в Узбекистане. Основан в 2018. На волонтёрской поддержке. 6000+ собак, 2500+ пристроено.',2018,'Ташкент','Кибрайский район, ~25 км от центра Ташкента','["+998 90 357 44 77"]',NULL,'https://hayotislife.com','{"telegram":null,"instagram":"https://instagram.com/hayot_is_life_eng","facebook":null}',NULL,'["Спасение собак","Стерилизация","Микрочипирование","Усыновление","Ветеринарная помощь"]',4.5,'active','Рейтинг 4.5/5 на Trustpilot. Крупнейший приют по количеству животных.')
ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name, description=EXCLUDED.description, updated_at=NOW();
