import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Http "mo:base/Http";
import Json "mo:base/Json";

actor TranslationModule {

    // Initializing an empty HashMap
    let dictionary : HashMap.HashMap<Text, Text> = HashMap.HashMap<Text, Text>(Text.equal, Text.hash);

    // Populating the dictionary with English to Tonga translations
    do {
        Array.iterate<(Text, Text)>([
            ("hello", "mooni"),
            ("goodbye", ""),
            ("please", "ndakomba"),
            ("thank you", "ndalumba"),
            ("yes", "inzya"),
            ("no", "peepe"),
            ("good morning", "mwabuka buti"),
            ("goodnight", "moone kabotu"),
            // translations 
        ], func(entry : (Text, Text)) {
            dictionary.put(entry.0, entry.1);
        });
    };

    // Function to translate an English sentence to Tonga
    public shared func translateSentence(sentence : Text) : async Text {
        // Split sentence into words
        let words : [Text] = Text.split(sentence, " ");
        
        // Translate each word
        let translatedWords : [Text] = Array.map<Text, Text>(words, func(word) : Text {
            let lowerWord = Text.toLower(word);
            switch (dictionary.get(lowerWord)) {
                case (?translation) { translation }; // If translation is found, use it
                case null { word }; // If not found, keep the original word
            }
        });
        
        // Join translated words into a sentence
        return Text.join(translatedWords, " ");
    };

    // Handle HTTP requests
    public query func http_request(req: Http.Request) : async Http.Response {
        switch (req.url) {
            case "/translateSentence" {
                let requestJson = Json.fromString(req.body);
                let sentence = switch (requestJson) {
                    case (?json) { Json.getText(json, "sentence") };
                    case null { "" };
                };
                let translatedSentence = await translateSentence(sentence);
                let responseBody = "{\"translatedSentence\": \"" # translatedSentence # "\"}";
                return Http.Response.ok(responseBody);
            };
            case _ {
                return Http.Response.notFound();
            };
        }
    }
}
