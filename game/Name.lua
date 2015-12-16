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
	"Alice",

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
	"Buddy", "Booby",
	"Crooky", "Cleo",
	"Egypt", 
	"Furball","Fuzzy","Fug",
	"Gatito Puente",
	"Meat","Monkey","Max",
	"Runner", "Rex",
	"Wiggles", "Weenie", "Woof",
	"Lady",
	"Smokey","Sylvia", "Sooty", "Skippy"

}

Name.monster =
{
	"Armorgore",
	"Breaker",
	"Cyx",
	"Damninator",
	"Ezofe",
	"Farol",
	"Grog",
	"Gorge",
	"Gore",
	"Howl",
	"Hauz",
	"Isykklz",
	"Radish",
	"Razor",
	"Skunk",
	"Worf",
	"Xiz",
	"Zoar",
}

Name.endearing =
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
	"dummy"
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