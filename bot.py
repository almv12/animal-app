#!/usr/bin/env python3
"""ZooJoy Telegram bot — handles /start and sends Web App button."""

import json, time, urllib.request, urllib.parse, os

BOT_TOKEN = "8756484875:AAE327TeTfWCsNwRrJ8iJrYJ4l4VU2j37BI"
SITE_URL  = "https://pet.vaganian.tech"
BASE_URL  = f"https://api.telegram.org/bot{BOT_TOKEN}"
OFFSET_FILE = "/tmp/zoojoy_bot_offset.txt"

def api(method, **params):
    data = urllib.parse.urlencode({k: json.dumps(v) if isinstance(v, (dict, list)) else v for k, v in params.items()}).encode()
    req  = urllib.request.Request(f"{BASE_URL}/{method}", data=data)
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)

def send_start(chat_id):
    api("sendMessage",
        chat_id=chat_id,
        text="🐾 *Добро пожаловать в ZooJoy!*\n\nМы помогаем бездомным животным Узбекистана найти дом.\n\nНажми кнопку ниже, чтобы открыть платформу 👇",
        parse_mode="Markdown",
        reply_markup={
            "inline_keyboard": [[
                {"text": "🐾 Открыть ZooJoy", "web_app": {"url": SITE_URL}}
            ]]
        }
    )

def main():
    offset = 0
    if os.path.exists(OFFSET_FILE):
        try: offset = int(open(OFFSET_FILE).read().strip())
        except: pass

    print(f"ZooJoy bot started. Polling... offset={offset}")
    while True:
        try:
            result = api("getUpdates", offset=offset, timeout=25, allowed_updates=["message"])
            for upd in result.get("result", []):
                offset = upd["update_id"] + 1
                msg = upd.get("message", {})
                text = msg.get("text", "")
                chat_id = msg.get("chat", {}).get("id")
                if chat_id and text.startswith("/start"):
                    send_start(chat_id)
                    print(f"Sent start to {chat_id}")
            open(OFFSET_FILE, "w").write(str(offset))
        except Exception as e:
            print(f"Error: {e}")
            time.sleep(5)

if __name__ == "__main__":
    main()
