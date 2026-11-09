import ballerina/log;
import ballerinax/googleapis.gmail;

const string GMAIL_USER_ID = "me";
const int RECENT_MESSAGE_COUNT = 5;

public function main() returns error? {
    do {
        gmail:Profile profile = check gmailClient->/users/[GMAIL_USER_ID]/profile();
        string? emailAddress = profile.emailAddress;
        if emailAddress is string {
            log:printInfo(string `Gmail profile email address: ${emailAddress}`);
        } else {
            log:printInfo("Gmail profile email address is not available");
        }

        gmail:ListMessagesResponse messageList = check gmailClient->/users/[GMAIL_USER_ID]/messages(
            labelIds = ["INBOX"],
            maxResults = RECENT_MESSAGE_COUNT
        );
        gmail:Message[]? messages = messageList.messages;
        if messages is gmail:Message[] {
            foreach gmail:Message message in messages {
                string? subject = message.subject;
                if subject is string {
                    log:printInfo(string `Inbox message subject: ${subject}`);
                } else {
                    log:printInfo(string `Inbox message ${message.id} has no subject`);
                }
            }
        } else {
            log:printInfo("No recent messages found in the inbox");
        }

        if emailAddress is string {
            gmail:MessageRequest testMessageRequest = {
                to: [emailAddress],
                subject: "Managed connection test",
                bodyInText: "Sent via a WSO2 managed connection"
            };
            gmail:Message sentMessage = check gmailClient->/users/[GMAIL_USER_ID]/messages/send.post(testMessageRequest);
            log:printInfo(string `Test email sent successfully with message ID: ${sentMessage.id}`);
        } else {
            return error("Cannot send test email because the account email address is unknown");
        }
    } on fail error e {
        log:printError("Gmail automation failed", 'error = e);
        return e;
    }
}
