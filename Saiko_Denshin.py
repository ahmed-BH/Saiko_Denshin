# coding=utf-8
from pyswip import *
from bottle import *
from json import loads
from beaker.middleware import SessionMiddleware

def not_in_question( list_item , list_de_dict) :
    # list_item = [almend,tun]
    res = []  
    for item in list_item :
        for i in list_de_dict :
            if i.keys()[0] == item :
                res.append( list_de_dict.index(i) )
                break
        else :
            res.append(-1)
    
    return -1 in res,res
    #fin

def incrementer(list_item,list_index , criteria,question):
    
    # exemple : question = { nationality : [ {tn :1} , {allmnd : 2} ] }
    # list the first time is empty so niq fn return -1
    
    for i in range( len(list_index) ) :
        if list_index[i] == -1 :
            tmp = {}
            tmp[list_item[i]] = 1
            question[criteria].append(tmp)
        else :
            question[criteria][ list_index[i] ][ list_item[i] ] += 1
    
    return question
    #fin
    
# criteria_value = >25 ou germany
def eliminate_suspects( criteria_value , r , cri,suspects) :
    global p 

    if ">" in criteria_value :
        if r == "yes" :
            criteria_value = criteria_value.replace(">","l")
        else:
            criteria_value = criteria_value.replace(">","g")
        
        res = list(p.query("%s2(%s,N)"%(cri,criteria_value)))

    elif "<=" in criteria_value :
        if r == "yes" :
            criteria_value = criteria_value.replace("<=","g")
        else:
            criteria_value = criteria_value.replace("<=","l")
        
        res = list(p.query("%s2(%s,N)"%(cri,criteria_value)))
        
    else :
        
        res = list(p.query('%s2("%s",%s,N)' %(cri,criteria_value,r)))
        
    
    for i in res :
        try :
            suspects.remove(i["N"])
        except ValueError as e :
            continue
    print "suspects : ",
    print suspects
    return suspects
    #fin



def main(response,suspects,criteria_value,ceq,askonce) :
    # criteria_value : crite_value,ceq=criteria_to_ask
    global p
    
    if response != 'firstime' : 
        # eliminating suspects we are not interested in !
        suspects = eliminate_suspects(criteria_value,response,ceq,suspects)

    questions = [ 
                    {"nationality" : ["The person is from "] },
                    {"age" : ["The person is aged "]},
                    {"height" : ["The person's height is "]},
                    {"rated_at" : ["The person is rated at "]},
                    {"fights" : ["The person's fights games "]},
                    {"wins" : ["The person won "]},
                    {"wKO" : ["The person won with k.O "]},
                    {"losses": ["The person lost "]},
                    {"titles" : ["The person nominated "]}
                ]
    

    # liste des personnage 
    criteria =  ["nationality","age","height","rated_at","fights","wins","wKO","losses","titles"]
    typ = ["str","int","int","str","int","int","int","int","str"]
    criteria_to_ask = ""

    question = {}
    # if we don't find at least 45% occ then we choose the max occ.
    # max_nb [cri,item,occ] exm: [natio,tn,2]
    max_nb = ["","",0]

    # we don't ask the same question 2 times in arrow.
    dontask = ""
       
    #construire question
    nb_susp = len(suspects)
    if nb_susp == 0 : return "","","",suspects,[]
    elif nb_susp == 1 : return "","","",suspects,[]
    else :

        for i in criteria :
            if i == ceq or i in askonce :
                continue
            
            # show all info criteria of i
            result = list(p.query("%s(X,%s)" %(i,str(suspects))))
            question[i] = []

            t = typ[criteria.index(i)]
            # type of info of critiria i is string
            if t == "str" :
                # calcule occurrence des donnée de criteria i str info
                for res in result :
                    # res[X] can be allmend__armenie
                    tmp_res = res["X"].split("__")
                    verif,verif_res = not_in_question( tmp_res , question[i] )
                    # verif_res = [1,1,-1]
                    if verif :
                        for o in range(len(verif_res)) :
                            if verif_res[o] == -1 :
                                tmp = {}
                                tmp[ tmp_res[o] ] = 1
                                question[i].append(tmp)
                                del(tmp)
                    else :
                        question = incrementer(tmp_res,verif_res, i,question)
                        # verif_res contain index so i won't recalculate them
            else :
                # int information
                # calculate averge
                # question { age : [ {>mo : 5} {<=avg:2}]}
                avg = 0
                l = len(result)
                for res in result :
                    avg += int(res["X"][3:])
                try :
                    avg = avg / l
                except ZeroDivisionError as e :
                    pass    
                del(l)
                
                tmp = {}
                tmp[">"+str(avg)] = 0
                question[i].append(tmp)
                del tmp
                
                tmp = {}
                tmp["<="+str(avg)] = 0
                question[i].append(tmp)
                del tmp
                
                for res in result :
                    
                    if int(res["X"][3:]) <= avg :
                        question[i][1]["<="+str(avg)] += 1
                    else :
                        question[i][0][">"+str(avg)] += 1
           
            # fin calculate averge / occ

            # try if we can have 2 big group so wwe can ask about this criteere

            
            for check in question[i] :
                nb = check.values()[0]
                # check if value present 45% -> 55 % of nb suspects
                if nb >= nb_susp * 0.45 and nb <= nb_susp * 0.55 :
                    # exemple ceq = nationality ; criteria_value = allmend
                    criteria_to_ask = i
                    criteria_value = check.keys()[0]
                    break
                if nb > max_nb[2] and nb < nb_susp:
                    max_nb[0] = i
                    max_nb[1] = check.keys()[0]
                    max_nb[2] = nb 

            # we found what to ask about,so we exit this process
            if criteria_to_ask :
                break

        #when for ends without finding a question
        else :
            criteria_to_ask = max_nb[0]
            criteria_value = max_nb[1]
        
        # end found what to ask loop process 
        
        if t == "str" : askonce.append(dontask)
        # asking the question (just testing, needs work)
        question_tmp =questions[criteria.index(criteria_to_ask)][criteria_to_ask][0] + criteria_value + " ?"
        return question_tmp,criteria_value,criteria_to_ask,suspects,askonce

# end main function

session_opts = {
    'session.type': 'file',
    'session.cookie_expires': True,
    'session.data_dir': './data',
    'session.auto': True
}
beaker_app = SessionMiddleware(app(),session_opts)

@route("/")
def index() :
    return template("jarvis.htm")

@route("/about")
def about() :
    return template("about.htm")

@route('/static/<filepath:path>')
def return_static(filepath) :
    return static_file(filepath , root = "./static")

@route("/initgame")
def init_game () :
    global p
    session = request.environ.get('beaker.session')
    
    suspects = [ i['X'] for i in list(p.query("is_boxer(X)")) ]
    session['suspects'] = suspects
    session['askonce'] = []
    session['criteria_value'] = ""
    session['ceq'] = ""
    session['user_answers'] = []
    print "****************************"
    

@route('/response')
def guessing () :
    response = request.query.res
    print response
    session = request.environ.get('beaker.session')
    
    exist = session.get('suspects',0)
    if exist != 0 :
        suspects = exist
        askonce = session['askonce']
        criteria_value = session['criteria_value']
        ceq = session['ceq']
    else :
        redirect('/initgame')

    question,criteria_value,ceq,suspects,askonce = main(response,suspects,criteria_value,ceq,askonce)

    print "*********************"

    if response != "firstime" :
        # save old criteria_value + recent res
        session["user_answers"].append( [ session['ceq'],session['criteria_value'],response ] )
    
    if question :
        session['suspects'] = suspects
        session['askonce'] = askonce
        session['criteria_value'] = criteria_value
        session['ceq'] = ceq
        
        return {"question" : question,"suspects": len(suspects)}

    else :
        user_answers = session["user_answers"]
        session.delete()
        return {"suspects" : suspects,"answers" : user_answers }

@route("/save")
def save():
    global p
    bx = request.query.boxer
    bx = loads(bx)
    line = "";
    for i in bx :
        line += i.values()[0] + ","
    
    f = open("boxers.pl","a")
    f.write("\nboxeur("+line[:len(line)-1]+").")
    f.close()    

    p.consult("boxers.pl")
    
if __name__ == "__main__" :
    p = Prolog()
    p.consult("../Saiko_Denshin/boxers.pl")
    run (app=beaker_app,host="0.0.0.0",port=8080,debug=True,reloader = True)