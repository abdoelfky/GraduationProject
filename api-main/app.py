from flask import Flask, request
import pickle
app = Flask(__name__)


@app.route('/')
def index():
   print('Request for index page received')
   return "welcome to api"


@app.route('/predict', methods=['POST'])
def predict():
    model = pickle.load(open('SVC.pkl', 'rb'))
    wifi1 = request.args.get("wifi1")
    wifi2 = request.args.get("wifi2")
    wifi3 = request.args.get("wifi3")
    wifi4 = request.args.get("wifi4")
    wifi5 = request.args.get("wifi5")
    if wifi1 and wifi2 and wifi3 and wifi4 and wifi5:
        prediction = model.predict([[int(wifi1), int(wifi2), int(wifi3), int(wifi4), int(wifi5)]])
        return f"{prediction[0]}"
    return "please provide correct number of prameters"


if __name__ == '__main__':
   app.run()