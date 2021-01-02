public class Main {
    public static void main(String[] args) {
        Tunnel tunnel = new Tunnel("helios.se.ifmo.ru",
                "s******",
                "******",
                2222,
                "pg",
                5432,
                5432);
        tunnel.connect();
    }
}
