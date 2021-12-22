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
                            .new(keyboard: options_numbers, one_time_keyboard: true)
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

# {:message_id=>654,
#     :from=><Telegram::Bot::Types::User:0x00007fd26e8266b0
#         @id=173267176,
#         @is_bot=false,
#         @first_name="Gabriel",
#         @last_name="Vasconcelos",
#         @username="Gabriel_vs",
#         @language_code="pt-br",
#         @can_join_groups=nil,
#         @can_read_all_group_messages=nil,
#         @supports_inline_queries=nil>,
#     :sender_chat=>nil,
#     :date=>1640123750,
#     :chat=><Telegram::Bot::Types::Chat:0x00007fd26e819a00
#         @id=173267176,
#         @first_name="Gabriel",
#         @last_name="Vasconcelos",
#         @username="Gabriel_vs",
#         @type="private",
#         @title=nil,
#         @all_members_are_administrators=nil,
#         @photo=nil,
#         @description=nil,
#         @invite_link=nil,
#         @pinned_message=nil,
#         @permissions=nil,
#         @slow_mode_delay=nil,
#         @sticker_set_name=nil,
#         @can_set_sticker_set=nil>,
#     :forward_from=>nil,
#     :forward_from_chat=>nil,
#     :forward_from_message_id=>nil,
#     :forward_signature=>nil,
#     :forward_sender_name=>nil,
#     :forward_date=>nil,
#     :reply_to_message=>nil,
#     :via_bot=>nil,
#     :edit_date=>nil,
#     :media_group_id=>nil,
#     :author_signature=>nil,
#     :text=>"/start",
#     :entities=>[<Telegram::Bot::Types::MessageEntity:0x00007fd26ac5d340
#             @offset=0,
#             @length=6,
#             @type="bot_command",
#             @url=nil,
#             @user=nil,
#             @language=nil>],
#     :caption_entities=>[],
#     :audio=>nil,
#     :document=>nil,
#     :animation=>nil,
#     :game=>nil,
#     :photo=>[],
#     :sticker=>nil,
#     :video=>nil,
#     :voice=>nil,
#     :video_note=>nil,
#     :caption=>nil,
#     :contact=>nil,
#     :dice=>nil,
#     :location=>nil,
#     :venue=>nil,
#     :poll=>nil,
#     :new_chat_members=>[],
#     :left_chat_member=>nil,
#     :new_chat_title=>nil,
#     :new_chat_photo=>[],
#     :delete_chat_photo=>nil,
#     :group_chat_created=>nil,
#     :supergroup_chat_created=>nil,
#     :channel_chat_created=>nil,
#     :message_auto_delete_timer_changed=>nil,
#     :migrate_to_chat_id=>nil,
#     :migrate_from_chat_id=>nil,
#     :pinned_message=>nil,
#     :invoice=>nil,
#     :successful_payment=>nil,
#     :connected_website=>nil,
#     :passport_data=>nil,
#     :proximity_alert_triggered=>nil,
#     :voice_chat_started=>nil,
#     :voice_chat_ended=>nil,
#     :voice_chat_participants_invited=>nil,
#     :reply_markup=>nil
# }

# h = {:message_id=>767,
#     :from=>#<Telegram::Bot::Types::User:0x00007ffd9c077758
#         @id=173267176,
#         @is_bot=false,
#         @first_name="Gabriel",
#         @last_name="Vasconcelos",
#         @username="Gabriel_vs",
#         @language_code="pt-br",
#         @can_join_groups=nil,
#         @can_read_all_group_messages=nil,
#         @supports_inline_queries=nil>,
#     :sender_chat=>nil,
#     :date=>1640147399,
#     :chat=>#<Telegram::Bot::Types::Chat:0x00007ffd9c076da8
#         @id=-748914955,
#         @title="U",
#         @type="group",
#         @all_members_are_administrators=true,
#         @username=nil,
#         @first_name=nil,
#         @last_name=nil,
#         @photo=nil,
#         @description=nil,
#         @invite_link=nil,
#         @pinned_message=nil,
#         @permissions=nil,
#         @slow_mode_delay=nil,
#         @sticker_set_name=nil,
#         @can_set_sticker_set=nil>,
#     :forward_from=>nil,
#     :forward_from_chat=>nil,
#     :forward_from_message_id=>nil,
#     :forward_signature=>nil,
#     :forward_sender_name=>nil,
#     :forward_date=>nil,
#     :reply_to_message=>nil,
#     :via_bot=>nil,
#     :edit_date=>nil,
#     :media_group_id=>nil,
#     :author_signature=>nil,
#     :text=>"/start",
#     :entities=>[#<Telegram::Bot::Types::MessageEntity:0x00007ffd9c074198 @offset=0,
#             @length=6,
#             @type="bot_command",
#             @url=nil,
#             @user=nil,
#             @language=nil>],
#     :caption_entities=>[],
#     :audio=>nil,
#     :document=>nil,
#     :animation=>nil,
#     :game=>nil,
#     :photo=>[],
#     :sticker=>nil,
#     :video=>nil,
#     :voice=>nil,
#     :video_note=>nil,
#     :caption=>nil,
#     :contact=>nil,
#     :dice=>nil,
#     :location=>nil,
#     :venue=>nil,
#     :poll=>nil,
#     :new_chat_members=>[],
#     :left_chat_member=>nil,
#     :new_chat_title=>nil,
#     :new_chat_photo=>[],
#     :delete_chat_photo=>nil,
#     :group_chat_created=>nil,
#     :supergroup_chat_created=>nil,
#     :channel_chat_created=>nil,
#     :message_auto_delete_timer_changed=>nil,
#     :migrate_to_chat_id=>nil,
#     :migrate_from_chat_id=>nil,
#     :pinned_message=>nil,
#     :invoice=>nil,
#     :successful_payment=>nil,
#     :connected_website=>nil,
#     :passport_data=>nil,
#     :proximity_alert_triggered=>nil,
#     :voice_chat_started=>nil,
#     :voice_chat_ended=>nil,
#     :voice_chat_participants_invited=>nil,
#     :reply_markup=>nil}