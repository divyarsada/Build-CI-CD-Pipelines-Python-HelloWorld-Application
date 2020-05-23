from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    html = "<h3>Hello World!!</h3>"
    return html.format(format)

if __name__ == "__main__":
    # load pretrained model as clf
    app.run(host='0.0.0.0', port=8000, debug=True) # specify port=80