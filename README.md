# 🐾 ZooJoy

**Единая платформа зоозащиты Узбекистана** — справочник приютов, ветклиник, pet-friendly мест, организаций и каталог животных ищущих дом.

---

## Что это

Статический сайт (HTML/CSS/JS) с динамической загрузкой данных из Supabase. Данные хранятся в PostgreSQL через Supabase и отдаются через REST API прямо в браузер.

**Разделы:**
- 🐾 Каталог — животные ищущие дом
- 🏠 Приюты — приюты для животных
- 🏥 Ветклиники — ветеринарные клиники
- 📍 Места — котокафе, зоомагазины, груминг, зоогостиницы
- 🤝 Организации — зоозащитные НКО и фонды

---

## Быстрый старт

### 1. Создай Supabase проект

1. Зайди на [supabase.com](https://supabase.com) → New Project
2. Запомни **Project URL** и **anon public key** (Settings → API)

### 2. Создай таблицы

В Supabase Dashboard → SQL Editor выполни скрипт из `data/schema.sql`:

```sql
-- Просто вставь содержимое data/schema.sql и выполни
```

Скрипт создаёт 5 таблиц: `shelters`, `vets`, `places`, `organizations`, `animals` — с нужными полями, индексами и RLS политиками (публичное чтение).

### 3. Настрой credentials

Отредактируй файл `api.js`:

```js
const SUPABASE_URL = 'https://YOUR_PROJECT_REF.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY';
```

Замени также в `supabase-config.js` и `sb.js`.

### 4. Запусти локально

```bash
python3 -m http.server 8080
# Открой http://localhost:8080
```

---

## Структура таблиц

### `animals` — Каталог животных
| Поле | Тип | Описание |
|------|-----|----------|
| id | TEXT (PK) | `animal-001` |
| name | TEXT | Кличка |
| type | TEXT | `cat` / `dog` / `other` |
| breed | TEXT | Порода |
| age | TEXT | Возраст (`"2 года"`, `"3 месяца"`) |
| gender | TEXT | `male` / `female` |
| description | TEXT | Описание |
| shelter_id | TEXT | ID приюта (ссылка на `shelters.id`) |
| shelter_name | TEXT | Название приюта |
| city | TEXT | Город |
| **status** | TEXT | **`home`** — ищет дом / **`urgent`** — срочно / `adopted` — пристроен |
| emoji | TEXT | Эмодзи (`🐱`, `🐶`) |
| image_url | TEXT | URL фото |
| notes | TEXT | Заметки |

### `shelters` — Приюты
| Поле | Тип | Описание |
|------|-----|----------|
| id | TEXT (PK) | `shelter-001` |
| name | TEXT | Название приюта |
| name_local | TEXT | Локальное название |
| type | TEXT | Тип (Приют для собак / кошек) |
| animal_type | TEXT | Тип животных |
| description | TEXT | Описание |
| founded | INTEGER | Год основания |
| founder | TEXT | Основатель |
| city | TEXT | Город |
| district | TEXT | Район |
| address | TEXT | Адрес |
| lat / lng | DECIMAL | Координаты |
| phone | JSONB | Массив телефонов: `["+998 90 000 00 00"]` |
| email | TEXT | Email |
| website | TEXT | Сайт |
| social_media | JSONB | `{"telegram": "...", "instagram": "...", "facebook": "..."}` |
| working_hours | JSONB | `{"daily": "09:00-18:00"}` |
| capacity | TEXT | Вместимость (`"7000+"`) |
| adopted_count | TEXT | Пристроено (`"3500+"`) |
| services | JSONB | Массив услуг: `["Стерилизация", "Вакцинация"]` |
| rating | DECIMAL | Рейтинг |
| image_url | TEXT | URL фото |
| **status** | TEXT | **`active`** / `inactive` / `pending` |
| notes | TEXT | Заметки |

### `vets` — Ветклиники
| Поле | Тип | Описание |
|------|-----|----------|
| id | TEXT (PK) | `vet-001` |
| name | TEXT | Название |
| category | TEXT | Категория (Ветеринарная клиника / + аптека / + лаборатория) |
| description | TEXT | Описание |
| city | TEXT | Город |
| district | TEXT | Район |
| address | TEXT | Адрес |
| phone | JSONB | Массив телефонов |
| email | TEXT | Email |
| website | TEXT | Сайт |
| social_media | JSONB | Соцсети |
| working_hours | JSONB | Часы работы |
| services | JSONB | Услуги |
| rating | DECIMAL | Рейтинг |
| reviews_count | INTEGER | Количество отзывов |
| **is_24h** | BOOLEAN | Круглосуточная? |
| status | TEXT | `active` / `inactive` |

### `places` — Pet-friendly места
| Поле | Тип | Описание |
|------|-----|----------|
| id | TEXT (PK) | `pf-001` |
| name | TEXT | Название |
| **type** | TEXT | **Котокафе / Зоомагазин / Груминг-салон / Зоогостиница / Pet-friendly отель** |
| category | TEXT | Подкатегория |
| description | TEXT | Описание |
| founded | INTEGER | Год открытия |
| city | TEXT | Город |
| address | TEXT | Адрес |
| phone | JSONB | Телефоны |
| website | TEXT | Сайт |
| social_media | JSONB | Соцсети |
| working_hours | JSONB | Часы |
| pricing | JSONB | `{"first_hour": "38 000 сум", "additional_hour": "20 000 сум"}` |
| features | JSONB | Особенности: `["WiFi", "Бесплатные напитки"]` |
| rating | DECIMAL | Рейтинг |
| status | TEXT | `active` / `inactive` |
| notes | TEXT | Заметки |

### `organizations` — Организации и НКО
| Поле | Тип | Описание |
|------|-----|----------|
| id | TEXT (PK) | `nno-001` |
| name | TEXT | Название |
| type | TEXT | ННО / Проект/ННО / Корпоративный приют / Платформа |
| category | TEXT | Категория |
| description | TEXT | Описание |
| founded | INTEGER | Год основания |
| city | TEXT | Город |
| address | TEXT | Адрес |
| phone | JSONB | Телефоны |
| email | TEXT | Email |
| website | TEXT | Сайт |
| social_media | JSONB | Соцсети |
| working_hours | JSONB | Часы работы |
| services | JSONB | Услуги/направления |
| rating | DECIMAL | Рейтинг |
| status | TEXT | `active` / `inactive` |
| notes | TEXT | Заметки |

---

## RLS (Row Level Security)

В схеме настроены политики: **анонимные пользователи могут только читать** записи. Запись, обновление и удаление требуют `service_role` ключ.

Только `active` записи показываются на сайте (кроме `animals` — там показываются `home` и `urgent`).

---

## Admin Panel

Для управления данными — отдельный проект **ZooJoy-Admin**.

Он использует `service_role` ключ для полного CRUD доступа. **Не выкладывай `service_role` ключ в публичный репозиторий!**

---

## Стек

- **Frontend**: HTML5, CSS3, JavaScript (vanilla)
- **Шрифты**: Google Fonts — Nunito
- **БД**: Supabase (PostgreSQL + REST API)
- **Деплой**: любой статический хостинг (Netlify, Vercel, GitHub Pages и др.)

---

## Файлы конфигурации

| Файл | Назначение |
|------|-----------|
| `api.js` | Supabase credentials + функция `sbFetch()` |
| `supabase-config.js` | Дублирующий конфиг (legacy) |
| `data/schema.sql` | SQL схема для создания таблиц |
| `data/*.json` | Исходные данные для заполнения БД |
| `styles.css` | Глобальные стили |
| `script.js` | Общий JS (анимации, навигация) |

---

## Лицензия

MIT — используй свободно, с указанием авторства.
