-- Name.lua

-- Purpose
------------------------------------------
-- generates proper names for objects


local Name =  {}


------------------
-- Static Info
------------------
Name.Info = Info:New
{
	objectType = "Name",
	dataType = "Generator",
	structureType = "Static"
}

------------------------
-- Static Vars
------------------------

Name.human = {}

Name.human.female =
{	
	"Aaron","Abbey",
	"Abbie","Abby","Abigail","Ada","Adah","Adaline","Adam","Addie",
	"Adela","Adelaida","Adelaide","Adele","Adelia","Adelina","Adeline",
	"Adell","Adella","Adelle","Adena","Adina","Adria","Adrian",
	"Adriana","Adriane","Adrianna","Adrianne","Adrien","Adriene",
	"Adrienne","Afton","Agatha","Agnes","Agnus","Agripina","Agueda",
	"Agustina","Ai","Aida","Aide","Aiko","Aileen","Ailene","Aimee",
	"Aisha","Aja","Akiko","Akilah","Alaina","Alaine","Alana","Alane",
	"Alanna","Alayna","Alba","Albert","Alberta","Albertha","Albertina",
	"Albertine","Albina","Alda","Alease","Alecia","Aleen","Aleida",
	"Aleisha","Alejandra","Alejandrina","Alena","Alene","Alesha",
	"Aleshia","Alesia","Alessandra","Aleta","Aletha","Alethea","Alethia",
	"Alex","Alexa","Alexander","Alexandra","Alexandria","Alexia",
	"Alexis","Alfreda","Alfredia","Ali","Alia","Alica","Alice",
	"Alicia","Alida","Alina","Aline","Alisa","Alise","Alisha",
	"Alishia","Alisia","Alison","Alissa","Alita","Alix","Aliza","Alla",
	"Alleen","Allegra","Allen","Allena","Allene","Allie","Alline","Allison",
	"Allyn","Allyson","Alma","Almeda","Almeta","Alona","Alpha",
	"Alta","Altagracia","Altha","Althea","Alva","Alvera","Alverta","Alvina",
	"Alyce","Alycia","Alysa","Alyse","Alysha","Alysia","Alyson",
	"Alyssa","Amada","Amal","Amalia","Amanda","Amber","Amberly",
	"Amee","Amelia","America","Ami","Amie","Amiee","Amina","Amira",
	"Ammie","Amparo","Amy","An","Ana","Anabel","Analisa","Anamaria",
	"Anastacia","Anastasia","Andera","Andra","Andre","Andrea","Andree","Andrew",
	"Andria","Anette","Angel","Angela","Angele","Angelena","Angeles",
	"Angelia","Angelic","Angelica","Angelika","Angelina","Angeline",
	"Angelique","Angelita","Angella","Angelo","Angelyn","Angie","Angila",
	"Angla","Angle","Anglea","Anh","Anika","Anisa","Anisha","Anissa","Anita","Anitra",
	"Anja","Anjanette","Anjelica","Ann","Anna","Annabel","Annabell",
	"Annabelle","Annalee","Annalisa","Annamae","Annamaria","Annamarie","Anne",
	"Anneliese","Annelle","Annemarie","Annett","Annetta","Annette",
	"Annice","Annie","Annika","Annis","Annita","Annmarie","Anthony",
	"Antionette","Antoinette","Antonetta","Antonette","Antonia","Antonietta",
	"Antonina","Antonio","Anya","Apolonia","April","Apryl","Ara","Araceli",
	"Aracelis","Aracely","Arcelia","Ardath","Ardelia","Ardell","Ardella",
	"Ardelle","Ardis","Ardith","Aretha","Argelia","Argentina","Ariana",
	"Ariane","Arianna","Arianne","Arica","Arie","Ariel","Arielle",
	"Arla","Arlean","Arleen","Arlena","Arlene","Arletha","Arletta",
	"Arlette","Arlinda","Arline","Arlyne","Armanda","Armandina","Armida",
	"Arminda","Arnetta","Arnette","Arnita","Arthur","Artie","Arvilla",
	"Asha","Ashanti","Ashely","Ashlea","Ashlee","Ashleigh",
	"Ashley","Ashli","Ashlie","Ashly","Ashlyn","Ashton","Asia",
	"Asley","Assunta","Astrid","Asuncion","Athena","Aubrey","Audie",
	"Audra","Audrea","Audrey","Audria","Audrie","Audry","Augusta",
	"Augustina","Augustine","Aundrea","Aura","Aurea","Aurelia","Aurora",
	"Aurore","Austin","Autumn","Ava","Avelina","Avery","Avis","Avril",
	"Awilda","Ayako","Ayana","Ayanna","Ayesha","Azalee","Azucena","Azzie",

	"Babara","Babette","Bailey","Bambi","Bao","Barabara","Barb","Barbar",
	"Barbara","Barbera","Barbie","Barbra","Bari","Barrie","Basilia","Bea",
	"Beata","Beatrice","Beatris","Beatriz","Beaulah","Bebe","Becki","Beckie",
	"Becky","Bee","Belen","Belia","Belinda","Belkis","Bell","Bella",
	"Belle","Belva","Benita","Bennie","Berenice","Berna","Bernadette","Bernadine",
	"Bernarda","Bernardina","Bernardine","Berneice","Bernetta","Bernice","Bernie",
	"Berniece","Bernita","Berry","Berta","Bertha","Bertie","Beryl",
	"Bess","Bessie","Beth","Bethanie","Bethann","Bethany","Bethel","Betsey",
	"Betsy","Bette","Bettie","Bettina","Betty","Bettyann","Bettye",
	"Beula","Beulah","Bev","Beverlee","Beverley","Beverly","Bianca",
	"Bibi","Billi","Billie","Billy","Billye","Birdie","Birgit",
	"Blair","Blake","Blanca","Blanch","Blanche","Blondell",
	"Blossom","Blythe","Bobbi","Bobbie","Bobby","Bobbye","Bobette",
	"Bok","Bong","Bonita","Bonnie","Bonny","Branda","Brande",
	"Brandee","Brandi","Brandie","Brandon","Brandy","Breana","Breann","Breanna",
	"Breanne","Bree","Brenda","Brenna","Brett","Brian",
	"Briana","Brianna","Brianne","Bridget","Bridgett","Bridgette","Brigette",
	"Brigid","Brigida","Brigitte","Brinda","Britany","Britney","Britni",
	"Britt","Britta","Brittaney","Brittani","Brittanie","Brittany","Britteny",
	"Brittney","Brittni","Brittny","Bronwyn","Brook","Brooke",
	"Bruna","Brunilda","Bryanna","Brynn","Buena","Buffy",
	"Bula","Bulah","Bunny","Burma",

	"Jengy", "Jennifer", 
	"Lucy", "Sarah", 
	"Mary", "Mable",
}

Name.human.male =
{
	"Aaron", "Abdul","Abe","Abel","Abraham","Abram","Adalberto","Adam","Adan",
	"Adolfo","Adolph","Adrian","Agustin","Ahmad","Ahmed","Al","Alan","Albert",
	"Alberto","Alden","Aldo","Alec","Alejandro","Alex","Alexander",
	"Alexis","Alfonso","Alfonzo","Alfred","Alfredo","Ali","Allan",
	"Allen","Alonso","Alonzo","Alphonse","Alphonso","Alton",
	"Alva","Alvaro","Alvin","Amado","Ambrose","Amos","Anderson","Andre",
	"Andrea","Andreas","Andres","Andrew","Andy","Angel","Angelo",
	"Anibal","Anthony","Antione","Antoine","Anton","Antone",
	"Antonia","Antonio","Antony","Antwan","Archie","Arden","Ariel","Arlen",
	"Arlie","Armand","Armando","Arnold","Arnoldo","Arnulfo","Aron","Arron",
	"Art","Arthur","Arturo","Asa","Ashley","Aubrey","August","Augustine",
	"Augustus","Aurelio","Austin","Avery",

	"Bob",
	"David",
	"John", "Joey", "Jimmy",
	"Kirk",
	"Larry",
	"Steve",
}

Name.human.family =
{
	"Gable","Gabriel","Gaddis","Gaddy","Gaffney","Gage","Gagne","Gagnon","Gaines",
	"Gainey","Gaither","Galarza","Galbraith","Gale","Galindo","Gallagher",
	"Gallant","Gallardo","Gallegos","Gallo","Galloway","Galvan","Galvez",
	"Galvin","Gamble","Gamboa","Gamez","Gandy","Gann","Gannon","Gant",
	"Gantt","Garber","Garcia","Gardiner","Gardner","Garland","Garmon","Garner",
	"Garnett","Garrett","Garris","Garrison","Garvey","Garvin","Gary","Garza",
	"Gaskin","Gaskins","Gass","Gaston","Gates","Gatewood","Gatlin","Gauthier",
	"Gavin","Gay","Gaylord","Geary","Gee","Geer","Geiger","Gentile",
	"Gentry","George","Gerald","Gerard","Gerber","German","Getz",
	"Gibbons","Gibbs","Gibson","Gifford","Gil","Gilbert","Gilchrist",
	"Giles","Gill","Gillen","Gillespie","Gillette","Gilley","Gilliam","Gilliland",
	"Gillis","Gilman","Gilmore","Gilson","Ginn","Giordano","Gipson",
	"Girard","Giron","Giroux","Gist","Givens","Gladden","Gladney","Glaser",
	"Glass","Gleason","Glenn","Glover","Glynn","Goad","Goble","Goddard",
	"Godfrey","Godwin","Goebel","Goetz","Goff","Goforth","Goins",
	"Gold","Goldberg","Golden","Goldman","Goldsmith","Goldstein","Gomes","Gomez",
	"Gonsalves","Gonzales","Gonzalez","Gooch","Good","Goode",
	"Gooden","Goodman","Goodrich","Goodson","Goodwin","Gordon","Gore",
	"Gorham","Gorman","Goss","Gossett","Gough","Gould","Goulet",
	"Grace","Gracia","Grady","Graf","Graff","Graham","Granados",
	"Granger","Grant","Grantham","Graves","Gray","Grayson","Greathouse","Greco",
	"Green","Greenberg","Greene","Greenfield","Greenlee","Greenwood","Greer",
	"Gregg","Gregory","Greiner","Grenier","Gresham","Grey","Grice",
	"Grier","Griffin","Griffis","Griffith","Griffiths","Griggs","Grigsby",
	"Grimes","Grimm","Grisham","Grissom","Griswold","Groce","Grogan",
	"Grooms","Gross","Grossman","Grove","Grover","Groves","Grubb",
	"Grubbs","Gruber","Guajardo","Guenther","Guerin","Guerra","Guerrero",
	"Guess","Guest","Guevara","Guffey","Guidry","Guillen","Guillory",
	"Guinn","Gulley","Gunderson","Gunn","Gunter","Gunther","Gurley",
	"Gustafson","Guthrie","Gutierrez","Guy","Guyton","Guzman",

	"Adams",
	"Barnett","Briggs", 
	"Gomez",  
	"King",  
	"White" 
}

Name.pet =
{
	"Bubbles","Bagel","Buddy", "Boots", "Benny",
	"Booby", "Butter",
	"Crooky", "Cleo",
	"Egypt", 
	"Furball","Fuzzy","Fug",
	"Gatito Puente",
	"Meat","Monkey","Max",
	"Runner", "Rex",
	"Wiggles", "Weenie", "Weener", "Woof",
	"Lady",
	"Smokey","Sylvia", "Sooty", "Skippy",


}

Name.monster =
{
	"Azar",
	"Brute",
	"Cyx",
	"Damninator",
	"Ezofe",
	"Farol",
	"Grog",
	"Gorge",
	"Gore",
	"Gouge",
	"Grim",
	"Grawl",
	"Hauz",
	"HunGur",
	"Howl",
	"Isykklz",
	"Radish",
	"Razor",
	"Roar",
	"Skunk",
	"Worf",
	"Xiz",
	"Zoar",
}

Name.lover =
{
	"sweetie",
	"honey",
	"sugar",
	"pumpkin",
	"booby",
	"baby",
	"buddy",
	"sweet thing",
	"muffin",
	"pudding",
}

Name.insulting =
{
	"shit head",
	"motherfucker",
	"ass face",
	"dick head",
	"moron",
	"stupid",
	"idiot",
	"dummy",
	"chode",
	"bitch",
	"cunt",
	"pussy"
}

Name.fantasy = 
{
	"Breaker",
	"Ore",
	"Rork",
	"Spark",
	"Rain",
	"Ever",
	"Sky",
	"Wind",
	"Rust",
	"Silph",
}

Name.titles =
{
	"Brother",
	"Captain",
	"President",
	"Councilman",
	"Senator",
	"Mayor",
	"Minister",
	"Father",
	"Mr.",
	"Ms.",
	"Mrs."

}


------------------------
-- Static Functions
------------------------

function Name:GetHuman(data)

	local species = data.species or "human"
	local gender = data.gender or "male"

	local name = ""

	-- get first
	name = Random:ChooseRandomlyFrom(Name[species][gender])

	-- get last
	name = name .. " " .. Random:ChooseRandomlyFrom(self[species]["family"])
	

	return name

end

function Name:GetPet()
	return Random:ChooseRandomlyFrom(Name.pet)
end 

function Name:GetMonster()
	return Random:ChooseRandomlyFrom(Name.monster)
end 


Name.GetIndex =
{
	Human = Name.GetHuman,
	Pet = Name.GetPet,
	Monster = Name.GetMonster
}





ObjectManager:AddStatic(Name)

return Name 



-- Junk
------------------------------
--[[

local testName = Name:GetHuman{}
print(testName)

print(Name:GetPet())
print(Name:GetMonster())






--]]