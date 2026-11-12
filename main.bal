import ballerina/log;
import ballerinax/googleapis.gmail;

const string GMAIL_USER_ID = "me";

const string SUBJECT = "Managed Connections: tests completed successfully";
const string BODY = string `Hi All,

The managed connections tests have been completed successfully.

This email was sent by an integration running on WSO2 Cloud, using a Gmail managed connection. The integration holds no Google credentials of its own: WSO2 Cloud manages the connection and refreshes its access on the integration's behalf.

What was verified:
- The Gmail account was connected through WSO2 Cloud's managed connections.
- The integration read the connected account's profile.
- The integration sent this email from that account.

Managed connections are working as expected.

Thanks,
WSO2 Cloud Integration Team`;

public function main() returns error? {
    gmail:Profile profile = check gmailClient->/users/[GMAIL_USER_ID]/profile();
    string? emailAddress = profile.emailAddress;
    if emailAddress is () {
        return error("Cannot send the email because the account's email address is unknown");
    }

    gmail:Message sent = check gmailClient->/users/[GMAIL_USER_ID]/messages/send.post({
        to: [emailAddress],
        subject: SUBJECT,
        bodyInText: BODY
    });
    log:printInfo(string `Managed connections email sent to ${emailAddress} with message ID: ${sent.id}`);
}
