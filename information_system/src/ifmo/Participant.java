package ifmo;

import java.time.LocalDate;

public class Participant {
    public String first_name;
    public String last_name;
    public LocalDate birth_date;

    Participant (String first_name, String last_name, LocalDate birth_date){
        this.first_name = first_name;
        this.last_name = last_name;
        this.birth_date = birth_date;
    }
}
