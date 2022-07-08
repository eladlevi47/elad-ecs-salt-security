from flask import Flask, render_template
app = Flask(__name__)

@app.route("/v1/test")
def test():
    return render_template("test.html")

@app.route("/v1/health")
def health():
    return render_template("health.html")