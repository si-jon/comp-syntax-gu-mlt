--# -path=.:../abstract
concrete MicroLangSwe of MicroLang = open MicroResSwe in {

-----------------------------------------------------
---------------- Grammar part -----------------------
-----------------------------------------------------

  lincat
    Utt = {s : Str} ;
    
    S  = {s : Str} ;
    VP = {verb : Verb ; compl : Str} ; ---s special case of Mini
    Comp = {s : Str} ;
    AP = Adjective ;
    CN = Noun ;
    NP = {s : Number => Species => Str ; a : Agreement} ;
    Pron = {s : Case => Str ; a : Agreement} ;
    Det = {s : Str ; n : Number ; sp : Species ; g : Gender} ;
    Prep = {s : Str} ;
    V = Verb ;
    V2 = Verb2 ;
    A = Adjective ;
    N = Noun ;
    Adv = {s : Str} ;

  lin
-- Phrase
    UttS s = s ;
    UttNP np = {s = np.s ! Sg ! Indef} ;

-- Sentence
    PredVPS np vp = {
        s = np.s ! Sg ! Indef ++ vp.verb.s ! Pres ++ vp.compl
      } ;

-- Verb      
    UseV v = {
      verb = v ;
      compl = [] ;
      } ;
      
    ComplV2 v2 np = {
      verb = v2 ;
      compl = v2.c ++ np.s ! Sg ! Indef
      } ;
      
    UseComp comp = {
      verb = be_Verb ;     -- the verb is the copula "vara"
      compl = comp.s
      } ;
      
--   CompAP ap = {
--     
--   };
      
--    AdvVP vp adv =
--      vp ** {compl = vp.compl ++ adv.s} ;
      
-- Noun
    DetCN det cn = {
      s = \\c => det.s ++ cn.s ! det.n ! det.sp ;
      a = Agr det.n det.sp det.g ;
      } ;
      
--    UsePron p = p ;
            
    -- a_Det = {
    --   s = table {
    --     Utr => "en" ;
    --     Neutr => "ett"
    --   } ; 
    --   n = Sg
    -- } ;
    a_Det = { s = "en" ; n = Sg ; sp = Indef ; g = Utr} ;
    aPl_Det = { s = "flera" ; n = Pl ; sp = Indef ; g = Utr} ;

--    the_Det = {
--      s = pre {
--        Utr => "den" ;
--        Neutr => "det"
--        } ;
--      n = Sg
--      } ;
    the_Det = {s = "den" ; n = Sg ; sp = Indef ; g = Utr} ;
    thePl_Det = {s = "de" ; n = Pl ; sp = Indef ; g = Utr} ;
    
    UseN n = n ;
    
    AdjCN ap cn = {
      s = table {
        n => cn.s ! n
        } ;
      g = cn.g
      } ;

-- Adjective
    PositA a = a ;

-- Adverb
    PrepNP prep np = {
      s = prep.s ++ np.s ! Sg ! Indef
      } ;

-- Structural
    in_Prep = {s = "i"} ;
    on_Prep = {s = "på"} ;
    with_Prep = {s = "med"} ;

    he_Pron = {
      s = table {Nom => "han" ; Acc => "honom"} ;
      a = Agr Sg Def Utr;
      } ;
    she_Pron = {
      s = table {Nom => "hon" ; Acc => "henne"} ;
      a = Agr Sg Def Utr;
      } ;
    they_Pron = {
      s = table {Nom => "de" ; Acc => "dem"} ;
      a = Agr Pl Def Utr;
      } ;

-----------------------------------------------------
---------------- Lexicon part -----------------------
-----------------------------------------------------

-- lin already_Adv = mkAdv "already" ;
 lin animal_N = mkN "djur" Neutr ;
 lin apple_N = mkN "äpple" Neutr ;
 lin baby_N = mkN "bebis" Utr ;
 lin bad_A = mkA "dålig" "sämre" "sämst" ;
 lin beer_N = mkN "öl" Neutr ;
 lin big_A = mkA "stor" "större" "störst" ;
 lin bike_N = mkN "cykel" Utr ;
 lin bird_N = mkN "fågel" Utr ;
 lin black_A = mkA "svart" ;
 lin blood_N = mkN "blod" Neutr;
 lin blue_A = mkA "blå" "blått" ;
 lin boat_N = mkN "båt" Utr;
 lin book_N = mkN "bok" "boken" "böcker" "böckerna" Utr ;
 lin boy_N = mkN "pojke" Utr ;
 lin bread_N = mkN "bröd" Neutr ;
 lin break_V2 = mkV2 (mkV "bryta" "bryter" "bröt" "brutit") ;
 lin buy_V2 = mkV2 (mkV "köpa" "köper" "köpte" "köpt") ;
 lin car_N = mkN "bil" Utr ;
 lin cat_N = mkN "katt" "katten" "katter" "katterna" Utr ;
 lin child_N = mkN "barn" Neutr ;
 lin city_N = mkN "stad" "staden" "städer" "städerna" Utr ;
 lin clean_A = mkA "ren" ;
 lin clever_A = mkA "smart" ;
 lin cloud_N = mkN "moln" Neutr ;
 lin cold_A = mkA "kall" ;
 lin come_V = mkV "komma" "kommer" "kom" "kommit";
 lin computer_N = mkN "dator" Utr ;
 lin cow_N = mkN "ko" "kon" "kor" "korna" Utr ;
 lin dirty_A = mkA "smutsig" ;
 lin dog_N = mkN "hund" Utr;
 lin drink_V2 = mkV2 (mkV "dricka" "dricker" "drack" "druckit") ;
 lin eat_V2 = mkV2 (mkV "äta" "äter" "åt" "ätit") ;
 lin find_V2 = mkV2 "hitta" ;
 lin fire_N = mkN "eld" Utr ;
 lin fish_N = mkN "fisk" Utr ;
 lin flower_N = mkN "blomma" Utr ;
 lin friend_N = mkN "vän" Utr ;
 lin girl_N = mkN "flicka" Utr ;
 lin good_A = mkA "god" "gott" ;
 lin go_V = mkV "åka" "åker" "åkte" "åkt" ;
 lin grammar_N = mkN "grammatik" "grammatiken" "grammatiker" "grammatikerna" Utr ;
 lin green_A = mkA "grön" ;
 lin heavy_A = mkA "tung" "tyngre" "tyngst" ;
 lin horse_N = mkN "häst" Utr ;
 lin hot_A = mkA "het" "hett" ;
 lin house_N = mkN "hus" Neutr ;
-- lin john_PN = mkPN "John" ;
 lin jump_V = mkV "hoppa" ;
 lin kill_V2 = mkV2 "döda" ;
-- lin know_VS = mkVS (mkV "know" "knew" "known") ;
 lin language_N = mkN "språk" Neutr ;
 lin live_V = mkV "leva" "lever" "levde" "levt" ;
 lin love_V2 = mkV2 "älska" ;
 lin man_N = mkN "man" "mannen" "män" "männen" Utr ;
 lin milk_N = mkN "mjölk" "mjölken" "mjölk" "mjölken" Utr;
 lin music_N = mkN "musik" "musiken" "musik" "musiken" Utr ;
 lin new_A = mkA "ny" "nytt" ;
-- lin now_Adv = mkAdv "now" ;
 lin old_A = mkA "gammal" "äldre" "äldst" ;
-- lin paris_PN = mkPN "Paris" ;
 lin play_V = mkV "spela" ;
 lin read_V2 = mkV2 (mkV "läsa" "läser" "läste" "läst") ;
 lin ready_A = mkA2 "redo" ;
 lin red_A = mkA "röd" "rött" ;
 lin river_N = mkN "flod" Utr ;
 lin run_V = mkV "springa" "springer" "springde" "sprungit" ;
 lin sea_N = mkN "hav" Neutr ;
 lin see_V2 = mkV2 (mkV "se" "ser" "såg" "sett") ;
 lin ship_N = mkN "skepp" Neutr ;
 lin sleep_V = mkV "sova" "sover" "sov" "sovit" ;
 lin small_A = mkA "liten" "litet" "lilla" "små" "mindre" "minst" ;
 lin star_N = mkN "stjärna" Utr ;
 lin swim_V = mkV "simma" ;
 lin teach_V2 = mkV2 (mkV "lära" "lär" "lärde" "lärt") ;
 lin train_N = mkN "tåg" Neutr ;
 lin travel_V = mkV "resa" "reser" "resde" "rest" ;
 lin tree_N = mkN "träd" Neutr ;
 lin understand_V2 = mkV2 (mkV "förstå" "förstår" "förstod" "förstått") ;
 lin wait_V2 = mkV2 "vänta" "på" ;
 lin walk_V = mkV "gå" "går" "gick" "gått" ;
 lin warm_A = mkA "varm" ;
 lin water_N = mkN "vatten" Neutr ;
 lin white_A = mkA "vit" "vitt" ;
 lin wine_N = mkN "vin" "vinet" "viner" "vinerna" Neutr ;
 lin woman_N = mkN "kvinna" Utr ;
 lin yellow_A = mkA "gul" ;
 lin young_A = mkA "ung" "yngre" "yngst" ;

---------------------------
-- Paradigms part ---------
---------------------------

oper
  mkN = overload {
    mkN : Str -> Gender -> Noun   -- predictable noun, e.g. bil-bilen-bilar-bilarna, fluga-flugan-flugor-flugorna
      = \n,g -> lin N (smartNoun n g) ;
    mkN : Str -> Str -> Str -> Str -> Gender -> Noun  -- irregular noun, e.g. man-mannen-män-männen,
      = \sgIndef,sgDef,plIndef,plDef,gen -> lin N (mkNoun sgIndef sgDef plIndef plDef gen) ;
    } ;

  mkA = overload {
    mkA :  Str -> A -- predictable adjective
      = \a -> lin A (smartAdjective a) ;
    mkA : Str -> Str -> A -- a bit irregular adjective
      = \posUtr,posNeutr -> lin A (smartAdjective2 posUtr posNeutr) ;
    mkA : Str -> Str -> Str -> A -- quite irregular adjective
      = \pos,cmp,super -> lin A (smartAdjective3 pos cmp super) ;
    mkA : Str -> Str -> Str -> Str -> A -- very irregular adjective
      = \posUtr,posNeutr,cmp,super -> lin A (smartAdjective4 posUtr posNeutr cmp super) ;
    mkA : Str -> Str -> Str -> Str -> Str -> Str -> A -- worst irregular adjective
      = \posUtr,posNeutr,posDefSg,posPl,cmp,super -> lin A (mkAdjective posUtr posNeutr posDefSg posPl cmp super) ;
  } ;

  mkA2 : Str -> A 
    = \s -> lin A (mkAdjective2 s) ;

  mkV = overload {
    mkV : (inf : Str) -> V  -- predictable verb, e.g. baka-bakar-bakade-bakat, titta-tittar-tittade-tittat
      = \s -> lin V (regVerb s) ;
    mkV : (inf,pres,pret,perf : Str) -> V  -- irregular verb, e.g. sjunga-sjunger-sjöng-sjungit
      = \inf,pres,pret,perf -> lin V (irregVerb inf pres pret perf) ;
    } ;
  
  mkV2 = overload {
    mkV2 : Str -> V2          -- predictable verb with direct object, e.g. "hitta"
      = \s   -> lin V2 (regVerb s ** {c = []}) ;
    mkV2 : Str  -> Str -> V2  -- predictable verb with preposition, e.g. "vänta - på"
      = \s,p -> lin V2 (regVerb s ** {c = p}) ;
    mkV2 : V -> V2            -- any verb with direct object, e.g. "drink"
      = \v   -> lin V2 (v ** {c = []}) ;
    mkV2 : V -> Str -> V2     -- any verb with preposition
      = \v,p -> lin V2 (v ** {c = p}) ;
    } ;
--
--  mkAdv : Str -> Adv
--    = \s -> lin Adv {s = s} ;
--  
--  mkPrep : Str -> Prep
--    = \s -> lin Prep {s = s} ;

}
