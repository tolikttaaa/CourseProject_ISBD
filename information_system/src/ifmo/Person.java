package ifmo;

import java.time.LocalDate;

public class Person {
    public String first_name;
    public String last_name;
    public String birth_date;

    Person (String first_name, String last_name, String birth_date){
        this.first_name = first_name;
        this.last_name = last_name;
        this.birth_date = birth_date;
    }
}
