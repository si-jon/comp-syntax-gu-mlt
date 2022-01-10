--# -path=.:../abstract
--# -path=.:/home/sigrid/.gf/prelude
concrete MiniGrammarSwe of MiniGrammar = open 

  MiniResSwe,
  Prelude

in {

  lincat

-- Common
    Utt = {s : Str} ;
    Pol  = {s : Str ; isTrue : Bool} ; -- the s field is empty, but needed for parsing
    Temp = {s : Str ; isPres : Bool} ;

-- Cat
    S = {s : Str} ;
    QS = {s : Str} ; -- question sentence

-- declarative clause, with all tenses
    Cl = {   -- word order is fixed in S and QS
      subj : Str ;                             -- subject
      verb : Bool => Bool => {fin,inf : Str} ; -- dep. on Pol,Temp, e.g. "does","sleep"
      complStr : Str                              -- after verb: complement, adverbs
      } ;

-- question clause
    QCl = Cl ** {isWh : Bool} ;
    Imp = {s : Bool => Str} ;

    VP = {verb : GVerb ; compl : Complement} ;
    Comp = {s : Complement} ;
    AP = Adjective ;
    CN = {s : Noun ; hasComp : Bool} ;
    NP = {s : Case => Str ; a : Agreement} ;
    IP = {s : Case => Str ; a : Agreement} ; -- interrogative phrase
    Pron = {s : Case => Str ; a : Agreement};
    Det = {s : Bool => Gender => Str ; n : Number ; sp : Species} ;
    Conj = {s : Str} ;
    Prep = {s : Str} ;
    V = Verb ;
    V2 = Verb2 ; -- two-place verb
    VS = Verb ; -- sentence-complement verb
    VV = Verb ; ---- only VV to VP -- verb-phrase-complement verb
    A = Adjective ;
    N = Noun ;
    PN = {s : Str} ;
    Adv = {s : Str} ;
    IAdv = {s : Str} ;

  lin
-- Phrase
    UttS s = s ;
    UttQS s = s ;
    UttNP np = {s = np.s ! Nom} ;
    UttAdv adv = adv ;
    UttIAdv iadv = iadv ;
    UttImpSg pol imp = {s = pol.s ++ imp.s ! pol.isTrue} ;

-- Sentence
    UseCl temp pol cl =
      let
        isPos = pol.isTrue ;
        isPres = temp.isPres ;
        clt = cl.verb ! isPos ! isPres ;
        verborder = case isPos of { -- dricker / har druckit
          True => case isPres of {
            _  => clt.fin ++ clt.inf 
          } ;
          False => case isPres of {
            True  => clt.fin ++ clt.inf ++ "inte"   ;  -- dricker inte 
            False => clt.fin ++ "inte"  ++ clt.inf      -- har inte druckit
          }
	      }
      in {
        s = pol.s ++ temp.s ++  --- needed for parsing: a GF hack
        cl.subj ++
        verborder ++
        cl.complStr
      } ;

    UseQCl temp pol qcl =
      let
        isPos = pol.isTrue ;
        isPres = temp.isPres ;
        isWh = qcl.isWh ;
        clt = qcl.verb ! andB isWh isPos ! isPres ;
        verbsubjorder = case isWh of {
          True => case isPos of {
            True => case isPres of {
              _  => qcl.subj ++ clt.fin ++ clt.inf 
            } ;
            False => case isPres of {
              True  => qcl.subj ++ clt.fin ++ clt.inf ++ "inte"   ;   -- vem dricker inte 
              False => qcl.subj ++ clt.fin ++ "inte"  ++ clt.inf      -- vem har inte druckit
            }
          } ;
          False => case isPos of {
            True => case isPres of {
              True => clt.fin ++ clt.inf ++ qcl.subj ;  -- dricker John
              False => clt.fin ++ qcl.subj ++ clt.inf   -- har john druckit
            } ;
            False => case isPres of {
              True  => clt.fin ++ clt.inf ++ "inte" ++ qcl.subj   ;  -- dricker inte John --- Ambigous, could also be "dricker John inte"
              False => clt.fin ++ qcl.subj ++ "inte"  ++ clt.inf      -- har John inte druckit --- Ambigous, could also be "har inte John druckit"
            }
          }
	      }
      in {
        s = pol.s ++ temp.s ++
        verbsubjorder ++
	      qcl.complStr                -- öl
      } ;

    PredVP np vp = {
      subj = np.s ! Nom ;
      complStr = vp.compl.s ! np.a ; -- Antingen adjective, verb, adverb, string
      verb = \\plain,isPres => case <vp.verb.isAux, plain, isPres> of {

        <False, _, True> => {fin = []; inf = vp.verb.s ! VF Pres} ;
        <_, _, True> => {fin = []; inf = vp.verb.s ! VF Pres} ;
        <_,_, False> => {fin = "har" ; inf = vp.verb.s ! VF Supine }
      }
    } ;

    QuestCl cl = cl ** {isWh = False} ; -- since the parts are the same, we don't need to change anything
    
    QuestVP ip vp = PredVP ip vp ** {isWh = True} ; 

    ImpVP vp = {
      s = table {
        True  => vp.verb.s ! VF Imperativ ++ vp.compl.s ! defaultAgr;
        False => vp.verb.s ! VF Imperativ ++ "inte" ++ vp.compl.s ! defaultAgr
      }
    } ;

-- Verb
    UseV v = {
      verb = verb2gverb v ;
      compl = str2comp [];
    } ;

    ComplV2 v2 np = {
      verb = verb2gverb v2 ;
      compl =  str2comp (v2.c ++ np.s ! Obj)
    } ;

    ComplVS vs sent = {
      verb = verb2gverb vs ;
      compl = str2comp sent.s
    } ;

    ComplVV vv vp = {
      verb = verb2gverb vv ;
      compl = gv2comp vp.verb
    } ;

    UseComp comp = {
      verb = be_GVerb ;
      compl = comp.s
    } ;

    CompAP ap = {
      s = adj2comp ap
    } ;

    CompNP np = {
      s = str2comp (np.s ! Nom)
    } ;

    CompAdv adv = {
      s = str2comp adv.s
    } ;

    AdvVP vp adv =
      vp ** {compl = add2comp vp.compl adv.s} ;

-- Noun
    DetCN det cn = {
      s = \\c => det.s ! cn.hasComp ! cn.s.g ++ cn.s.s ! det.n ! det.sp ;
      a = Agr det.n det.sp cn.s.g
    } ;

    UsePN pn = {
      s = \\_ => pn.s ;
      a = Agr Sg Def Utr
    } ;

    UsePron p = p ;

    MassNP cn = {
      s = \\_ => cn.s.s ! Sg ! Def ;
      a = Agr Sg Def Utr
    } ;

    a_Det = {
      s = table {
        _ => table {
          Utr => "en" ;
          Neutr => "ett"
        }
      } ;
      n = Sg ;
      sp = Indef
    } ;

    aPl_Det = {
      s = \\_ => \\_ => [];
      n = Pl ;
      sp = Indef
    } ;

    the_Det = {
      s = table {
        True => table {
          Utr => "den" ;
          Neutr => "det"
        } ;
        False => table { _ => [] }
      } ;
      n = Sg ;
      sp = Def
    } ;

    thePl_Det = {
      s = table {
        True => table { _ => "de" } ;
        False => table { _ => [] }
      } ;
      n = Pl ;
      sp = Def
    } ;

    every_Det = {
      s = \\_ => \\_ => "varje";
      n = Sg ;
      sp = Indef
    } ;

    UseN n = {
      s = n ;
      hasComp = False
    };

    AdjCN ap cn = {
      s = {
        g = cn.s.g ;
        s = table {
          n => table {
            sp => ap.s ! n ! sp ! cn.s.g ++ cn.s.s ! n ! sp
          }
        } ;
      } ;
      hasComp = True
    } ;

-- Adjective
    PositA a = a ;

-- Adverb
    PrepNP prep np = {
      s = prep.s ++ np.s ! Obj
    } ;

-- Conjunction
    CoordS conj a b = {s = a.s ++ conj.s ++ b.s} ;

-- Tense
    PPos = {s = [] ; isTrue = True} ;      -- I sleep  [positive polarity]
    PNeg = {s = [] ; isTrue = False} ;     -- I do not sleep [negative polarity]
    TSim = {s = [] ; isPres = True} ;      -- simultanous: she sleeps ---s
    TAnt = {s = [] ; isPres = False} ;     -- anterior: she has slept ---s

-- Structural
    and_Conj = {s = "och"} ;
    or_Conj = {s = "eller"} ;

    in_Prep = {s = "i"} ;
    on_Prep = {s = "på"} ;
    with_Prep = {s = "med"} ;

    i_Pron = {
      s = table {Nom => "jag" ; Obj => "mig"} ;
      a = Agr Sg Def Utr
    } ;
   youSg_Pron = {
      s = table {Nom => "du" ; Obj => "dig"} ;
      a = Agr Sg Def Utr
    } ;
    he_Pron = {
      s = table {Nom => "han" ; Obj => "honom"} ;
      a = Agr Sg Def Utr
    } ;
    she_Pron = {
      s = table {Nom => "hon" ; Obj => "henne"} ;
      a = Agr Sg Def Utr
    } ;
    we_Pron = {
      s = table {Nom => "vi" ; Obj => "oss"} ;
      a = Agr Pl Def Utr
    } ;
    youPl_Pron = {
      s = table {Nom => "ni" ; Obj => "er"} ;
      a = Agr Pl Def Utr
    } ;
    they_Pron = {
      s = table {Nom => "de" ; Obj => "dem"} ;
      a = Agr Pl Def Utr
    } ;

    whoSg_IP = {
      s = table {_ => "vem"} ;
      a = Agr Pl Def Utr
    } ;

    where_IAdv = {s = "var"} ;
    why_IAdv = {s = "varför"} ;

    have_V2 = mkVerb "ha" "har" "hade" "haft" "ha"  ** {c = []} ;
    want_VV = mkVerb "vilja" "vill" "ville" "velat" "vill"  ** {c = []} ;

}