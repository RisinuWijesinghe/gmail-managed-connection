import ballerinax/googleapis.gmail;

configurable string GOOGLE_CLIENT_ID = ?;
configurable string GOOGLE_CLIENT_SECRET = ?;
configurable string GOOGLE_REFRESH_TOKEN = ?;
configurable string GOOGLE_TOKEN_ENDPOINT = ?;

final gmail:Client gmailClient = check new ({
    auth: {
        refreshToken: GOOGLE_REFRESH_TOKEN,
        clientId: GOOGLE_CLIENT_ID,
        clientSecret: GOOGLE_CLIENT_SECRET,
        refreshUrl: GOOGLE_TOKEN_ENDPOINT
    }
});
