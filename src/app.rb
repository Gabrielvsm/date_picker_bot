require 'telegram/bot'
require_relative './handlers'

token = ENV['BOT_TOKEN']
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
        text = 'vamos escolher um date!!! 🥰🍷'
        bot.api.send_message(chat_id: chat_id, text: text)
      when '/pickdate'
        game[:options], options_numbers = get_options(message)
        text = 'escolha uma opção!! ⤵'
        re_markup = Telegram::Bot::Types::ReplyKeyboardMarkup
                    .new(keyboard: options_numbers, one_time_keyboard: true)
        game[:going?] = true
        bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: re_markup)
      when %r{^/catv\s.*$}
        resp = catv(message)
        resp = if resp
                 resp == 'exists' ? 'essa atividade já está cadastrada 🤪' : 'atividade cadastrada! 😃'
               else
                 "algo deu errado 😫\ntente novamente"
               end
        bot.api.send_message(
          chat_id: chat_id,
          text: resp,
          reply_to_message_id: message.message_id
        )
      when %r{^/rm\s.*$}
        resp = remove(message)
        resp = if resp
                 resp == 'not found' ? 'atividade nao encontrada 😫' : 'atividade removida! 😃'
               else
                 resp = "algo deu errado 😫\ntente novamente"
               end
        bot.api.send_message(
          chat_id: chat_id,
          text: resp,
          reply_to_message_id: message.message_id
        )
      when %r{^/list$}
        list_ = list(message)
        resp = "sua lista de atividades 🔖 ⤵\n\n#{list_}"
        bot.api.send_message(
          chat_id: chat_id,
          text: resp,
          reply_to_message_id: message.message_id
        )
      when /^\d+$/
        if game[:going?]
          actv = game[:options][message.text.to_i - 1].capitalize
          bot.api.send_message(chat_id: chat_id, text: 'vocês irão 🤫', reply_to_message_id: message.message_id)
          3.times { bot.api.send_message(chat_id: chat_id, text: '...') }
          bot.api.send_message(chat_id: chat_id, text: "#{actv}!!!")
        end
      else
        bot.api.send_message(
          chat_id: chat_id,
          text: 'comando não reconhecido 😫',
          reply_to_message_id: message.message_id
        )
      end
    else
      bot.api.send_message(
        chat_id: chat_id,
        text: 'você não esta cadastrado 😫'
      )
    end
  end
end
