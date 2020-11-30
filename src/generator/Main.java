//package generator;
//
//import java.io.*;
//
//public class Main {
//
//    public static void main(String[] args) {
//        StringBuilder script = new StringBuilder();
//        try (FileWriter writer = new FileWriter("script.sql", false)) {
//
//            for (int i = 0; i < 250; i++) {
//
//                script.append("SELECT insert_publication('").append(random_string_generator.randomString(50)).append("', '").append(random_string_generator.randomString(60)).append("'); \n");
//
//            }
//
//            for (int i = 0; i < 100; i++) {
//
//                script.append("INSERT INTO \"case\" (description, complexity) VALUES ('").append(random_string_generator.randomString(10)).append("', ").append((int) ((Math.random() * (10.01 - 0.01)) + 0.01)).append("); \n");
//
//            }
//
//            for (int i = 0; i < 250; i++) {
//
//                script.append("SELECT insert_person('").append(random_string_generator.randomString(50))
//                        .append("', '").append(random_string_generator.randomString(60)).append("', '")
//                        .append(random_string_generator.randomDate()).append("', '")
//                        .append((int) (Math.random() * 1000000000)).append("', '")
//                        .append(random_string_generator.randomEmail(50)).append("'); \n");
//
//            }
//
//
//            for (int i = 0; i < 100; i++) {
//
//                script.append("SELECT add_publication(").append((int) ((Math.random() * 250) + 1)).append(", ").append((int) ((Math.random() * 250) + 1)).append("); \n");
//
//            }
//            for (int i = 0; i < 10; i++) {
//
//                script.append("INSERT INTO platform (name, address, contact_person_id) VALUES ('").append(random_string_generator.randomString(60)).append("', '").append(random_string_generator.randomString(60)).append("', ").append((int) ((Math.random() * 250) + 1)).append("); \n");
//
//            }
//            script.append("SELECT insert_championship('first champ','Just first championship','{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}','{2,1}');\n" +
//                    "SELECT insert_championship('second champ','Just second championship','{21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40}','{2,3}');\n" +
//                    "SELECT insert_championship('third champ','Just third championship','{41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60}','{4,10}');\n" +
//                    "SELECT insert_championship('fourth champ','Just fourth championship','{61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80}','{5}');\n" +
//                    "SELECT insert_championship('fifth champ','Just fifth championship','{81,82,83,84,5,86,87,89,90,91,92,93,94,95,96,97,98,99,100}','{6,7,8,9}');\n");
//
//            for (int i = 0; i < 250; i++) {
//
//                script.append("SELECT insert_participant('").append(random_string_generator.randomString(50))
//                        .append("', '").append(random_string_generator.randomString(60)).append("', '")
//                        .append(random_string_generator.randomDate()).append("', ")
//                        .append((int) (Math.random() * 5 + 1))
//                        .append(", '")
//                        .append((int) (Math.random() * 1000000000)).append("', '")
//                        .append(random_string_generator.randomEmail(50)).append("'); \n");
//
//            }
//            for (int i = 0; i < 250; i++) {
//
//                script.append("INSERT INTO judge (person_id, championship_id, work) VALUES (")
//                        .append((int) (Math.random() * 100 + 1)).append(", ")
//                        .append((int) (Math.random() * 5 + 1)).append(", '")
//                        .append(random_string_generator.randomString(50))
//                        .append("'); \n");
//
//            }
//            for (int i = 0; i < 100; i++) {
//
//                script.append("INSERT INTO mentor (person_id, championship_id) VALUES (")
//                        .append(i).append(", ")
//                        .append(i / 5 + 1)
//                        .append("); \n");
//
//            }
//
//            writer.write(script.toString());
//            writer.flush();
//
//        } catch (IOException e) {
//
//            System.out.println(e.getMessage());
//        }
//    }
//}
