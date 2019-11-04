package io.agora.pronunciation.langurage.english;

public class WordRandomizer {
    private static final String[] DICTATION = {
            "phenomenon",
            "remuneration",
            "ethnicity",
            "provocatively",
            "anonymous",
            "regularly",
            "particularly",
            "repertoire",
            "facilitate",
            "hospitable",
            "genre",
            "deterioration",
            "dilemma",
            "usually"
    };

    public static String pickRandomWord() {
        return DICTATION[randomIndex(DICTATION.length)];
    }

    private static int randomIndex(int range) {
        return (int) (Math.random() * range);
    }
}
