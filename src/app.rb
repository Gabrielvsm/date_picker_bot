require 'telegram/bot'
require_relative './handlers'
require_relative '../env'

token = Env::BOT_TOKEN
game = {
    going?: false,
    options: []
}

Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
        chat_id = message.chat.id
        if Chat.exists?(chat_id)
            case message.text
            when '/start'
                text = 'Vamos escolher um date!!! 🥰🍷'
                bot.api.send_message(chat_id: chat_id, text: text)
            when '/pickdate'
                game[:options], options_numbers = get_options(message)
                text = "Escolha uma opção!! ⤵"
                re_markup = Telegram::Bot::Types::ReplyKeyboardMarkup
                            .new(
                                keyboard: options_numbers,
                                one_time_keyboard: true,
                                resize_keyboard: true
                            )
                game[:going?] = true
                bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: re_markup)
            when /^\/catv/
                resp = catv(message)
                if resp
                    resp = resp == 'exists' ? 'Essa atividade já está cadastrada 🤪' : 'Atividade cadastrada! 😃'
                else
                    resp = "Algo deu errado 😫\nTente novamente"
                end
                bot.api.send_message(
                    chat_id: chat_id,
                    text: resp,
                    reply_to_message_id: message.message_id)
            when /^\/rm/
                resp = remove(message)
                if resp
                    resp = resp == 'not found' ? 'Atividade nao encontrada 😫' : 'Atividade removida! 😃'
                else
                    resp = "Algo deu errado 😫\nTente novamente"
                end
                bot.api.send_message(
                    chat_id: chat_id,
                    text: resp,
                    reply_to_message_id: message.message_id)
            when /^\/list/
                list_ = list(message)
                resp = "Sua lista de atividades 🔖 ⤵\n\n#{list_}"
                bot.api.send_message(
                    chat_id: chat_id,
                    text: resp,
                    reply_to_message_id: message.message_id)
            when /^\d+$/
                if game[:going?]
                    actv = game[:options][message.text.to_i - 1].capitalize
                    bot.api.send_message(chat_id: chat_id, text: "Vocês irão 🤫", reply_to_message_id: message.message_id)
                    3.times { bot.api.send_message(chat_id: chat_id, text: "...") }
                    bot.api.send_message(chat_id: chat_id, text: "#{actv}!!!")
                    game[:going?] = false
                end
            else
                bot.api.send_message(
                    chat_id: chat_id,
                    text: 'Comando não reconhecido 😫',
                    reply_to_message_id: message.message_id
                )
            end
        else
            bot.api.send_message(
                chat_id: chat_id,
                text: 'Você não esta cadastrado 😫',
            )
        end
    end
end
