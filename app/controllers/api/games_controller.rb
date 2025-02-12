class API::GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    games = Game
      .includes(:host, :users, :actions, :winner)
      .order(created_at: :desc)
      .where(cancelled_at: nil)

    if params[:filter] == "your_cloned"
      games = games.where(host_id: params[:host_id]).where.not(cloned_from_game: nil)
    else
      games = games.where(cloned_from_game: nil)

      if params[:filter] == "finished"
        games = games.where.not(winner: nil) if params[:filter] == "finished"
      end
    end

    render json: games.map(&:to_json)
  end

  def create
    host = User.find(params[:id])
    game_name = lovely_string
    game = Game.create(
      name: game_name,
      host: host,
      base_game: params[:base_game],
      variant: params[:variant],
      is_public: params[:is_game_public]
    )
    host.games << game

    if ENV["RAILS_ENV"] == "production" && params[:create_discord_channel]
      uri = URI(ENV["DISCORD_CREATE_CHANNEL_URL"])
      payload = {
        name: game_name.tr(" ", "-"),
        type: 0,
        parent_id: ENV["DISCORD_GAME_CHANNEL_CATEGORY"]
      }.to_json

      response = Net::HTTP.post(
        uri,
        payload,
        "Content-Type" => "application/json",
        "authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
      )
      discord_channel_id = JSON.parse(response.body)["id"]
      if discord_channel_id
        game.update(discord_channel_id: discord_channel_id)
        uri = URI("https://discord.com/api/channels/#{game.discord_channel_id}/messages")
        Net::HTTP.post(
          uri,
          {
            content: "#{game.name} has begun!",
            embeds: [
              title: game.name,
              url: "https://www.playimperial.club/game/#{game.id}"
            ]
          }.to_json,
          "Content-Type" => "application/json",
          "authorization" => "Bot #{ENV["DISCORD_TOKEN"]}"
        )
      end
    end

    render json: game.to_json
  end

  private

  def lovely_string
    ADJECTIVES.sample + " " + NOUNS.sample
  end

  ADJECTIVES = [
    "autumn", "hidden", "bitter", "misty", "silent", "empty", "dry", "dark", "summer", "icy", "delicate", "quiet", "white", "cool", "spring", "winter", "patient", "twilight", "dawn", "crimson", "wispy", "weathered", "blue", "billowing", "broken", "cold", "damp", "falling", "frosty", "green", "long", "late", "lingering", "bold", "little", "mourning", "muddy", "old", "red", "rough", "still", "small", "sparkling", "throbbing", "shy", "wandering", "withered", "wild", "black", "young", "holy", "solitary", "fragrant", "aged", "snowy", "proud", "floral", "restless", "divine", "polished", "ancient", "purple", "lively", "nameless", "verklempt", "filipendulous", "friable", "gezellig", "aleatory", "novaturient", "capernoited", "cosmogyral", "foudroyant", "glacous", "solivagant", "arcadian", "incalescent", "nubivagant", "orotund", "aspectabund", "novitious", "gauche", "discombobulated", "numinous", "eonian"
  ]

  NOUNS = [
    "waterfall", "river", "breeze", "moon", "rain", "wind", "sea", "morning", "snow", "lake", "sunset", "pine", "shadow", "leaf", "dawn", "glitter", "forest", "hill", "cloud", "meadow", "sun", "glade", "bird", "brook", "butterfly", "bush", "dew", "dust", "field", "fire", "flower", "firefly", "feather", "grass", "haze", "mountain", "night", "pond", "darkness", "snowflake", "silence", "sound", "sky", "shape", "surf", "thunder", "violet", "water", "wildflower", "wave", "water", "resonance", "sun", "wood", "dream", "cherry", "tree", "fog", "frost", "voice", "paper", "frog", "smoke", "star", "snood", "aglet", "splat", "tact", "zugzwang", "carriwitchet", "noosphere", "pettifoggery", "quiddity", "kakistocracy", "holophrasis"
  ]
end
