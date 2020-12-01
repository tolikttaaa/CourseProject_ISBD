package generator.objects;

import generator.Generator;

import java.util.ArrayList;
public class Team {
    private static int cnt = 1;

    private static final String[] TEAM_NAMES = { "A Team", "All Stars", "Amigos", "Avengers", "Bannermen",
            "Best of the Best", "Bosses", "Champions", "Crew", "Dominators", "Dream Team", "Elite", "Force",
            "Goal Diggers", "Heatwave", "Hot Shots", "Hustle", "Icons", "Justice League", "Legends", "Lightning",
            "Maniacs", "Masters", "Monarchy", "Naturals", "Ninjas", "Outliers", "Peak Performers", "Power", "Rebels",
            "Revolution", "Ringmasters", "Rule Breakers", "Shakedown", "Squad", "Titans", "Tribe", "United", "Vikings",
            "Warriors", "Wolf Pack", "Aces", "Assassins", "Armada", "Bandits", "Blaze", "Brute Force", "Chaos",
            "Chosen Ones", "Conquerors", "Defenders", "Empire", "Extreme", "Fury", "Gladiators", "High Voltage",
            "Hitmen", "Inferno", "Intimidators", "Kingsmen", "Lethal Weapons", "Mafia", "Matrix", "No Fear",
            "Outlaws", "Pistols", "Pulverizers", "Rage", "Renegades", "Riot", "Rumble", "Samurais", "Stealth",
            "Terminators", "Trouble Makers", "Unbeatable", "Venom", "Weapons of Mass Destruction", "Wrecking Crew",
            "Adrenaline", "Alliance", "Arsenal", "Badasses", "Blitz", "Brigade", "Calvary", "Collective", "Dothraki",
            "End Game", "Fuego", "Guardians", "Heathens", "Horsepower", "Impact", "Ironmen", "Keep It 100", "Magic",
            "Mystery", "No Sympathy", "Obliterators", "Phenomenon", "Phoenix", "Rampage", "Regulators", "Rough Necks",
            "Savage Joes", "Status Quo", "Thrashers", "Unstoppable", "Vicious", "Wild Things", "Your Worst Nightmare",
            "A Team Has No Name", "We Tried", "Enter Team Name Here", "No Shame", "Mediocrity At Its Best",
            "Savage and Average", "Wasted Potential", "Best Team Name", "We Showed Up", "Mandatory Attendance",
            "Boom Shaka Laka", "Newbies", "Mandatory Fun", "Noobs", "Lovable and Lazy", "Our Uniforms Match",
            "Minimum Wagers", "Couch Potatoes", "Waiting For Naptime", "Creative Team Name", "Shoes or Lose",
            "Make Teams Great Again", "Another Team Name", "Cranky Yankees", "Movers and Shakers", "Heartbreakers",
            "One More Team Name", "2nd Choice of Team Name", "Coffee Addicts", "Cheers For Beers", "Tea Spillers",
            "Boozy Bunch", "Will Work For Food", "Winos", "Always Hungry", "All Hungover", "Praise Cheeses",
            "Cereal Killers", "Snack Attack", "Addicted to Cake", "Cupcakes", "Stud Muffins", "No Slice Left Behind",
            "Sugar Babies", "Sugar Daddies", "Kids R Us", "Teenage Dream", "Plenty of Twenties", "The Roaring Twenties",
            "Young Bucks", "Dirty Thirty", "Oh Lordy, We are Forty", "50 Shades of Age", "Old Timers", "Eighties Babies",
            "Baby Boomers", "Millennials", "Generation X", "Generation Z", "0 Risk", "100 percent", "49ers", "76ers",
            "8th Wonders of World", "99 percenters", "Administration", "Admirals", "Adrenaline", "Advocates", "Aeros",
            "Aggies", "Aliens", "Alliance", "Alpha Team", "Alphas", "Ambassadors", "American Patriots", "Americans",
            "Angels", "Animals", "Annihilators", "Anteaters", "Apocalypse", "Archers", "Around The Horn", "Arrows",
            "Asteroids", "Astronomic", "Astros", "Athletics", "Avalanche", "Aztecs", "Bachelors", "Bad Boys",
            "Bad Boys 4 Life", "Bad News Bears", "Bad to The Bone", "Bane of Your Existence", "Barbarians",
            "Barnstormers", "Barons", "Bats", "Battle Buddies", "Battle Hawks", "Bay Bears", "Bean Counters",
            "Bearcats", "Bears", "Beasts", "Bees", "Belles", "Bengals", "Berets", "Big Bats", "Big Horns", "Bills",
            "Bisons", "Black Knights", "Black Panthers", "Black Widows", "Blackhawks", "Blades", "Blast", "Blasters",
            "Blazers", "Blitzkrieg", "Blossoms", "Blue Angels", "Blue Birds", "Blue Collars", "Blue Jackets",
            "Blue Jays", "Blue Whales", "Blues", "Bobcats", "Bolts", "Bombers", "Bookworms", "Boomers", "Bots",
            "Boulders", "Braves", "Brewers", "Brewmaster", "Broncos", "Browns", "Bruins", "Buccaneers", "Bucks",
            "Buffaloes", "Builders", "Bulldogs", "Bulldogs", "Bulletproof", "Bullets", "Bullfighters", "Bulls",
            "Butchers", "Canucks", "Capitals", "Captains", "Captivators", "Cardinals", "Cavaliers", "Celtics",
            "Challengers", "Chameleons", "Chaos", "Chargers", "Chasers", "Chiefs", "CIA", "Circus Animals", "Claws",
            "Clippers", "Cobras", "Code Black", "Code Red", "Collision Course", "Colts", "Comets", "Compadres",
            "Connected", "Cosmos", "Cougars", "Cowboys", "Coyotes", "Crafty Crew", "Crazy 8’s", "Crunch", "Crusaders",
            "Crush", "Cubs", "Curve", "Cyclones", "Dangers", "Darkside", "Deal Makers", "Deathwish", "Decision-makers",
            "Deep Pockets", "Delinquents", "Demolition Crew", "Desert Storm", "Desperados", "Destroyers", "Devils",
            "Diamondbacks", "Diplomats", "Divas", "Divide and Conquer", "Dodgers", "Dolphins", "Dragons",
            "Dream Crushers", "Drifters", "Drones", "Dropping Bombs", "Duchesses", "Ducks", "Dukes", "Dynamix",
            "Dynamo", "Dynomite", "Eagles", "Earthquakes", "Eliminators", "Empowered", "Enforcers", "Enigma",
            "Entrepreneurs", "Eruption", "Eskimos", "Esquires", "Evolution", "Executioners", "Expendables", "Explorers",
            "Explosion", "Exterminators", "Fairies", "Falcons", "Fast And Furious", "Felons", "Fighters",
            "Fighting Irish", "Fire", "Fire Starters", "Firebirds", "Fireflies", "Firing Squad", "Firm", "Fisher Cats",
            "Fixers", "Flames", "Flash", "Flight", "Flight Crew", "Flyers", "Flying Dutchmen", "Flying Monkeys",
            "Foundation", "Four Horsemen", "Foxes", "Freaks", "Frontline", "Full Effect", "Full Out", "Fusion",
            "G-Force", "Galaxy", "Gamecocks", "Gargoyles", "Gatling Guns", "Gators", "Generals", "Gentlemen",
            "Ghost Riders", "Ghosts", "Giants", "Goblins", "Godfathers", "Gold Rush", "Golden Eagles", "Gophers",
            "Gorillas", "Grave Diggers", "Gravity", "Greyhounds", "Griffins", "Grizzlies", "Growlers", "Gulls",
            "Gunners", "Guns for Hire", "Hammerheads", "Hawkeyes", "Hawks", "Head Hunters", "Heat", "Hell Angels",
            "Hellraisers", "Herons", "High Altitude", "High Flyers", "High Rollers", "Hillbillies", "Hit Team",
            "Hitters", "Hive", "Home Runners", "Homers", "Homies", "Hoodlums", "Hooks", "Hoosiers", "Hornets",
            "Hurricanes", "Huskies", "Hustlers", "Icehogs", "Ice Wall", "Iconic", "In Style", "Incredibles",
            "Independence", "Indians", "Infantry", "Influencers", "Insurgents", "Invaders", "Islanders",
            "Jackrabbits", "Jaguars", "Jalapenos", "Jawbreakers", "Jayhawks", "Jazz", "Jets", "Jocks", "Jokers",
            "Judges", "Juiced", "Jungle Kings", "Justice Bringers", "Kangeroos", "Kickers", "Killer Whales", "Kingdom",
            "Kingpins", "Kings", "Kittens", "Knights", "Koalas", "Kryptonite", "Ladies", "Lady Killers", "Lake Hawks",
            "Lakers", "Laser Beams", "Leaders", "Legacy", "Leopards", "Life Savers", "Lilas", "Lions", "Lobos",
            "Longhorns", "Lords", "Lost Boys", "Lumberjacks", "Mad Bombers", "Mad Men", "Magicians", "Majors",
            "Mammoths", "Maple Leafs", "Marauders", "Mariners", "Marines", "Marlins", "Marshalls", "Masons", "Matadors",
            "Mavericks", "Mean Green", "Mean Machine", "Men In Black", "Men on a Mission", "Mercenaries", "Mermaids",
            "Meteors", "Mets", "MI6", "Mighty Ducks", "Minutemen", "Mob", "Monarchs", "Money Makers", "Monsters",
            "Moose", "Mountaineers", "Mud Dogs", "Mud Hens", "Musketeers", "Mustangs", "Nationals", "Neck Breakers",
            "Nerds", "Nets", "Nirvana", "No Mercy", "No Pain, No Gain", "No Rules", "No Way Out", "Northern Lights",
            "Novastars", "Nuggets", "Occupiers", "Oilers", "Olympians", "Only Contenders", "Orcas", "Orediggers",
            "Orioles", "Otters", "Over Achievers", "Owls", "Pacers", "Packers", "Padres", "Pandas", "Panthers",
            "Patriots", "Peacekeepers", "Peacocks", "Penguins", "Perfecto’s", "Phantoms", "Phillies", "Pilots", "Pimps",
            "Pioneers", "Piranhas", "Pirates", "Pistons", "Pitbulls", "Players", "Polar Bears", "Power House",
            "Prairie Wolves", "Predators", "Presidents", "Priceless", "Princes", "Princesses", "Prodigies",
            "Professionals", "Prophets", "Prowlers", "Punishers", "Puppet Masters", "Pups", "Pythons", "Quake",
            "Quicksilvers", "Racers", "Radicals", "Ragin Cajuns", "Raging Bulls", "Raiders", "RailHawks", "Rams",
            "Rangers", "Rapids", "Raptors", "Rattlesnakes", "Ravens", "Rays", "Razorbacks", "Reapers", "Rebellion",
            "Red Bulls", "Red Raiders", "Red Rapids", "Red Rovers", "Red Sox", "Red Wings", "Redbirds", "Redhawks",
            "Reds", "Redskins", "Republic", "Rescue Team", "Retrievers", "Rhinos", "Rhythm", "Riders", "Ringleaders",
            "Rip Tide", "River Cats", "River Hounds", "River Rats", "Rivermen", "Robots", "Rock Cats", "Rock Stars",
            "Rockers", "Rocket Launchers", "Rocketmen", "Rockets", "Rockies", "Rocks", "Roses", "Rough Riders",
            "Royals", "Royalty", "Saboteurs", "Sabres", "Sailors", "Saints", "Sand Sharks", "Savages", "Scappers",
            "Scorpions", "Scrappers", "Screamin Demons", "Sea Dogs", "Sea Lions", "Seabirds", "Seahawks", "Security",
            "Senators", "Shadows", "Shameless", "Shapeshifters", "Sharks", "Sharks in Suits", "Sharp Shooters", "Shield",
            "Shock and Awe", "Shocks", "Shoguns", "Shooting Stars", "Showboats", "Showrunners", "Sicarios", "Sinners",
            "Skull Crushers", "Skywalkers", "Slam", "Slayers", "Sledgehammers", "Sliders", "Sluggers", "Snipers",
            "Soldiers", "Soul Takers", "Sounders", "Sounds", "Spartans", "Special K’s", "Speed Demons", "Spider Monkeys",
            "Spiders", "Spies", "Spurs", "Squadron", "Stallions", "Stampede", "Stampeders", "Stars", "Statesmen",
            "Steelers", "Stingrays", "Stone Crushers", "Storm", "Storm Breakers", "Storm Chasers", "Straight Shooters",
            "Strangers", "Strikers", "Suits", "Sultans", "Suns", "Super Heroes", "Super Humans", "Super Sonics", "Surf",
            "Swag", "Swagger", "Sweet Heat", "Sweethearts", "Take No Prisoners", "Tar Heels", "Tater Tots",
            "Tech Attack", "Terrapins", "Terrorizers", "Texans", "Thunder", "Thunder Bolts", "Thunderbirds",
            "Tidal Waves", "Tide", "Tides", "Tigers", "Timbers", "Timberwolves", "TKOs", "Tomcats", "Torches", "Toreros",
            "Tornadoes", "Toros", "Trail Blazers", "Trappers", "Travelers", "Tritons", "Trojans", "Tsunamis",
            "Turtleheads", "Twins", "Unicorns", "Union", "Unknowns", "Unlimited", "Untouchables", "Usual Suspects",
            "Vampires", "Vandals", "Vaqueros", "Veterans", "Vigilantes", "Viking Raiders", "Vipers", "Volcanoes",
            "Voyagers", "Vultures", "Wanderers", "War Eagles", "Warlocks", "Warmongers", "Watchers", "Waves",
            "Weed Wackers", "Whales", "Whammers", "Whirlwinds", "White Collars", "White Sox", "White Walkers",
            "Whitecaps", "Wild", "Wildcats", "Wildebeests", "Witches", "Wizards", "Wolverines", "Wolves", "Wombats",
            "Workers Bees", "Wraiths", "X Men", "Yankees", "Yellow Jackets", "Zeniths", "Zephyrs", "Zombies",
            "Zoo Animals" };

    private static final String INSERT_SCRIPT_WITHOUT_MENTORS_TEMPLATE = "SELECT insert_team('%s', '%s', %d, %d);";
    private static final String INSERT_SCRIPT_WITH_MENTORS_TEMPLATE = "SELECT insert_team_with_mentor('%s', '%s', '%s', %d, %d);";

    public int team_id;
    public String name;
    public int leader_id;
    public ArrayList<Integer> teammates;
    public ArrayList<Integer> mentors;
    public int championship_id;

    private Team(String name, int leader_id, ArrayList<Integer> teammates, ArrayList<Integer> mentors, int championship_id) {
        this.team_id = cnt++;
        this.name = name;
        this.leader_id = leader_id;
        this.teammates = teammates;
        this.mentors = mentors;
        this.championship_id = championship_id;
    }

    public static Team generate(ArrayList<Integer> teammates, ArrayList<Integer> mentors, int championship_id) {
        return insert(generateTeamName(), teammates.get(0), teammates, mentors, championship_id);
    }

    public static Team insert(String name, int leader_id, ArrayList<Integer> teammates, ArrayList<Integer> mentors, int championship_id) {
        if (mentors.size() > 0) {
            Generator.addScript(String.format(INSERT_SCRIPT_WITH_MENTORS_TEMPLATE,
                    name,
                    Generator.getIntArray(teammates),
                    Generator.getIntArray(mentors),
                    leader_id,
                    championship_id));
        } else {
            Generator.addScript(String.format(INSERT_SCRIPT_WITHOUT_MENTORS_TEMPLATE,
                    name,
                    Generator.getIntArray(teammates),
                    leader_id,
                    championship_id));
        }

        Team newTeam = new Team(name, leader_id, teammates, mentors, championship_id);
        Generator.teams.add(newTeam);

        return newTeam;
    }

    private static String generateTeamName() {
        return TEAM_NAMES[Generator.random.nextInt(TEAM_NAMES.length)];
    }
}
