from concurrent.futures import thread
from flask import Flask, render_template
from waitress import serve

app = Flask(__name__)


@app.route('/')
def index():
    mountains = ['Everest', 'K2', 'Kilimanjaro']
    return render_template('index.html', mountain=mountains)

@app.route('/mountain/<mt>')
def mountain(mt):
    return "This is " + str(mt)

if __name__ == "__main__":
    print("app is running")
    #serve(app,host='0.0.0.0', port=5010,threads = 2)
    app.run(host='0.0.0.0', port=80,debug=True)