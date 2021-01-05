package generator.objects;

import generator.Generator;

public class Judge {
    private static final String[] WORK_NAMES = { "Spreader Technology", "World Wide Apps", "Amazing IT Center",
            "Vintage Solutions", "Guidance IT Center", "Connected Lines", "Ascension Apps", "Modern Transition",
            "Information Technology House", "A Plus IT House", "Galaktik Solutions", "Salorix Systems",
            "Core Cut", "Oval Solutions", "Techarius Development", "Speedlight Solutions", "Maxed Out Tech",
            "Revelation IT Company", "Expressway Ecommerce Ltd.", "Encoders & Apps", "Mad Tech Geeks",
            "Macro IT Solutions", "High Voltage Technology", "Interstellar Software", "Big Giant",
            "Farley Technology", "Sage Solutions", "Green Stream Software", "Exodus Development Co.", "Aurora Apps",
            "AutoPilot Software", "Basis Technology", "Bass Information Technology", "Hashtag Web Consultants",
            "High Voltage Software", "Mouse Marauders", "Avatar Tech", "Bar Craft Tech", "Modern Technologies",
            "Fast & Amazing", "Quick Solutions", "Files and Firewalls", "Formula Fantastic", "Gamma Tech",
            "Tonys Tech Tools", "Trace Technology", "Tech Theory", "Thrive Technology", "Total Tech", "Tech Solutions",
            "Micro Madness", "Brain Balance", "Brain Boost", "Digital Decoder", "Sim Tech", "Trained in Tech",
            "Digital Genius", "Top Ten Tech", "Success Tech", "Neptune & Saturn Tech", "Horizon PC Experts",
            "Hot Wired Web tech", "Element Shows", "Nova Web Works", "Alpha Press Solutions", "Coders & Computers",
            "Quantum Boys", "Omega Tech House", "Parallax IT Center", "Radioactive Web Works", "Blue light Software",
            "Blue Nebula", "Aubrey Analytics", "Aurora Apps", "Hashtag Web Consultants", "Nautics Technology",
            "Quest Web Apps", "Ring of Fire Tech", "Info Web House", "Ringer Codings", "Cryptware Solutions",
            "Tri Tech Apps", "Pixels Company ", "Launchpad Apps", "Sub Zero Apps", "ManageMINT Data Co.",
            "Mortar IT Center", "Code Red", "Fiscal Analytics", "OmniSoft Technologies", "Alien 51 Apps",
            "All Covered Inc.", "AlphaPress App Development", "BuildieTech", "urnt City Software", "ByteThis App Co",
            "Cryptware Tech International", "Crytonix Software", "Data Backup Pros", "Incredible Tech", "Cooler Tech",
            "Data Probe", "Debugged Pro", "Encoders Unlimited", "Euroclydon Industries Inc.", "E Vantage Software",
            "Little Tech", "Exceptional IT Services", "Next Information Systems", "Nova Web Designers",
            "Omega Mobile Co.", "Omni Soft Technologies", "Snapshot Tech", "Sage Solutions", "Skinner Software",
            "Skyline Web Solutions", "Smart Fuse Inc.", "Except Software", "In Motion", "In Design",
            "Metrilogic Solutions", "Fusion Tech", "Technokings", "Invictus Technology", "Source Code Software Co.",
            "TechniData Software", "Titan Tech Developers", "TopHat Software", "Quantique Corp", "Flow Follow",
            "Betage Studios", "Basic Batches", "Binary Bosses", "Bytes and Bots Chip Checkers",
            "Cookies and Cryptos", "A Talent for Tech", "Ticket to Techland", "Turners Tech Helpers",
            "Google", "Yandex", "Xyleme Inc.", "Tune IT", "ITIVITI" };

    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO judge (person_id, championship_id, work) VALUES (%d, %d,'%s');";

    public int person_id;
    public int championship_id;
    public String work;
    public int judge_team_id;

    private Judge(int person_id, int championship_id, String work) {
        this.person_id = person_id;
        this.championship_id = championship_id;
        this.work = work;
        this.judge_team_id = -1;
    }

    public static Judge generate(int person_id, int championship_id) {
        return insert(person_id, championship_id, generateWorkName());
    }

    public static Judge insert(int person_id, int championship_id, String work) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, person_id, championship_id, work));

        Judge newJudge = new Judge(person_id, championship_id, work);
        Generator.judges.add(newJudge);

        return newJudge;
    }

    private static String generateWorkName() {
        return WORK_NAMES[Generator.random.nextInt(WORK_NAMES.length)];
    }
}
