from dotenv import load_dotenv
from src import controller
import telebot
import os

load_dotenv()

bot = telebot.TeleBot(os.getenv('BOT_TOKEN'), parse_mode=None)

@bot.message_handler(commands=['start'])
def start(msg):
    bot.send_message(msg.chat.id, 'Vamos escolher um date!!! 🥰🍷')

# Command that creates a new Activity
@bot.message_handler(commands=['catv'])
def add_activity(msg):
    if controller.is_new(msg.chat):
        controller.create_new(msg.chat)

    reply_msg = 'Atividade cadastrada 😃' if controller.create_activity(msg) else 'Algo deu errado 😫\nTente novamente'
    bot.reply_to(msg, reply_msg)

# Lists all the registered activities of the current chat
@bot.message_handler(commands=['list'])
def list_activities(msg):
    actvs_list = controller.list_actvs(msg)
    reply_msg = actvs_list if len(actvs_list) > 0 else 'Voce ainda nao cadastrou nenhuma atividade 😫'

    bot.reply_to(msg, reply_msg)

# Removes an activity with a given description/name
@bot.message_handler(commands=['rm'])
def remove_activity(msg):
    description = controller.remove_actv(msg)
    bot.reply_to(msg, f'Atividade <{description}> removida! 😌')

bot.infinity_polling()
