import sqlite3
import logging
import asyncio
from aiogram import Bot, Dispatcher, types, F
from aiogram.filters import Command
from aiogram.utils.keyboard import ReplyKeyboardBuilder

# ДАННЫЕ БОТА (Твой токен уже тут)
TELEGRAM_TOKEN = "8592968215:AAHmN6QRyHUApyeYHCb1-GGcoJx3uBBb5rc"

bot = Bot(token=TELEGRAM_TOKEN)
dp = Dispatcher()

# База данных для подписчиков
def init_db():
    conn = sqlite3.connect('neuroson.db')
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY)')
    conn.commit()
    conn.close()

def add_user(user_id):
    conn = sqlite3.connect('neuroson.db')
    cursor = conn.cursor()
    cursor.execute('INSERT OR IGNORE INTO users (id) VALUES (?)', (user_id,))
    conn.commit()
    conn.close()

# Главное меню
def main_menu():
    builder = ReplyKeyboardBuilder()
    builder.button(text="😴 Сон")
    builder.button(text="🧠 Мозг")
    builder.button(text="💊 БАДы")
    builder.button(text="📢 Наш канал", url="https://t.me/neuro_sleep_science")
    builder.adjust(2, 1)
    return builder.as_markup(resize_keyboard=True)

@dp.message(Command("start"))
async def start(message: types.Message):
    add_user(message.from_user.id)
    await message.answer(
        f"Привет, {message.from_user.first_name}! Это ИИ-помощник канала Нейросон.🧬\n\nВыбирай раздел:",
        reply_markup=main_menu()
    )

@dp.message(F.text == "😴 Сон")
async def sleep_tip(message: types.Message):
    await message.answer("🌙 **Сон:** Спи в полной темноте и прохладе. Мелатонин вырабатывается лучше при 18-20°C.")

@dp.message(F.text == "🧠 Мозг")
async def brain_tip(message: types.Message):
    await message.answer("🧠 **Мозг:** Новые знания и физическая активность — лучшие способы сохранить нейропластичность.")

@dp.message(F.text == "💊 БАДы")
async def supp_tip(message: types.Message):
    await message.answer("💊 **БАДы:** Магний помогает расслабиться перед сном, а Омега-3 полезна для сосудов мозга. Но сначала — анализы!")

async def main():
    init_db()
    await dp.start_polling(bot)

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    asyncio.run(main())
