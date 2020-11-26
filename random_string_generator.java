import java.time.LocalDate;
import java.util.concurrent.ThreadLocalRandom;

public class random_string_generator {
    static String randomString(final int length) {
        String symbols = "abcdefghijklmnopqrstuvwxyz ";
        StringBuilder randString = new StringBuilder();
        StringBuilder randString2 = new StringBuilder();
        randString2.append("a");
        int count = (int) (Math.random() * length);
        for (int i = 0; i < count; i++) {
            randString.append(symbols.charAt((int) (Math.random() * symbols.length())));
            randString2.append(symbols.charAt((int) (Math.random() * symbols.length())));
        }
        if (randString.toString() + randString2.toString() == "") {
            return "aaaa";
        } else {
            return randString.toString() + " " + randString2.toString();
        }
    }

    static String randomEmail(final int length) {
        String symbols = "abcdefghijklmnopqrstuvwxyz";
        StringBuilder randEmail = new StringBuilder();
        StringBuilder randString2 = new StringBuilder();
        int count = (int) (Math.random() * length);
        for (int i = 0; i < count; i++) {
            randEmail.append(symbols.charAt((int) (Math.random() * symbols.length())));
            randEmail.append(Math.random() + (int) (Math.random() * 10));
            randString2.append(symbols.charAt((int) (Math.random() * symbols.length())));
        }
        if (randEmail.toString() + randString2.toString() == "") {
            return "aaaa@aaaaa";
        } else {
            return randEmail.toString() + "@" + randString2.toString();
        }
    }

    static LocalDate randomDate() {
        LocalDate startDate = LocalDate.of(1993, 1, 1); //start date
        long start = startDate.toEpochDay();
        //System.out.println(start);

        LocalDate endDate = LocalDate.of(1999, 1, 1); //end date
        long end = endDate.toEpochDay();
        //System.out.println(start);

        long randomEpochDay = ThreadLocalRandom.current().longs(start, end).findAny().getAsLong();
        // System.out.println(LocalDate.ofEpochDay(randomEpochDay));
        return (LocalDate.ofEpochDay(randomEpochDay));
    }
}
