class Api::V1::UsersController < ApiController
    def create
        if params[:error]
            puts "LOGIN ERROR", params
        else
            body = {
                grant_type: "authorization_code",
                code: params[:code],
                redirect_uri: ENV['REDIRECT_URI'],
                client_id: ENV['CLIENT_ID'],
                client_secret: ENV["CLIENT_SECRET"]
            }
            auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
            auth_params = JSON.parse(auth_response.body)
            
            header = {
                Authorization: "Bearer #{auth_params["access_token"]}"
            }

            user_response = RestClient.get("https://api.spotify.com/v1/me", header)
            user_params = JSON.parse(user_response.body)
            
            @user = User.find_or_create_by(username: user_params["display_name"],
                            userId: user_params["id"],
                            image: user_params["images"][0]["url"],
                            spotify_url: user_params["external_urls"]["spotify"],
                            uri: user_params["uri"])
                            
            @user.update(access_token: auth_params["access_token"], refresh_token: auth_params["refresh_token"])

            hmac_secret = 'my$ecretK3y'
            payload = {user_id: @user.id}
            token = JWT.encode payload, hmac_secret, 'HS256'
            
            cookies.permanent[:username] = @user.username
            cookies.permanent[:userId] = @user.userId
            cookies.permanent[:image] = @user.image
            cookies.permanent[:spotify_url] = @user.spotify_url
            cookies.permanent[:uri] = @user.uri
            cookies.permanent[:jwt_token] = token
            cookies.permanent[:access_token] = auth_params["access_token"]
            
            redirect_to "http://localhost:3000/search"
        end
    end
end