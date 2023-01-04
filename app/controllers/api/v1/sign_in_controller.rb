class Api::V1::SignInController < ApiController
    def create
        query_params = {
            client_id: ENV['CLIENT_ID'],
            response_type: "code",
            redirect_uri: ENV['REDIRECT_URI'],
            scope: "user-library-read user-library-modify user-top-read user-modify-playback-state playlist-modify-public streaming user-read-email user-read-private user-read-playback-state",
            show_dialog: true
        }

        url = 'https://accounts.spotify.com/authorize'
        redirect_to "#{url}?#{query_params.to_query}", allow_other_host: true
    end
end