import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Array "mo:base/Array";

actor TranslationModule {

    // Initializing an empty HashMap
    let dictionary : HashMap.HashMap<Text, Text> = HashMap.HashMap<Text, Text>(Text.equal, Text.hash);

    // Populate the dictionary with English to Tonga translations
    do {
        Array.iterate<(Text, Text)>([
            ("hello", "muli bwanji"),
            ("goodbye", "mwauka bwanji"),
            ("please", "chonde"),
            ("thank you", "zikomo"),
            ("yes", "inde"),
            ("no", "ayi")
            // Add more translations as needed
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
    }
}
