from bottle import get, route, template, run, request#Importing bottle framework
from plugin import websocket#Importing websocket functionality
from server import GeventWebSocketServer#Importing server
from pymongo import MongoClient#Importing pymongo
from random import randint
import signal
import sys
import smtplib

users=[]#Making an empty list

@route('/')#Defining a default route
def logreg():
    return template('signlog1')#returning a template when the route is entered

@route('/signup')#Defining a named route
def sign():
    return template('signlog1')

@route('/login')
def log():
    return template('signlog1')

@route('/adm')
def adm1():
    return template('adm1')

@route('/utube')
def usr():
    return template('utube')
	
@route('/playlists')
def usr():
    return template('playlists')

usr=[]
dict={}#Definign an empty dictionary
dict1={}
dict2={}


def signal_handler(signal, frame):#Defining a signal handler for handing Ctrl+C
    print('You pressed Ctrl+C!')
    client=MongoClient()
    db=client.dtbs
    db.usrinf3.delete_many({})#Removing all documents from the collection
    sys.exit(0)#Exiting system
signal.signal(signal.SIGINT, signal_handler)
print('Press Ctrl+C')#Printing on console

@route('/ws_utube',apply=[websocket])
def utube(ws):
    client=MongoClient()
    db=client.dtbs
    strin=db.usrinf1.find()#finding all documents
    strin1="0123456789xabcdefgx9876543210"
    for val in strin:
        strin1=val['Usr']
    if(strin1=="0123456789xabcdefgx9876543210"):#checking if the user directly accesses chat page without login
        return
    db.usrinf1.drop()
    users.append(ws)
    db.usrinf3.insert({"Usr":strin1})#Number of online users
    sender=strin1
    str22=sender+" is active"
    str1=sender+" is not active"
    usr.append(sender)
    collection=db.Log
    collection=db.Main_coll#creating collection
    db.Log.insert({
    "new_usr":"New User Enters"
    })
    db.Log.insert({
    "user_status":str22
    })
    msg11=db.curr_playlist.find({'Usr':strin1})
    for val3 in msg11:
        msg1=val3['Curr_Playlist']
        break
    ws.send(msg1)
    db.curr_playlist.drop()
    a1=db.playlist.count({'$and':[{'Usr':strin1},{'Playlist':msg1}]})
    ws.send('Playlist_count'+str(a1))
    strin2=db.playlist.find({'$and':[{'Usr':strin1},{'Playlist':msg1}]})
    c=0
    for val1 in strin2:
        c=c+1
        if(c!=db.playlist.count({'$and':[{'Usr':strin1},{'Playlist':msg1}]})):
            ws.send('Add_song'+val1['Song'])
        if(c==db.playlist.count({'$and':[{'Usr':strin1},{'Playlist':msg1}]})):
            ws.send('Last_song'+val1['Song'])
    cnt=db.playlist.count({'$and':[{'Usr':strin1},{'Playlist':msg1}]})
    while(True):
        msg=ws.receive()#receiving message from user
        if(msg==None or msg=="Offline1234abc5678def90ghij"):#Checking if user has refreshed or closed tab
            break
        if(msg==''):
            continue
        if(msg[:20]=='Add_song_in_playlist'):
            cnt=cnt+1
            db.playlist.insert({"Usr":strin1,"Playlist":msg1,"Song":msg[20:],"count":cnt})
        if(msg[:6]=='Remove'):
            db.playlist.delete_one({'$and':[{'Usr':strin1},{'Playlist':msg1},{'count':int(msg[6:])}]})
            cnt=cnt-1
            db.playlist.update_many({ 'Usr': strin1,'Playlist':msg1,'count': { '$gt': int(msg[6:]) } },{ '$inc': { 'count': -1} })
			
    users.remove(ws)#removing user, now offline
    usr.remove(sender)
    db.usrinf3.delete_one( { "Usr": strin1 } )#user now not in online users list
    db.Log.insert({#inserting logged out status
    "user_status":str1
    })

@route('/ws_playlists', apply=[websocket])
def playlists(ws):
    client = MongoClient()
    db = client.dtbs
    strin2=db.usrinf4.find()#finding all documents
    strin1="0123456789xabcdefgx9876543210"
    for val1 in strin2:
        strin1=val1['Usr']
    if(strin1=="0123456789xabcdefgx9876543210"):#checking if the user directly accesses chat page without login
        return
    strin=db.playlists.find({'Usr':strin1})
    for val in strin:
            ws.send('%'+val['Playlist'])
    while(True):
        msg=ws.receive()
        if(msg==None or msg=="Offline1234abc5678def90ghij"):#Checking if user has refreshed or closed tab
            break
        if(msg==''):
            continue
        if(msg[:13]=='Playlist_name'):
            db.curr_playlist.insert({'Usr':strin1,'Curr_Playlist':msg});    
        if(msg[:4]=='List'):
            db.playlists.insert({'Usr':strin1,'Playlist':msg})			
    db.usrinf4.drop()
	
@get('/ws_signlog', apply=[websocket])
def ws_signlog(ws):
    client = MongoClient()
    db = client.dtbs
    while(True):
        usrnm=ws.receive()#receiving username
        if(usrnm is None):#checking if connection is closed
            break
        usrid=ws.receive()#receiving usrid and other values
        pwd=ws.receive()
        stat=ws.receive()
        if(stat=='Signup'):#Checking the value of stat, here signup
            if(db.usrinf.find_one({'$and':[#Finding the document in 'usrinf' colection with user id equal to the one entered
            {"UserID":usrid}
            ]}) is None):#if no user id found, i.e, no duplicate, then data inserted in database
                db.usrinf.insert({
                "Username":usrnm,
                "UserID":usrid,
                "Password":pwd,
                "Status":stat,
                "Type":"User"
                })
                db.usrinf2.insert({"Usr":usrid})#Used to later find out number of total users
                db.usrinf1.insert({"Usr":usrid})
                db.usrinf4.insert({"Usr":usrid})
                str5=usrnm+" signed up with User ID: "+usrid
                db.Log.insert({"sign_up":str5})#Storing in log
                ws.send("Signup successfull, redirecting...")
            else:
                ws.send("Account already exists, please try again with different credentials")#If account already exists, then declined
        if(stat=='Login'):#Used for finding if Login entered
            if(db.usrinf.find_one({'$and':[#Finding a document to see if it matches the given credentials
            {"UserID":usrid},{"Password":pwd},{"Username":usrnm}
            ]}) is not None):#If it matches, info is stored and user logged in
                db.usrinf1.insert({"Usr":usrid})
                db.usrinf4.insert({"Usr":usrid})
                str6=usrnm+" logged in with User ID: "+usrid
                db.Log.insert({"login":str6})
                ws.send("Login successfull, redirecting...")
            else:
                ws.send("Wrong credentials, please try again!")#Otherwise error message displayed

@get('/ws_adm', apply=[websocket])#Defining functionality for a given route
def adm(ws):#Function to handle functionality
    client = MongoClient()
    db = client.dtbs
    while(True):
        str1=ws.receive()#Receiving from adm.tpl a "Send" message which indicates to send current database values of total and online users
        if(str1 is None):
            break
        if(str1=="Send"):
            n=db.usrinf2.count()#Counting documents in the 'usrinf2' collection
            n1=db.usrinf3.count()
            ws.send("abc"+str(n)+":"+str(n1))#Sending the data in the form of a unique string, so that data can be extracted in adm.tpl
			
@get('/refresh')
def refresh():
    client = MongoClient()#Creating an instance of MongoDB
    db = client.dtbs#Defining a database
    db.Log.drop()#Clearing an entire collection
    db.Main_coll.drop()
    db.usrinf.drop()
    db.usrinf1.drop()
    db.usrinf2.drop()
    db.usrinf3.drop()
    db.usrinf4.drop()
    db.playlist.drop()
    db.playlists.drop()
    db.curr_playlist.drop()

run(host='localhost', port=8080, server=GeventWebSocketServer)#Running the server and listening on the given port of the mentioned url